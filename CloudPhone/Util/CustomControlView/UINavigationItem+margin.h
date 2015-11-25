//
//  UINavigationItem+margin.h
//  CommunityAPP
//
//  Created by Stone on 14-5-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (margin)

- (void)mk_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;

- (void)mk_setLeftBarButtonItems:(NSArray *)leftBarButtonItems;

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;

- (void)mk_setRightBarButtonItems:(NSArray *)rightBarButtonItems;

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem offset:(CGFloat)offset;

@end
