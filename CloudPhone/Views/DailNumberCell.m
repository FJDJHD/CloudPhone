//
//  DailNumberCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "DailNumberCell.h"
#import "Global.h"
@implementation DailNumberCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *dailImg = [UIImage imageNamed:@"mine_icon"];
        CGRect dailImageFrame = CGRectMake(15, (60 - dailImg.size.height)/2.0 , dailImg.size.width, dailImg.size.height);
        _dailImageView = [[UIImageView alloc]initWithImage:dailImg];
        _dailImageView.frame = dailImageFrame;
        [self addSubview:_dailImageView];
        
        CGRect nameLableFrame = CGRectMake(CGRectGetMaxX(_dailImageView.frame) + 10, 10, 150, 20);
        _dailNameLabel = [[UILabel alloc]initWithFrame:nameLableFrame];
        _dailNameLabel.font = [UIFont systemFontOfSize:14.0];
        _dailNameLabel.textColor = [UIColor blackColor];
        [self addSubview:_dailNameLabel];
        
        CGRect numberLableFrame = CGRectMake(CGRectGetMaxX(_dailImageView.frame) + 10,CGRectGetMaxY(_dailNameLabel.frame), 150, 20);
        _dailNumberLabel = [[UILabel alloc]initWithFrame:numberLableFrame];
        _dailNumberLabel.text = @"12233565646";
        _dailNumberLabel.font = [UIFont systemFontOfSize:14.0];
        _dailNumberLabel.textColor = [UIColor blackColor];
        [self addSubview:_dailNumberLabel];
        
        
        CGRect timeLableFrame = CGRectMake(CGRectGetMaxX(_dailNumberLabel.frame) + 10, 10, 40, 20);
        _dailTimeLabel = [[UILabel alloc]initWithFrame:timeLableFrame];
        _dailTimeLabel.text = @"10:00";
        _dailTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _dailTimeLabel.textColor = [UIColor blackColor];
        [self addSubview:_dailTimeLabel];
        
        CGRect dateLableFrame = CGRectMake(CGRectGetMaxX(_dailNumberLabel.frame) + 10, CGRectGetMaxY(_dailTimeLabel.frame), 40, 20);
        _dailDateLable = [[UILabel alloc]initWithFrame:dateLableFrame];
        _dailDateLable.text = @"11-24";
        _dailDateLable.font = [UIFont systemFontOfSize:14.0];
        _dailDateLable.textColor = [UIColor blackColor];
        [self addSubview:_dailDateLable];

        
        
        UIImage *arrowImg = [UIImage imageNamed:@"mine_icon"];
        CGRect arrowImageFrame = CGRectMake(MainWidth - 60, (60 - arrowImg.size.height)/2.0 , arrowImg.size.width, arrowImg.size.height);
        UIImageView  *arrowImgView = [[UIImageView alloc]initWithImage:arrowImg];
        arrowImgView.frame = arrowImageFrame;
        [self addSubview:arrowImgView];
    }
    return self;
}

@end
