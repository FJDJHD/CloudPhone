//
//  UIViewController+NavigationBar.h
//  CommunityAPP
//
//  Created by Stone on 14-5-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

/**
 *  适配iOS7的导航条
 */
- (void)adjustiOS7NaviagtionBar;

/**
 *  适配iOS7导航条(白色)
 */
- (void)adjustiOS7WhiteNaviagtionBar;

/**
 *  设置导航的title(default font blodSystem:22 textClor:white)
 *
 *  @param title 导航的文本
 */
- (void)setNavigationTitle:(NSString *)title;

/**
 *  设置导航的title (black color)
 *
 *  @param title 导航文本
 */
- (void)setNavigationBlackTitle:(NSString *)title;

/**
 *  设置返回按钮
 *
 *  @param view 自定的返回按钮
 */
- (void)setBackBarButtonItem:(UIView *)view;

/**
 *  定义返回按钮 UIImage:@"left_arrow_blackgray.png" size:44,44
 *
 *  @return 返回UIButton
 */
- (UIButton *)setBackBarButton:(int)flag;

/**
 *  设置导航栏的View
 *
 *  @param view 自定义的View
 */
- (void)setRightBarButtonItem:(UIView *)view;


/**
 *  设置导航右边的item
 *
 *  @param view   自定义的视图
 *  @param offset <#offset description#>
 */
- (void)setRightBarButtonItem:(UIView *)view offset:(CGFloat)offset;

///
- (void)setRightBarButtonItems:(NSArray *)views;

@end
