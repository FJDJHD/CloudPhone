//
//  Macros.h
//  AirCloud
//
//  Created by mc on 15/3/30.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#ifndef AirCloud_Macros_h
#define AirCloud_Macros_h

// Screen
///////////////////////////////////////////
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define STATUS_BAR_HEIGHT           20
#define NAVIGATIONBAR_HEIGHT        44
#define STATUS_NAV_BAR_HEIGHT       64
#define TABBAR_HEIGHT               49
#define MainHeight                  (SCREEN_HEIGHT - STATUS_NAV_BAR_HEIGHT)
#define MainWidth                   SCREEN_WIDTH

// Views
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)


//keyWindow
#define KeyWindowView                 [[UIApplication sharedApplication] keyWindow].subviews[0]

//设置RGB值
#define RGB(r,g,b)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// App
///////////////////////////////////////////
#define APP_NAME        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLE_URL_NAME     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"]
#define APP_BUNDLEID    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define APP_ID          @""
#define APP_URL         @""

// Device & OS
///////////////////////////////////////////

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Is3_5Inches() ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define Is4_0Inches() ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define Is4_7Inches() ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define Is5_5Inches() ([[UIScreen mainScreen] bounds].size.height == 960.0f)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// block self
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/***************************************常见提示语******************************************/

//Login 提示
#define Login_alreadyRegister                      @"该手机号已注册!"
#define Login_emptyPhoneNumber                     @"手机号码不能为空!"
#define Login_sureCorrectNumber                    @"请输入正确的手机格式!"
#define Login_emptyVerifyNumber                    @"验证码不能为空!"
#define Login_wrongVerifyNumber                    @"验证码错误!"
#define Login_NotExistPhoneNumber                  @"该手机用户不存在!"
#define Login_emptyPwdNumber                       @"密码不能为空!"
#define Login_sucessModifyPwdNumber                @"修改密码成功!"



//Networking提示
#define NetWorking_NoNetWork                       @"当前网络异常,请检查网络"



#endif
