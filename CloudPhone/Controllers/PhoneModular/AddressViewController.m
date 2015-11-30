//
//  AddressViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "AddressViewController.h"
#import <AddressBook/AddressBook.h>
#import "PersonModel.h"
#import "NSString+Util.h"

@interface AddressViewController ()

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (NSMutableArray *)getAllPerson {

    NSMutableArray *addressBookArray =[NSMutableArray array];
    
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取通讯录访问授权
    ABAuthorizationStatus authorization = ABAddressBookGetAuthorizationStatus();
    if (authorization != kABAuthorizationStatusAuthorized) {
        NSLog(@"未获取通讯录访问授权");
        return nil;
    }
    
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
            NSLog(@"nameString = %@",nameString);
        } else {
        
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@ %@",nameString,lastNameString];
                NSLog(@"nameString = %@",nameString);
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
    
    return addressBookArray;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
