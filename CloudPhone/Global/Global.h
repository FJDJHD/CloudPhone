//
//  Global.h
//  AirCloud
//
//  Created by mc on 15/3/30.
//  Copyright (c) 2015年 mc. All rights reserved.
//


#ifndef Sesame_ENVIRONMENT

#define Sesame_ENVIRONMENT 0 //0:开发环境 1:测试环境 2:生产环境 3:预生产环境 999:挡板环境


#if Sesame_ENVIRONMENT==0
#define HTTPURLPREFIX         @"http://203.195.196.37:8090"

#elif Sesame_ENVIRONMENT==1
#define HTTPURLPREFIX         @"http://192.168.1.103:8080"

#elif Sesame_ENVIRONMENT==2
#define HTTPURLPREFIX         @"http://dasudian.com:8090"


#elif Sesame_ENVIRONMENT==3
#define HTTPURLPREFIX @"－－－－－－"
#endif
#endif

///*友盟key***u:wc@dasudian.com p:wangcong123456  */
//#define umengKey         @"552f876cfd98c56d48000d69"
//
//
//
///*百度地图key*/  //u:wc@dasudian.com p:wangcong123456
//#define baiduKey               @"AXgUw57uLjtHzOjh6lhTOb51"
//
//
//
///* 分享key--u:wc@dasudian.com p:wangcong123456 (sina用的自己的账号)放这里*/
////微信（https://open.weixin.qq.com/）
//#define ShareWeixinAPPId           @"wx0f3a1d4402f240da"
//#define ShareWeixinAppSecret       @"213d337aece60660e6d6d5bb99f05355"
//#define ShareWeixinRedirectURL     @"http://app.dasudian.com"
//
////QQ(http://connect.qq.com/manage/index)
//#define ShareQQAPPId          @"1104542208"
//#define ShareQQAPPKey          @"KXScVCcsapsId5Fl"
//#define ShareQQRedirectURL     @"http://app.dasudian.com"
//
////Sina(http://open.weibo.com/apps/new?sort=mobile) (u:13113689077  p:a13113689077)
//#define ShareSinaAPPKey        @"1371099025"
//#define ShareSinaRedirectURI   @"http://app.dasudian.com"


/* tag的初始值，统一放在这里－－－－*/
//#define MainChannelClassButtonOriginTag       1000     //频道模块的频道分类
//#define MainChannelPopularImageOriginTag      2000     //频道模块的热门演员
//#define MainChannelFeatureButtonOriginTag     3000     //频道模块的特色标签
//#define MainMineHistoryButtonOriginTag        4000     //我的模块的观看历史
//#define MainCloudBoxImageViewOriginTag        5000     //云盒模块的图片tag
//#define MainCloudBoxDeleteButtonOriginTag     6000     //云盒模块的删除按钮tag
//#define MainMineMarkOwnButtonOriginTag        7000     //我的模块标签编辑已属标签tag
//#define MainMineMarkSelectButtonOriginTag     8000     //我的模块标签编辑可选标签tag


/* notifitionCenter通知的name统一放在这里－－－－*/
#define vedioEnterForeground            @"vedioEnterForeground" //视频播放从后台转前台

#define vedioInfoAfterCookie            @"vedioInfoAfterCookie" //请求到cookie后执行这个


/* 统一的色调 －－－－*/

//导航栏颜色
#define appNavgationBackColor   [UIColor colorWithRed:79.0/255.0 green:176.0/255.0 blue:246.0/255.0 alpha:1.0]
#define appDeepLableColor       RGB(51, 51, 51)


#import <Foundation/Foundation.h>
#import "Macros.h"
#import "AirCloudNetAPIManager.h"
#import "APIUrl.h"
#import "CustomMBHud.h"
#import "UIViewController+NavigationBar.h"
#import "BaseNavigationController.h"
#import "UIColor+Category.h"
#import "ColorTool.h"
@interface Global : NSObject

+(instancetype)shareInstance;

@end
