//
//  AirCloudNetAPIManager.m
//  AirCloud
//
//  Created by mc on 15/3/31.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import "AirCloudNetAPIManager.h"
#import "GeneralToolObject.h"

@implementation AirCloudNetAPIManager

+ (instancetype)sharedManager {
    static AirCloudNetAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//发送注册验证码
- (void)getPhoneNumberVerifyOfParams:(NSDictionary *)params
                           WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_sendVerify serviceType:HTTPURLPREFIX withParams:params withMethodType:Get andBlock:^(id data, NSError *error){

        block(data,error);
    }];
}

//注册第一步
- (void)registerStepOneOfParams:(NSDictionary *)params
                      WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_register serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//注册第二步
- (void)registerStepTwoOfParams:(NSDictionary *)params
                      WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_register2 serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];

}


////获取服务器信息
//- (void)getServersInfoOfParams:(NSDictionary *)params
//                     WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_cloudbox_init serviceType:HTTPURLPREFIX_Vedio withParams:params withMethodType:Get andBlock:^(id data, NSError *error){
//        if (data) {
//            id resultData = [data valueForKeyPath:@"servers"];
//            block(resultData, nil);
//        }else{
//            block(nil, error);
//        }
//    }];
//}
//
////获取视频信息
//- (void)getVedioInfoOfParams:(NSDictionary *)params
//                   WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_get_main_page serviceType:HTTPURLPREFIX_Vedio withParams:params withMethodType:Get andBlock:^(id data, NSError *error){
//        if (data) {
//            id resultData = [data valueForKeyPath:@"videos"];
//            block(resultData, nil);
//        }else{
//            block(nil, error);
//        }
//    }];
//}
//
////获取视频URL信息
//- (void)getVedioURLInfoOfParams:(NSDictionary *)params
//                      WithBlock:(void (^)(id data, NSError *error))block {
//    
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_get_playurl serviceType:HTTPURLPREFIX_Vedio withParams:params withMethodType:Get andBlock:^(id data, NSError *error){
//        if (data) {
//            id resultData = [data valueForKeyPath:@"playurl"];
//            block(resultData, nil);
//        }else{
//            block(nil, error);
//        }
//    }];
//}
//
////更新视频观看人数
//- (void)getVedioWatchCountOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_update_view serviceType:HTTPURLPREFIX_Vedio withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
//        if (data) {
//            id resultData = [data valueForKeyPath:@"views"];
//            block(resultData,nil);
//        }else {
//            block(nil, error);
//        }
//    }];
//}
//
////获取手机验证码
//- (void)getPhoneNumberVerifyOfParams:(NSDictionary *)params
//                           WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_pre_register serviceType:HTTPURLPREFIX_AAA withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            id resultData = [data valueForKeyPath:@"veri_code"];
//            block(resultData,nil);
//        }else {
//            block(nil, error);
//        }
//    }];
//}
//
////提交验证码
//- (void)submitVerifyOfParams:(NSDictionary *)params
//                   WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_verify_code serviceType:HTTPURLPREFIX_AAA withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            block(data,nil);
//        }else {
//            block(nil, error);
//        }
//    }];
//}
//
////提交注册信息
//- (void)submitRegisterInfoOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_register serviceType:HTTPURLPREFIX_AAA withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            block(data,nil);
//        }else {
//            block(nil, error);
//        }
//    }];
//}
//
////获取忘记密码验证码
//- (void)getForgetPwdVerifyOfParams:(NSDictionary *)params
//                         WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_request_vericode serviceType:HTTPURLPREFIX_AAA withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            id resultData = [data valueForKeyPath:@"veri_code"];
//            block(resultData,nil);
//        }else {
//            block(nil, error);
//        }
//    }];
//}
//
////忘记密码修改密码
//- (void)submitForgetPasswordOfParams:(NSDictionary *)params
//                           WithBlock:(void (^)(id data, NSError *error))block {
//    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_forget_password serviceType:HTTPURLPREFIX_AAA withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            block(data,nil);
//        }else {
//            block(nil, error);
//        }
//    }];
//
//}



@end
