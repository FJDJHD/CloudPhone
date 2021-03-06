//
//  MessageCell.h
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellFrameModel.h"
#import "BuddleButton.h"
#import "LocationViewController.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) CellFrameModel *cellFrame;

@property (nonatomic, strong) BuddleButton *textView;

@property (nonatomic, strong) UIImageView *iconView;

- (void)cellForDataWithModel:(CellFrameModel *)cellFrame indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller;

@end
