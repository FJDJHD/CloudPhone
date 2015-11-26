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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RegisterLoginViewController *controller = [[RegisterLoginViewController alloc]init];
    BaseNavigationController *registerLoginNavigationController = [[BaseNavigationController alloc]initWithRootViewController:controller];
    
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
    
    self.window.rootViewController = registerLoginNavigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
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
