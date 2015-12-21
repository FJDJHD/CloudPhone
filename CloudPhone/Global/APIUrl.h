//
//  APIUrl.h
//  AirCloud
//
//  Created by mc on 15/3/30.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#ifndef AirCloud_APIUrl_h
#define AirCloud_APIUrl_h

#define Code_CookieData               @"sessionCookies"


//发送注册验证码
#define API_sendVerify                                   @"?s=/Home/User/sendVerify"

//注册第一步
#define API_register                                     @"?s=/Home/User/register"

//注册第二步
#define API_register2                                    @"?s=/Home/User/register2"

//用户名登录
#define API_login                                        @"?s=/Home/User/login"//post

//用户退出
#define API_logout                                       @"?s=/Home/User/logout"

//发送找回密码验证码
#define API_sendFoundVerify                              @"?s=/Home/User/sendVerify"//post/get

//找回密码提交
#define API_forget_pwd                                  @"?s=/Home/User/forget_pwd" //post

//找回密码，重设密码
#define API_forget_pwd2                                 @"?s=/Home/User/forget_pwd2" //post

//修改密码提交
#define API_profile                                     @"?s=/Home/User/profile" //post

//修改账户信息提交
#define API_updateUser                                  @"?s=/Home/User/updateUser" //post

//更新头像信息提交
#define API_updatePhoto                                 @"?s=/Home/User/updatePhoto" //post

//用户中心首页
#define API_getUserCenter                               @"?s=/Home/User/index"

//用户中心基本信息
#define API_getUserCenter_info                          @"?s=/Home/User/index" //get

//帮助与反馈
#define API_getHelpCenter_info                          @"?s=/Home/User/helpFeedback"//get

//存储openfire发送的消息
#define API_sendOpenireMessage                          @"?s=/Home/Openfire/sendOpenireMessage"

//通讯录itel好友列表
#define API_mailList                                    @"?s=/Home/Openfire/mailList"

#endif
