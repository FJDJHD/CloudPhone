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

//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//设备的唯一标示
+ (NSString *)CPUuidString;

//请求头User-Agent的value
+ (NSString *)requestHeaderValue;

//密码强度
+ (int) judgePasswordStrength:(NSString*) _password;
@end
