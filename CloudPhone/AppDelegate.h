//
//  AppDelegate.h
//  CloudPhone
//
//  Created by wangcong on 15/11/24.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "XMPP.h"
#import "XMPPAutoPing.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPRosterDelegate,XMPPStreamDelegate,XMPPAutoPingDelegate> {

    XMPPStream *xmppStream;         //xmpp基础服务类
    XMPPReconnect *xmppReconnect;   //如果失去连接,自动重连
    XMPPRoster *xmppRoster;          //好友列表类
    XMPPRosterCoreDataStorage *xmppRosterStorage;  //好友列表（用户账号）在core data中的操作类
    XMPPvCardCoreDataStorage *xmppvCardStorage;   //好友名片（昵称，签名，性别，年龄等信息）在core data中的操作类
    
    XMPPvCardTempModule *xmppvCardTempModule;     //好友名片实体类，从数据库里取出来的都是它
    XMPPvCardAvatarModule *xmppvCardAvatarModule;  //好友头像
    
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    XMPPMessageArchiving *xmppMessageArchiving;  /** 消息归档 */
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;  /** 消息归档存储 */
    
    XMPPAutoPing *xmppAutoPing; //添加心跳监听

}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
/** 消息归档 */
@property (nonatomic, strong, readonly) XMPPMessageArchiving *xmppMessageArchiving;
/** 消息归档存储 */
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, assign) BOOL isXMPPRegister;

@property (strong, nonatomic) UIWindow *window;


- (NSManagedObjectContext *)managedObjectContext_roster;

- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;



//加载登录界面
- (void)loadLoginViewController;

//加载主界面
- (void)loadMainViewController;



@end

