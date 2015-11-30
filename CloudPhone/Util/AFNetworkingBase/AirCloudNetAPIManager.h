//
//  AirCloudNetAPIManager.h
//  AirCloud
//
//  Created by mc on 15/3/31.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirCloudNetAPIClient.h"

@interface AirCloudNetAPIManager : NSObject

+ (instancetype)sharedManager;

//发送注册验证码
- (void)getPhoneNumberVerifyOfParams:(NSDictionary *)params
                         WithBlock:(void (^)(id data, NSError *error))block;

//注册第一步
- (void)registerStepOneOfParams:(NSDictionary *)params
                      WithBlock:(void (^)(id data, NSError *error))block;

//注册第二步
- (void)registerStepTwoOfParams:(NSDictionary *)params
                           WithBlock:(void (^)(id data, NSError *error))block;



////获取服务器信息
//- (void)getServersInfoOfParams:(NSDictionary *)params
//                     WithBlock:(void (^)(id data, NSError *error))block;
//
////获取视频信息
//- (void)getVedioInfoOfParams:(NSDictionary *)params
//                     WithBlock:(void (^)(id data, NSError *error))block;
//
////获取视频URL信息
//- (void)getVedioURLInfoOfParams:(NSDictionary *)params
//                   WithBlock:(void (^)(id data, NSError *error))block;
//
////更新视频观看人数
//- (void)getVedioWatchCountOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block;
//
////获取手机验证码
//- (void)getPhoneNumberVerifyOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block;
//
////提交验证码
//- (void)submitVerifyOfParams:(NSDictionary *)params
//                   WithBlock:(void (^)(id data, NSError *error))block;
//
////提交注册信息
//- (void)submitRegisterInfoOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block;
//
////获取忘记密码验证码
//- (void)getForgetPwdVerifyOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block;
//
////忘记密码修改密码
//- (void)submitForgetPasswordOfParams:(NSDictionary *)params
//                           WithBlock:(void (^)(id data, NSError *error))block;

@end
