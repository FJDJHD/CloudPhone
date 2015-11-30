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



#import "NSString+MD5.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self loadLoginViewController];
//    [self loadMainViewController];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
//    long timeInt =[[NSDate date] timeIntervalSince1970];
//    NSString *imei = [GeneralToolObject CPUuidString];
//    NSString *versionName = APP_VERSION;
//    NSString *version = app_build;
//    
//    NSString *time = [NSString stringWithFormat:@"%ld",timeInt];
//    NSString *md5VersionName = [versionName md5];
//    NSString *md5imei = [imei md5];
//    
//    NSString *tokenq = [NSString stringWithFormat:@"%@%@%@itel2105@@$*",md5VersionName,md5imei,time];
//    
//    NSString *tokens = [NSString stringWithFormat:@"%@",[tokenq md5]];
//
//    NSString *value = [NSString stringWithFormat:@"itel_version/%@ version/%@ from/ios imei/%@ key/%@ time/%@ token/%@",versionName,version,imei,md5imei,time,tokens];
//    DLog(@"value = %@",value);
//    
//    
//    
////    NSDictionary *dic = @{@"mobile":@"13113689076",@"type":@"reg"};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",nil];
//    
//    [manager.requestSerializer setValue:value forHTTPHeaderField:@"User-Agent"];
//    
//    [manager GET:@"http://cloud.itelland.com/?s=/Home/User/sendVerify&mobile=13113689077&type=reg" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"operation = %@",operation);
//        
//        NSLog(@"JSON: %@ ----%@", responseObject,[responseObject objectForKey:@"msg"]);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    

    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 创建登录module
- (void)loadLoginViewController {
    
    RegisterLoginViewController *controller = [[RegisterLoginViewController alloc]init];
    BaseNavigationController *registerLoginNavigationController = [[BaseNavigationController alloc]initWithRootViewController:controller];
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[ColorTool navigationColor]];
        [[UINavigationBar appearance] setBarTintColor:appNavgationBackColor];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        
    } else {
        [[UINavigationBar appearance] setTintColor:[ColorTool navigationColor]];
        [[UINavigationBar appearance] setTintColor:appNavgationBackColor];
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    self.window.rootViewController = registerLoginNavigationController;
}

#pragma mark - 创建4大基本module
- (void)loadMainViewController {
    //电话
    MainPhoneViewController *phoneController = [[MainPhoneViewController alloc] initWithNibName:nil bundle:nil];
    phoneController.title = @"电话";
    phoneController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"pic_phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *phoneNav = [[BaseNavigationController alloc] initWithRootViewController:phoneController];
    
    
    //聊天
    MainChatViewController *chatController = [[MainChatViewController alloc] initWithNibName:nil bundle:nil];
    chatController.title = @"聊天";
    chatController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[[UIImage imageNamed:@"pic_chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *chatNav = [[BaseNavigationController alloc] initWithRootViewController:chatController];
    
    //发现
    MainDiscoverViewController *discoverController = [[MainDiscoverViewController alloc] initWithNibName:nil bundle:nil];
    discoverController.title = @"发现";
    discoverController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"pic_find"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *discoverNav = [[BaseNavigationController alloc] initWithRootViewController:discoverController];
    
    //我的
    MainMineViewController *mineController = [[MainMineViewController alloc] initWithNibName:nil bundle:nil];
    mineController.title = @"我";
    mineController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"pic_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mineController];
    
    // tab bar
    BaseTabBarController *rootTabBarController = [[BaseTabBarController alloc] init];
    rootTabBarController.delegate = self;
    rootTabBarController.viewControllers = [NSArray arrayWithObjects:phoneNav, chatNav, discoverNav, mineNav, nil];;
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:appNavgationBackColor];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        
    } else {
        [[UINavigationBar appearance] setTintColor:appNavgationBackColor];
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    //    //不需要tabbar下面文字，先隐藏掉
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(255 , 255, 255,0),NSForegroundColorAttributeName,[UIFont systemFontOfSize:0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(255 , 255, 255,0), NSForegroundColorAttributeName,[UIFont systemFontOfSize:0],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    self.window.rootViewController = rootTabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
