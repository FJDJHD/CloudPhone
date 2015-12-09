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

- (XMPPStream *)xmppStream {
    if (!xmppStream) {
        xmppStream = [[XMPPStream alloc] init];
        [xmppStream setHostName:XMPPIP];
        [xmppStream setHostPort:XMPPPORT];
        
        xmppReconnect = [[XMPPReconnect alloc] init];
        
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
        
        xmppRoster.autoFetchRoster = YES;
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        
        
        xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
        xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
        
        xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
        
        
        xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
        xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
        
        xmppCapabilities.autoFetchHashedCapabilities = YES;
        xmppCapabilities.autoFetchNonHashedCapabilities = NO;
        
        [xmppReconnect         activate:xmppStream];
        [xmppRoster            activate:xmppStream];
        [xmppvCardTempModule   activate:xmppStream];
        [xmppvCardAvatarModule activate:xmppStream];
        [xmppCapabilities      activate:xmppStream];
        
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    return xmppStream;
}

//- (XMPPRosterCoreDataStorage *)xmppRosterStorage {
//    if (!xmppRosterStorage) {
//        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//    }
//    return xmppRosterStorage;
//}
//
//- (XMPPRoster *)xmppRoster {
//    if (!xmppRoster) {
//        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
//        xmppRoster.autoFetchRoster = YES;
//        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
//        
//    }
//    return xmppRoster;
//}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        xmppStream = [[XMPPStream alloc] init];
//        [xmppStream setHostName:XMPPIP];
//        [xmppStream setHostPort:XMPPPORT];
//        
//        xmppReconnect = [[XMPPReconnect alloc] init];
//        
//        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//        
//        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
//        
//        xmppRoster.autoFetchRoster = YES;
//        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
//        
//        
//        xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
//        xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
//        
//        xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
//        
//        
//        xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
//        xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
//        
//        xmppCapabilities.autoFetchHashedCapabilities = YES;
//        xmppCapabilities.autoFetchNonHashedCapabilities = NO;
//        
//        [xmppReconnect         activate:xmppStream];
//        [xmppRoster            activate:xmppStream];
//        [xmppvCardTempModule   activate:xmppStream];
//        [xmppvCardAvatarModule activate:xmppStream];
//        [xmppCapabilities      activate:xmppStream];
//        
//        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//        [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    }
//    return self;
//}


#pragma mark XMPPCoreData
- (NSManagedObjectContext *)managedObjectContext_roster{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}




@end
