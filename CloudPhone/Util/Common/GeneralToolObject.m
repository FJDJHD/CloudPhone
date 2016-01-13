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

@implementation GeneralToolObject{
     Reachability *reachablity;
}

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

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData
                                                      options:0
                                                      error:nil];
    return responseJSON;
}

+ (NSString*)dictionaryToJson:(id)resource{
    //不要json分隔行线 需要把NSJSONWritingPrettyPrinted 改成 “0“
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resource options:0 error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSString *)CPUuidString{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

+ (NSString *)requestHeaderValue {
    long timeInt =[[NSDate date] timeIntervalSince1970];
    NSString *imei = [UniqueUDID shareInstance].udid;
    NSString *versionName = APP_BUNDLEID;
    NSString *version = APP_VERSION;
    
    NSString *time = [NSString stringWithFormat:@"%ld",timeInt];
    NSString *md5VersionName = [versionName md5];
    NSString *md5imei = [imei md5];
    
    NSString *tokenq = [NSString stringWithFormat:@"%@%@%@itel2105@@$*",md5VersionName,md5imei,time];
    
    NSString *tokens = [NSString stringWithFormat:@"%@",[tokenq md5]];
    
    NSString *value = [NSString stringWithFormat:@"itel_version/%@ version/%@ from/ios imei/%@ key/%@ time/%@ token/%@ mobile_model/iPhone mobile_type/iphone",versionName,version,imei,md5imei,time,tokens];
    return value;
}


#pragma mark -- 判定密码强度
//判断是否包含
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password

{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}


//个人头像保存在沙盒
+ (NSString *)personalIconFilePath:(NSString *)num {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"icon%@.png",num]];
    return filePath;
}

//保存在plist文件中
+ (NSString *)personalInfoFilePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"personalInfo.plist"];
    return filePath;
}

//个人信息写入沙盒
+ (void)writePersonalInfoToBox:(NSDictionary *)dic {
    //写入沙盒
//    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
//    [infoDic setValue:iconPath forKey:@"personalIcon"];
//    [infoDic setValue:@"王聪" forKey:@"personalName"];
//    [infoDic setValue:@"13113689077" forKey:@"personalNumber"];
    BOOL result = [dic writeToFile:[self personalInfoFilePath] atomically:YES];
    if (result) {
        DLog(@"缓存成功");
    }

}

+ (void)userLogin {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"isLogined" forKey:isLoginKey];
    [defaults synchronize];
    
    //进入主页
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDele loadMainViewController];
}

+ (void)userLoginOut {
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:UserNumber];
    
    //清空个人信息数据库
    [DBOperate deleteData:T_personalInfo tableColumn:@"phoneNum" columnValue:number];

    //断开xmpp连接
    [appDele disconnect];
    [defaults removeObjectForKey:UserNumber];
    
    [defaults setObject:@"notLogined" forKey:isLoginKey];
    [defaults synchronize];
    //进入
    [appDele loadLoginViewController];
}

+ (void)saveuserNumber:(NSString *)num password:(NSString *)pwd {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:num forKey:UserNumber];
    [defaults setObject:pwd forKey:UserPassword];
    [defaults setObject:num forKey:OtherLoginNumber];
    [defaults synchronize];
}

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (NSString *)compareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    
    int temp = 0;
    
    NSString *result;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
    
}

//条件
+ (int) judgePasswordStrength:(NSString*) _password

{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
        
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    
    int  result = 0;
    if (intResult <2)
    {
        result = 0;
    }
    else if (intResult == 2&&[_password length]>=6)
    {
        result = 1;
    }
    
    if (intResult > 2&&[_password length]>=6)
    {
        result = 2;
    }
    return result;
}


+ (BOOL)isEnableCurrentNetworkingStatus{
    BOOL isWifi = NO;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isWifi = NO;
            break;
        case ReachableViaWWAN:
            isWifi =YES;
            break;
        case ReachableViaWiFi:
            isWifi = YES;
            break;
        default:
            break;
    }
    return isWifi;
}



@end
