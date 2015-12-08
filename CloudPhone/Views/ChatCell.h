//
//  ChatCell.h
//  CloudPhone
//
//  Created by iTelDeng on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (nonatomic, strong) UIImageView *chatImageView;

@property (nonatomic, strong) UILabel *chatNameLabel;

@property (nonatomic, strong) UILabel *chatLastContentLabel;

@property (nonatomic, strong) UILabel *chatTimeLabel;

@end
