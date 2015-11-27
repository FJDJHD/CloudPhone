//
//  GeneralToolObject.h
//  cloudbox_client_ios
//
//  Created by mc on 15/4/28.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralToolObject : NSObject


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//字符串转字典
- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
