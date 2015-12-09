//
//  XMPPTool.h
//  CloudPhone
//
//  Created by wangcong on 15/12/8.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"

@interface XMPPTool : NSObject {

    XMPPStream *xmppStream;         //xmpp基础服务类
    XMPPReconnect *xmppReconnect;   //如果失去连接,自动重连
    XMPPRoster *xmppRoster;          //好友列表类
    XMPPRosterCoreDataStorage *xmppRosterStorage;  //好友列表（用户账号）在core data中的操作类
    XMPPvCardCoreDataStorage *xmppvCardStorage;   //好友名片（昵称，签名，性别，年龄等信息）在core data中的操作类
    XMPPvCardTempModule *xmppvCardTempModule;     //好友名片实体类，从数据库里取出来的都是它
    XMPPvCardAvatarModule *xmppvCardAvatarModule;  //好友头像
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@property (nonatomic, assign) BOOL isXMPPRegister;

+ (instancetype)sharedXMPPTool;


- (NSManagedObjectContext *)managedObjectContext_roster;

- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;








@end
