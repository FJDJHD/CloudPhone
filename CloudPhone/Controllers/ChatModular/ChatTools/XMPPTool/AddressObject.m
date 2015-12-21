//
//  AddressObject.m
//  CloudPhone
//
//  Created by wangcong on 15/12/17.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "AddressObject.h"


@implementation AddressObject

+(instancetype)shareInstance {
    static AddressObject *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AddressObject alloc]init];
    });
    return instance;
}

- (NSMutableArray *)allAddress {

    return [self getAllPerson];
}

/**
 *  请求访问通讯录
 */


#pragma mark - 获取通讯录内容
- (NSMutableArray *)getAllPerson {
    NSMutableArray *addressBookArray =[NSMutableArray array];
    NSMutableArray *listContent = [NSMutableArray array];
    NSMutableArray *sectionTitleArray = [NSMutableArray array];
    
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i = 0; i < nPeople; i ++) {
        PersonModel *model = [[PersonModel alloc]init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@ %@",nameString,lastNameString];
            }
        }
        
        model.name1 = nameString;
        model.phonename = nameString;
        model.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID mutiProperties[] = {
            kABPersonPhoneProperty, //电话
            kABPersonEmailProperty  //邮箱
        };
        
        NSInteger multiPropertiesTotal = sizeof(mutiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j ++) {
            ABPropertyID property = mutiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) {
                valuesCount = ABMultiValueGetCount(valuesRef);
            }
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            for (NSInteger k = 0; k < valuesCount; k ++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0:  //phone number
                        model.tel = [(__bridge NSString *)value initTelephoneWithReformat];
                        break;
                        
                    default:
                        model.email = (__bridge NSString *)value;
                        break;
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
            
        }
        [addressBookArray addObject:model];
        if (abName) {
            CFRelease(abName);
        }
        if (abLastName) {
            CFRelease(abLastName);
        }
        if (abFullName) {
            CFRelease(abFullName);
        }
    }
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    //对数组排序，按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [sectionTitleArray removeAllObjects];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    [sectionTitleArray addObjectsFromArray:[theCollation sectionTitles]];
    
    for (PersonModel *person in addressBookArray) {
        if (person.name1 != nil) {
            NSInteger sect = [theCollation sectionForObject:person collationStringSelector:@selector(name1)];
            person.sectionNumber = sect;
        }
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count]; //27
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (NSInteger i = 0; i <= highSection; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //把对应的名字放入这个27个数组中,将每个人按name分到某个section下
    for (PersonModel *person in addressBookArray) {
        [sectionArrays[person.sectionNumber] addObject:person];
    }
    
    for (NSMutableArray *temp in sectionArrays) {
        PersonModel *person = (PersonModel *)temp.firstObject;
        if (person.name1 == nil || [person.name1 isEqualToString:@""]) {
            continue;
        }
        if (person.name1 != nil) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:temp collationStringSelector:@selector(name1)];
            [listContent addObject:sortedSection];
        }
    }
    return listContent;
}


@end
