//
//  GeneralToolObject.m
//  cloudbox_client_ios
//
//  Created by mc on 15/4/28.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import "GeneralToolObject.h"
#import "Global.h"
#import "NSString+MD5.h"

@implementation GeneralToolObject

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData
                                                      options:NSJSONReadingAllowFragments
                                                      error:nil];
    return responseJSON;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    //不要json分隔行线 需要把NSJSONWritingPrettyPrinted 改成 “0“
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSString *)CPUuidString{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

+ (NSString *)requestHeaderValue {
    long timeInt =[[NSDate date] timeIntervalSince1970];
    NSString *imei = [self CPUuidString];
    NSString *versionName = APP_VERSION;
    NSString *version = APP_BUNDLEID;
    
    NSString *time = [NSString stringWithFormat:@"%ld",timeInt];
    NSString *md5VersionName = [versionName md5];
    NSString *md5imei = [imei md5];
    
    NSString *tokenq = [NSString stringWithFormat:@"%@%@%@itel2105@@$*",md5VersionName,md5imei,time];
    
    NSString *tokens = [NSString stringWithFormat:@"%@",[tokenq md5]];
    
    NSString *value = [NSString stringWithFormat:@"itel_version/%@ version/%@ from/ios imei/%@ key/%@ time/%@ token/%@ mobile_model/iphone",versionName,version,imei,md5imei,time,tokens];
    return value;
}







@end
