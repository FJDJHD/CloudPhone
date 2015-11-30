//
//  UIViewController+NavigationBar.m
//  CommunityAPP
//
//  Created by Stone on 14-5-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UIViewController+NavigationBar.h"

#import "UIImage_extra.h"

@implementation UIViewController (NavigationBar)


- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

- (UIBarButtonItem *)spacer:(CGFloat)margin
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -margin;
    return space;
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    space.width = -20;
    return space;
}

- (void)adjustiOS7NaviagtionBar
{
    
    if ( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) )
    {        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        /*
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.navigationController.navigationBar.translucent = YES;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0];
         */
    }
    else{
        self.navigationController.navigationBar.translucent = NO;

    }
    
}

- (void)adjustiOS7WhiteNaviagtionBar
{
    
    if ( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.navigationController.navigationBar.translucent = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        //self.navigationController.navigationBar.alpha = 0.1;
        //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250.0f/255.0 green:250.0/255.0f blue:250.0/255 alpha:0.35];
    }
    else{
        self.navigationController.navigationBar.translucent = NO;
        
    }
    
}

- (void)setNavigationTitle:(NSString *)title{
    self.navigationItem.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont boldSystemFontOfSize:18.0],
                                                                     NSFontAttributeName,nil]];
}

- (void)setNavigationBlackTitle:(NSString *)title{

    self.navigationItem.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont boldSystemFontOfSize:18.0],
                                                                     NSFontAttributeName,nil]];
}


- (void)setBackBarButtonItem:(UIView *)view{
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    if ([self isIOS7]) {
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItems = @[[self spacer], backButtonItem];
    }else{
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    #if !__has_feature(objc_arc)
    [backButtonItem release];
    #endif
}

- (UIButton *)setBackBarButton{
    UIImage *image = [UIImage imageNamed:@"pic_retrun.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setExclusiveTouch:YES];
    /*
     if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
     [backButton  setImageEdgeInsets:UIEdgeInsetsMake(0, -24,0, 24)];
     }
     else
     {
     [backButton  setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,0)];
     }
     */
    return backButton;
}


- (void)setRightBarButtonItem:(UIView *)view{
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[[self spacer], rightButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
#if !__has_feature(objc_arc)
    [rightButtonItem release];
#endif
}

- (void)setRightBarButtonItem:(UIView *)view offset:(CGFloat)offset{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[[self spacer:offset], rightButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
#if !__has_feature(objc_arc)
    [rightButtonItem release];
#endif
}



- (void)setRightBarButtonItems:(NSArray *)views{
    
    NSMutableArray *items = [NSMutableArray array];
    
    for (UIView *view in views) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
        [items addObject:item];
        #if !__has_feature(objc_arc)
        [item release];
        #endif
    }
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    [items addObject:space];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = items;
    }else{
        self.navigationItem.rightBarButtonItems = items;
    }
    
}


@end
