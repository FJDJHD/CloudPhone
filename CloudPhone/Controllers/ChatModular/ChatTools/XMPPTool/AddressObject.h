//
//  AddressObject.h
//  CloudPhone
//
//  Created by wangcong on 15/12/17.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PersonModel.h"
#import "NSString+Util.h"


@interface AddressObject : NSObject

@property (nonatomic, strong) NSMutableArray *allAddress;

+(instancetype)shareInstance;


//获取通讯录
- (NSMutableArray *)getAllPerson;

@end
