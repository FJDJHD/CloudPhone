//
//  XMPPTool.m
//  CloudPhone
//
//  Created by wangcong on 15/12/8.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "XMPPTool.h"
#import "Global.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CFNetwork/CFNetwork.h>

@implementation XMPPTool

+ (instancetype)sharedXMPPTool {

    static XMPPTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMPPTool alloc]init];
    });
    return instance;
}





@end
