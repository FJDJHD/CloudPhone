//
//  DailNumberCell.h
//  CloudPhone
//
//  Created by wangcong on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallRecordsModel.h"
@interface DailNumberCell : UITableViewCell

@property (nonatomic, strong) UIImageView *dailImageView;

@property (nonatomic, strong) UILabel *dailNameLabel;

@property (nonatomic, strong) UILabel *dailNumberLabel;

@property (nonatomic, strong) UILabel *dailTimeLabel;

@property (nonatomic, setter=isToday:) UILabel *dailDateLable;

- (void)cellForDataWithModel:(CallRecordsModel *)model;
@end
