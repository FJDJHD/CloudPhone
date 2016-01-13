//
//  AppDelegate.m
//  CloudPhone
//
//  Created by wangcong on 15/11/24.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "RegisterLoginViewController.h"
#import "BaseTabBarController.h"
#import "MainPhoneViewController.h"
#import "MainChatViewController.h"
#import "MainDiscoverViewController.h"
#import "MainMineViewController.h"


#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessage+XEP_0184.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CFNetwork/CFNetwork.h>
#import "MessageViewController.h"

#import "OpenShareHeader.h"
#import "APService.h"


@interface AppDelegate (){
    BOOL isShow;
}
@property (nonatomic, weak) UIViewController *lastSelectedViewController;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;


@end

@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppMessageArchiving;
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppAutoPing;
@synthesize deliveryReceiptsMoodule;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //加载界面视图
    [self initViewController];
    
    //初始化xmpp各种类
    [self setupStream];
    
    //打开数据库
    [DBOperate createTable];
    
    //显示小红点
    [self tabbarUnreadMessageisShow];
    
    //openshare分享到微信和QQ注册
    [OpenShare connectQQWithAppId:@"1104965629"];
    [OpenShare connectWeixinWithAppId:@"wx84d7434525d9d63f"];
    
    //注册融云SDK
    [ECDevice sharedInstance].delegate = [DeviceDelegateHelper sharedInstance];
    // [self requestLinkRongLianInfo];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

//openshare分享回调
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
    return YES;
}


- (void)initViewController {
    //这里作为一个登录标志
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:isLoginKey];
    if ([value isEqualToString:@"isLogined"]) {
        
        [self loadMainViewController];
        
    } else {
        [self loadLoginViewController];
    }
}

#pragma mark - 创建登录module
- (void)loadLoginViewController {
    RegisterLoginViewController *controller = [[RegisterLoginViewController alloc]init];
    BaseNavigationController *registerLoginNavigationController = [[BaseNavigationController alloc]initWithRootViewController:controller];
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[ColorTool navigationColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        
    } else {
        [[UINavigationBar appearance] setTintColor:[ColorTool navigationColor]];
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:19], NSFontAttributeName, nil]];
    self.window.rootViewController = registerLoginNavigationController;
}

#pragma mark - 创建4大基本module
- (void)loadMainViewController {
    
    //开始连接xmpp
    [self connect];
    [self requestLinkRongLianInfo];
    
    //注册极光推送
    [self initJPush];
    
    //电话
    MainPhoneViewController *phoneController = [[MainPhoneViewController alloc] initWithNibName:nil bundle:nil];
    phoneController.title = @"电话";
    phoneController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tabbar_phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_phoneSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *phoneNav = [[BaseNavigationController alloc] initWithRootViewController:phoneController];
    
    
    //聊天
    MainChatViewController *chatController = [[MainChatViewController alloc] initWithNibName:nil bundle:nil];
    chatController.title = @"聊天";
    chatController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[[UIImage imageNamed:@"tabbar_chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_chatSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *chatNav = [[BaseNavigationController alloc] initWithRootViewController:chatController];
    
    //发现
    MainDiscoverViewController *discoverController = [[MainDiscoverViewController alloc] initWithNibName:nil bundle:nil];
    discoverController.title = @"发现";
    discoverController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"tabbar_find"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_findSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *discoverNav = [[BaseNavigationController alloc] initWithRootViewController:discoverController];
    
    //我的
    MainMineViewController *mineController = [[MainMineViewController alloc] initWithNibName:nil bundle:nil];
    mineController.title = @"我";
    mineController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_mineSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mineController];
    
    
    // tab bar
    BaseTabBarController *rootTabBarController = [[BaseTabBarController alloc] init];
    rootTabBarController.delegate = self;
    rootTabBarController.viewControllers = [NSArray arrayWithObjects:phoneNav, chatNav, discoverNav, mineNav, nil];

    //聊天小红点
    CGRect chatNotifyLabelRect = CGRectMake(MainWidth*2/4 - 30, 6, 10, 10);
    _unreadChatLabel = [[UILabel alloc]initWithFrame:chatNotifyLabelRect];
    _unreadChatLabel.layer.cornerRadius = 5;
    _unreadChatLabel.clipsToBounds = YES;
    _unreadChatLabel.textAlignment = NSTextAlignmentCenter;
    _unreadChatLabel.hidden = YES;
    _unreadChatLabel.backgroundColor = [UIColor redColor];
    _unreadChatLabel.font = [UIFont systemFontOfSize:9];
    [rootTabBarController.tabBar addSubview:_unreadChatLabel];
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[ColorTool navigationColor]];
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        
    } else {
        [[UINavigationBar appearance] setTintColor:[ColorTool navigationColor]];
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:19], NSFontAttributeName, nil]];
        //不需要tabbar下面文字，先隐藏掉
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#2cceb7"], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    self.window.rootViewController = rootTabBarController;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController{
    UIViewController *vc = [viewController.viewControllers firstObject];
    if ([vc isKindOfClass:[MainPhoneViewController class]]) {
        if (self.lastSelectedViewController == vc) {
            MainPhoneViewController *tempComtroller = (MainPhoneViewController *)vc;
            if (isShow == NO) {
                [tempComtroller keyboardShow];
                isShow = YES;
            }else{
                [tempComtroller keyboardHidden];
                isShow = NO;
            }
        }
    }
    self.lastSelectedViewController = vc;
}

#pragma mark - XMPP模块。。。。全部放在这里
- (void)setupStream {
    
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream setHostName:XMPPIP];
    [xmppStream setHostPort:XMPPPORT];
    xmppStream.enableBackgroundingOnSocket = YES;
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    [xmppReconnect setAutoReconnect:YES];
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    //    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    //用这个处理加好友界面卡住不动的情况
    xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:xmppRosterStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // 消息模块(如果支持多个用户，使用单例，所有的聊天记录会保存在一个数据库中)
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    
    //消息回执，判断是否发送成功
    deliveryReceiptsMoodule = [[XMPPMessageDeliveryReceipts alloc] init];
    deliveryReceiptsMoodule.autoSendMessageDeliveryReceipts = YES;
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    [xmppMessageArchiving activate:xmppStream];
    [deliveryReceiptsMoodule activate:xmppStream];
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];//dispatch_get_main_queue()
    
}

- (void)goOnline {
    DLog(@"goOnline");
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [xmppStream sendElement:presence];
}

- (void)goOffline {
    DLog(@"goOffline");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

//建立连接
- (BOOL)connect {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:UserNumber];
    if (number.length == 0) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",number,XMPPSevser]]];
    
    // 连接到服务器，如果连接已经存在，则不做任何事情
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:NULL];
    
    return YES;
}

- (void)disconnect {
    [self goOffline];
    [xmppStream disconnect];
}

#pragma mark - XMPPStreamDelegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    DLog(@"socket连接成功socketDidConnect");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    DLog(@"连接失败xmppStreamDidDisconnect = %@",error);
}

//连接上openfire，开始注册登录
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DLog(@"xmppStreamDidConnect,准备注册或登录");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:UserNumber];
    if (self.isXMPPRegister == YES) {
        DLog(@"注册xmpp");
        [sender registerWithPassword:number error:NULL];
    } else {
        DLog(@"登录xmpp");
        [sender authenticateWithPassword:number error:NULL];
    }
}

//认证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    DLog(@"服务端认证完成");
    [self goOnline]; //标志上线
    [self autoPingProxyServer:XMPPIP];
}

//认证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    DLog(@"服务端认证失败%@",error);
    //改成注册试试
    self.isXMPPRegister = YES;
    [self connect];
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    DLog(@"注册成功");
    //登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:UserNumber];
    [xmppStream authenticateWithPassword:number error:NULL];
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    DLog(@"注册失败");
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
}

//获取好友。。。
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return NO;
}

//接受到消息调用这个
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    //有人发聊天消息来了
    if ([message.type isEqualToString:@"chat"]) {
        if (message.body.length > 0) {
            NSArray *array = [message.fromStr componentsSeparatedByString:@"/"];
            NSString *jidStr = @"";  //13049340993@cloud.com/8b468676
            if (array.count > 0) {
                jidStr = array[0];
                
            }
            NSString *lastStr = @"";
            if ([message.body hasPrefix:@"ImgBase64"]) {
                lastStr = @"[图片]";
            } else if ([message.body hasPrefix:@"AudioBase64"]) {
                lastStr = @"[语音]";
            } else if ([message.body hasPrefix:@"TextBase64"]){
                lastStr = [message.body substringFromIndex:10];
            } else if ([message.body hasPrefix:@"LonBase64"]) {
                lastStr = @"[位置]";
            } else {
                lastStr = @"不配配类型。。。。。";
            }
            //当前时间
            NSDate *time = [NSDate date];
            NSString *currentTime = [NSString stringWithFormat:@"%f",[time timeIntervalSince1970]];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *number = [defaults objectForKey:UserNumber];
            NSArray *saveMessageArray = [NSArray arrayWithObjects:jidStr,message.name,lastStr,currentTime,@"1",number,nil];
            NSArray *mesageArray = [DBOperate queryData:T_chatMessage theColumn:@"jidStr" equalValue:jidStr theColumn:@"mineNumber" equalValue:number];
            if (mesageArray.count > 0) {
                //取出原本的小红点 ，之后加一存进去
                NSString *oriUnread = [mesageArray[0] objectAtIndex:message_unreadMessage];
                NSInteger temp = [oriUnread integerValue] + 1;
                NSString *saveUnread = [NSString stringWithFormat:@"%ld",(long)temp];
                
                //            [DBOperate updateData:T_chatMessage tableColumn:@"lastMessage" columnValue:lastStr conditionColumn:@"jidStr" conditionColumnValue:jidStr];
                //            [DBOperate updateData:T_chatMessage tableColumn:@"unreadMessage" columnValue:saveUnread conditionColumn:@"jidStr" conditionColumnValue:jidStr];
                
                [DBOperate updateWithTwoConditions:T_chatMessage theColumn:@"lastMessage" theColumnValue:lastStr ColumnOne:@"jidStr" valueOne:jidStr columnTwo:@"mineNumber" valueTwo:number];
                [DBOperate updateWithTwoConditions:T_chatMessage theColumn:@"time" theColumnValue:currentTime ColumnOne:@"jidStr" valueOne:jidStr columnTwo:@"mineNumber" valueTwo:number];
                [DBOperate updateWithTwoConditions:T_chatMessage theColumn:@"unreadMessage" theColumnValue:saveUnread ColumnOne:@"jidStr" valueOne:jidStr columnTwo:@"mineNumber" valueTwo:number];
                
            } else {
                [DBOperate insertDataWithnotAutoID:saveMessageArray tableName:T_chatMessage];
            }
            
            NSNotification *notice = [NSNotification notificationWithName:ChatMessageComeing object:nil userInfo:@{@"jidStr":jidStr}];
            
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
        }
    }
    
    //回执判断(要不要添加回执呢)
    NSXMLElement *request = [message elementForName:@"request"];
    if (request)
    {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            
            //发送回执
            [self.xmppStream sendElement:msg];
        }
    }else{
        NSXMLElement *received = [message elementForName:@"received"];
        if (received){
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
            {
                //发送成功
                DLog(@"对方接受到啦!");
            }
        }
    }
}

#pragma mark XMPPRosterDelegate
//接受好友请求时候调用，就是有人加你好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    DLog(@"mesg = %@",[NSString stringWithFormat:@"%@请求添加好友%@",presence.from,presence.type]);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *number = [defaults objectForKey:UserNumber];
//    NSString *selfJidStr = [NSString stringWithFormat:@"%@%@",number,XMPPSevser];
//    if (![presence.fromStr isEqualToString:selfJidStr]) {
//        DLog(@"根据是谁判断 进来了");
//
//        NSArray *arr = [NSArray arrayWithObjects:presence.fromStr,@"unagree",@"unread",nil];
//        NSArray *friendArray = [DBOperate queryData:T_addFriend theColumn:@"jidStr" theColumnValue:presence.fromStr withAll:NO];
//        if (friendArray.count == 0) {
//            [DBOperate insertDataWithnotAutoID:arr tableName:T_addFriend];
//
//            //这里是判断新好友的小红点
//            [defaults setObject:@"somebodyAdd" forKey:XMPPAddFriend];
//            [defaults synchronize];
//
//            //加个小红点
//            DLog(@"添加好友通知呀，来了");
//            NSNotification *notice = [NSNotification notificationWithName:FriendAdding object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notice];
//        }
//    }
}

-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item {
    
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    DLog(@"subscription = %@",subscription);
//    if ([subscription isEqualToString:@"both"]) {
//        DLog(@"双方成为好友！");
//    }
    if ([subscription isEqualToString:@"to"]) {
        self.isBothFriend = YES;
    } else {
        self.isBothFriend = NO;
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSString *presenceType = presence.type;
    NSString *userId = sender.myJID.user;
    NSString *presenceFromUser = presence.from.user;
    if (![presenceFromUser isEqualToString:userId]){
        if ([presenceType isEqualToString:@"subscribe"] && self.isBothFriend == NO){
            NSArray *arr = [NSArray arrayWithObjects:presence.fromStr,@"unagree",@"unread",nil];
            NSArray *friendArray = [DBOperate queryData:T_addFriend theColumn:@"jidStr" theColumnValue:presence.fromStr withAll:NO];
            if (friendArray.count == 0) {
                [DBOperate insertDataWithnotAutoID:arr tableName:T_addFriend];
                
                //这里是判断新好友的小红点
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"somebodyAdd" forKey:XMPPAddFriend];
                [defaults synchronize];
                
                //加个小红点
                DLog(@"添加好友通知呀，来了");
                NSNotification *notice = [NSNotification notificationWithName:FriendAdding object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
            }
        }
    }
    
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:@"unsubscribed"]) {
        [xmppRoster removeUser:presence.from];
        //把好友添加的也删了
        [DBOperate deleteData:T_addFriend tableColumn:@"jidStr" columnValue:presence.fromStr];
        
        //如果消息列表有也顺便删除了
        [DBOperate deleteData:T_chatMessage tableColumn:@"jidStr" columnValue:presence.fromStr];
    }
}

#pragma mark XMPPAutoPingDelegate
-(void)autoPingProxyServer:(NSString*)strProxyServer {
    xmppAutoPing = [[XMPPAutoPing alloc] init];
    [xmppAutoPing activate:xmppStream];
    [xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppAutoPing.respondsToQueries = YES;
    xmppAutoPing.pingInterval = 2;//ping 间隔时间
    if (nil != strProxyServer){
        xmppAutoPing.targetJID = [XMPPJID jidWithString:strProxyServer];//设置ping目标服务器，如果为nil,则监听socketstream当前连接上的那个服务器
    }
}

//卸载监听
- (void)deactivateAutoPing {
    
    [xmppAutoPing deactivate];
    [xmppAutoPing removeDelegate:self];
    xmppAutoPing = nil;
}

#pragma mark - 心跳
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender {
    
    //    DLog(@"Sendsender = %@",sender);
}

- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender {
    
    //    DLog(@"Receivesend = %@",sender);
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender {
    
    [CustomMBHud customHudWindow:@"xmpp连接超时"];
}

#pragma mark - XMPPReconnectDelegate


- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags {
    
    DLog(@"didDetectAccidentalDisconnect : \n %u ", connectionFlags);
}

- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags {
    DLog(@"shouldAttemptAutoReconnect : \n %u ", connectionFlags);
    
    return YES;
}


- (void)teardownStream {
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

#pragma mark XMPPCoreData
- (NSManagedObjectContext *)managedObjectContext_roster{
    return [xmppRosterStorage mainThreadManagedObjectContext];
    
}

- (NSManagedObjectContext *)managedObjectContext_capabilities{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}



#pragma mark -- 应用开启又红点的显示小红点
- (void)tabbarUnreadMessageisShow {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:XMPPAddFriend];
    
    BOOL reg = [self seekUnreadMessageFromFMDB];
    if (reg || [str isEqualToString:@"somebodyAdd"]) {
        self.unreadChatLabel.hidden = NO;
    } else {
        self.unreadChatLabel.hidden = YES;
    }
}

//查询是否有未读的message
- (BOOL)seekUnreadMessageFromFMDB {
    NSArray *arr = [DBOperate queryData:T_chatMessage theColumn:nil theColumnValue:nil withAll:YES];
    BOOL unreadFlag = NO;
    for (NSArray *temp in arr) {
        NSString *unreadTemp = [temp objectAtIndex:message_unreadMessage];
        NSInteger unreadInt = [unreadTemp integerValue];
        if (unreadInt > 0) {
            unreadFlag = YES;
        }
    }
    return unreadFlag;
}

- (void)requestLinkRongLianInfo {
    NSDictionary *dic = @{@"imei":[UniqueUDID shareInstance].udid};
    [[AirCloudNetAPIManager sharedManager] linkRongLianInfoOfParams:dic WithBlock:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            NSDictionary *info = [dic objectForKey:@"data"];
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
                loginInfo.username = [info objectForKey:@"sub_account_sid"];//用户登录app的用户id即可。
                loginInfo.appKey = [info objectForKey:@"appKey"];
                loginInfo.appToken = [info objectForKey:@"appToken"];
                loginInfo.authType = LoginAuthType_NormalAuth;//默认方式登录
                loginInfo.mode = LoginMode_InputPassword;
                [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
                    if (error.errorCode == ECErrorType_NoError) {
                        DLog(@"荣联平台链接成功");
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *value = [defaults objectForKey:UserNumber];
                        [[ECDevice sharedInstance].VoIPManager setSelfPhoneNumber:value];
                    }else{
                        DLog(@"荣联平台链接失败");
                    }
                }];
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
            }
        }
    }];
}

#pragma mark 注册推送通知之后
- (void)initJPush {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:nil];
    }else{
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:nil];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    DLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    DLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    DLog(@"%@", [notification userInfo]);
    DLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    if ([APService registrationID]) {
        DLog(@"RegistrationID = %@",[APService registrationID]);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *value = [defaults objectForKey:isLoginKey];
        //登录后
        if ([value isEqualToString:@"isLogined"]) {
            [[AirCloudNetAPIManager sharedManager] postPushRegistrationIDOfParams:@{@"reg_id":[APService registrationID]} WithBlock:^(id data, NSError *error) {
                if (!error) {
                    DLog(@"上传成功RegistrationID");
                } else {
                    DLog(@"上传失败RegistrationID");
                }
            }];
        }
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"收到消息%@", currentContent);
    
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}


//在此接收设备令牌
- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
    
}
// 获取device token失败后
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
}

// 接收到推送通知之后
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知----:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //* 本地推送在前台推送。默认App在前台运行时不会进行弹窗，在程序接收通知调用此接口可实现指定的推送弹窗。
    
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark - 应用程序生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //重新连接
    if ([xmppStream isDisconnected]) {
        [self connect];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)dealloc
{
    [self unObserveAllNotifications];
    [self teardownStream];
}

@end
