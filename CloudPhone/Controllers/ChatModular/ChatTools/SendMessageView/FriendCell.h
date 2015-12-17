//
//  FriendCell.h
//  CloudPhone
//
//  Created by wangcong on 15/12/16.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPUserCoreDataStorageObject.h"

@interface FriendCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *onlineLable;


- (void)cellForData:(XMPPUserCoreDataStorageObject *)user;

@end
