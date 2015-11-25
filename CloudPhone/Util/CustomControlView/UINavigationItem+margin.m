//
//  UINavigationItem+margin.m
//  CommunityAPP
//
//  Created by Stone on 14-5-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UINavigationItem+margin.h"

@implementation UINavigationItem (margin)


- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -11;
    return space;
}

- (UIBarButtonItem *)spacer:(CGFloat)offset
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -offset;
    return space;
}

- (void)mk_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([self isIOS7] && leftBarButtonItem) {
        [self mk_setLeftBarButtonItem:nil];
        [self mk_setLeftBarButtonItems:@[[self spacer], leftBarButtonItem]];
    } else {
        if ([self isIOS7]) {
            [self mk_setLeftBarButtonItems:nil];
        }
        [self mk_setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)mk_setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if ([self isIOS7] && leftBarButtonItems && leftBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [self mk_setLeftBarButtonItems:items];
    } else {
        [self mk_setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([self isIOS7] && rightBarButtonItem) {
        [self mk_setRightBarButtonItem:nil];
        [self mk_setRightBarButtonItems:@[[self spacer], rightBarButtonItem]];
    } else {
        if ([self isIOS7]) {
            [self mk_setRightBarButtonItems:nil];
        }
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)mk_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if ([self isIOS7] && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [self mk_setRightBarButtonItems:items];
    } else {
        [self mk_setRightBarButtonItems:rightBarButtonItems];
    }
}

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem offset:(CGFloat)offset{
    if ([self isIOS7] && rightBarButtonItem) {
        [self mk_setRightBarButtonItem:nil];
        [self mk_setRightBarButtonItems:@[[self spacer:offset], rightBarButtonItem]];
    } else {
        if ([self isIOS7]) {
            [self mk_setRightBarButtonItems:nil];
        }
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    }
}


/*
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -24;
    
    if (_leftBarButtonItem)
    {
        [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
    }
    else
    {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
    [spaceButtonItem release];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -18;
    
    if (_rightBarButtonItem)
    {
        [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
    }
    else
    {
        [self setRightBarButtonItems:@[spaceButtonItem]];
    }
    [spaceButtonItem release];
}
#endif
*/

@end
