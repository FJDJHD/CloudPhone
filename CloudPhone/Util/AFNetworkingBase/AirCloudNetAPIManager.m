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
    
     [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_register serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//注册第二步
- (void)registerStepTwoOfParams:(NSDictionary *)params
                      WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_register2 serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];

}


//用户名登录
- (void)userLoginOfParams:(NSDictionary *)params
                WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_login serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data, error);
    }];
}

//用户退出
- (void)userLogoutWithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_logout serviceType:HTTPURLPREFIX withParams:nil withMethodType:Get andBlock:^(id data, NSError *error){
        
        block(data, error);
    }];
}

//发送找回密码验证码
- (void)sendFoundVerifyOfParams:(NSDictionary *)params
                      WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_sendFoundVerify serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//找回密码提交
- (void)submitFoundPasswordOfParams:(NSDictionary *)params
                          WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_forget_pwd serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//找回密码,重设密码
- (void)rePasswordOfParams:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_forget_pwd2 serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//修改密码提交
- (void)profileOfParams:(NSDictionary *)params
              WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_profile serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//修改账户信息提交
- (void)updateUserOfParams:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_updateUser serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//更新头像信息提交
- (void)updatePhotoOfImage:(UIImage *)image
                    params:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block {
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    [[AirCloudNetAPIClient sharedJsonClient] uploadImageWithPath:API_updatePhoto serviceType:HTTPURLPREFIX withParams:params withImageContent:@"photo" withImage:image andBlock:^(id data, NSError *error) {
        block(data,error);
    }];
}

//用户中心首页
- (void)getUserCenterOfParams:(NSDictionary *)params
                    WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_getUserCenter serviceType:HTTPURLPREFIX withParams:params withMethodType:Post andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//用户中心基本信息
- (void)getUserCenterInfoOfParams:(NSDictionary *)params
                        WithBlock:(void (^)(id data, NSError *error))block {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_getUserCenter_info serviceType:HTTPURLPREFIX withParams:params withMethodType:Get andBlock:^(id data, NSError *error){
        
        block(data,error);
    }];
}

//帮助与反馈
- (void)getHelpCenterInfoOfParams:(NSDictionary *)params
                        WithBlock:(void(^)(id data, NSError *error))block{
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_getHelpCenter_info serviceType:HTTPURLPREFIX withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data,error);
    }];
    
}

//存储openfire发送消息
- (void)saveSendMessageOfParams:(NSDictionary *)params
                      WithBlock:(void(^)(id data, NSError *error))block {

    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];
    [[AirCloudNetAPIClient sharedJsonClient] requestJsonDataWithPath:API_sendOpenireMessage serviceType:HTTPURLPREFIX withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data,error);
    }];
}

//存储openfire发送消息(图片)
- (void)saveSendPhotoOfImage:(UIImage *)image
                  params:(NSDictionary *)params
                   WithBlock:(void (^)(id data, NSError *error))block; {
    
    [[AirCloudNetAPIClient sharedJsonClient].requestSerializer setValue:[GeneralToolObject requestHeaderValue] forHTTPHeaderField:@"User-Agent"];

    [[AirCloudNetAPIClient sharedJsonClient] uploadImageWithPath:API_sendOpenireMessage serviceType:HTTPURLPREFIX withParams:params withImageContent:@"content" withImage:image andBlock:^(id data, NSError *error) {
        block(data,error);
    }];
    
//    [[AirCloudNetAPIClient sharedJsonClient] uploadImageWithPath:API_sendOpenireMessage serviceType:HTTPURLPREFIX withParams:@"content" withImage:image andBlock:^(id data, NSError *error) {
//        block(data,error);
//    }];
}


@end
