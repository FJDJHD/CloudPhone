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

//用户名登录
- (void)userLoginOfParams:(NSDictionary *)params
                WithBlock:(void (^)(id data, NSError *error))block;

//用户退出
- (void)userLogoutWithBlock:(void (^)(id data, NSError *error))block ;

//发送找回密码验证码
- (void)sendFoundVerifyOfParams:(NSDictionary *)params

                      WithBlock:(void (^)(id data, NSError *error))block;
//找回密码提交
- (void)submitFoundPasswordOfParams:(NSDictionary *)params

                          WithBlock:(void (^)(id data, NSError *error))block;
//找回密码,重设密码
- (void)rePasswordOfParams:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block;
//修改密码提交
- (void)profileOfParams:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block;

//修改账户信息提交
- (void)updateUserOfParams:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block;

//更新头像信息提交
- (void)updatePhotoOfImage:(UIImage *)image
                    params:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block;

//用户中心首页
- (void)getUserCenterOfParams:(NSDictionary *)params
                    WithBlock:(void (^)(id data, NSError *error))block;

//用户中心基本信息
- (void)getUserCenterInfoOfParams:(NSDictionary *)params
                        WithBlock:(void (^)(id data, NSError *error))block;
//帮助与反馈
- (void)getHelpCenterInfoOfParams:(NSDictionary *)params
                        WithBlock:(void(^)(id data, NSError *error))block;

//存储openfire发送消息(文字)
- (void)saveSendMessageOfParams:(NSDictionary *)params
                        WithBlock:(void(^)(id data, NSError *error))block;

//存储openfire发送消息(图片)（暂时取消了这个接口）
- (void)saveSendPhotoOfImage:(UIImage *)image
                 params:(NSDictionary *)params
                 WithBlock:(void (^)(id data, NSError *error))block;

//好友列表
- (void)postMailListOfParams:(NSDictionary *)params
              WithBlock:(void (^)(id data, NSError *error))block;


//添加openfire好友，走接口这边（暂时没用这个接口。。。。）
- (void)addOpenfireFriendOfParams:(NSDictionary *)params
                        WithBlock:(void (^)(id data, NSError *error))block;

//回拨
- (void)callBackOfParams:(NSDictionary *)params
               WithBlock:(void (^)(id data, NSError *error))block;

//链接通话平台
- (void)linkRongLianInfoOfParams:(NSDictionary *)params
                       WithBlock:(void (^)(id data, NSError *error))block;


//话费查询
- (void)queryTelphoneFareOfParams:(NSDictionary *)params
                        WithBlock:(void (^)(id data, NSError *error))block;

//上传推送registrationID
- (void)postPushRegistrationIDOfParams:(NSDictionary *)params
                             WithBlock:(void (^)(id data, NSError *error))block;

//电话聊天推送
- (void)postPushMessageOfParams:(NSDictionary *)params
                             WithBlock:(void (^)(id data, NSError *error))block;


@end
