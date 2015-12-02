//
//  PersonModel.h
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic,copy)   NSString *firstName;
@property (nonatomic,copy)   NSString *lastName;
@property (nonatomic,copy)   NSString *name1; //这个用排序用的，和phonename是一样的
@property (nonatomic,copy)   NSString *phoneNumber;
@property (nonatomic,copy)   NSString *phonename;
@property (nonatomic,copy)   NSString *friendId;
@property (nonatomic,assign) NSInteger sectionNumber;
@property (nonatomic,assign) NSInteger recordID;
@property BOOL rowSelected;
@property (nonatomic, strong)  NSString *email;
@property (nonatomic, strong)  NSString *tel;
@property (nonatomic, strong) NSData *icon;//图片

@end
