//
//  DailNumberCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "DailNumberCell.h"
#import "Global.h"
#import "FriendDetailViewController.h"

@implementation DailNumberCell{
    UIViewController *temVC;
}

- (void)cellForDataWithModel:(CallRecordsModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller{
    _model = model;
    temVC = controller;
    _dailNameLabel.text = [NSString stringWithFormat:@"%@ (%ld)",model.callerName,model.callerFrequence];
    _dailNumberLabel.text= model.callerNo;
    NSRange range = {5,5};
    NSString *date =  [model.usercallTime substringWithRange:range];
    NSRange timeRange = {11,5};
    NSString *detialTime = [model.usercallTime substringWithRange:timeRange];
    _dailTimeLabel.text = detialTime;
    _dailDateLable.text = date;
    
    if ([model.callResult isEqualToString:@"0"]) {
        [_dailImageView setImage:[UIImage imageNamed:@"phone_outcall"]];
    }else if ([model.callResult isEqualToString:@"1"]){
        [_dailImageView setImage:[UIImage imageNamed:@"phone_outcallNo"]];
    }else if ([model.callResult isEqualToString:@"2"]){
        [_dailImageView setImage:[UIImage imageNamed:@"phone_incall"]];
    }else if ([model.callResult isEqualToString:@"3"]){
        [_dailImageView setImage:[UIImage imageNamed:@"phone_incallNo"]];
    }
    
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *dailImg = [UIImage imageNamed:@"phone_outcall"];
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
        _dailNumberLabel.font = [UIFont systemFontOfSize:14.0];
        _dailNumberLabel.textColor = [UIColor blackColor];
        [self addSubview:_dailNumberLabel];
        
        
        CGRect timeLableFrame = CGRectMake(CGRectGetMaxX(_dailNumberLabel.frame) + 40, 10, 40, 20);
        _dailTimeLabel = [[UILabel alloc]initWithFrame:timeLableFrame];
        _dailTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _dailTimeLabel.textColor = [UIColor blackColor];
        [self addSubview:_dailTimeLabel];
        
        CGRect dateLableFrame = CGRectMake(CGRectGetMaxX(_dailNumberLabel.frame) + 40, CGRectGetMaxY(_dailTimeLabel.frame), 40, 20);
        _dailDateLable = [[UILabel alloc]initWithFrame:dateLableFrame];
        _dailDateLable.font = [UIFont systemFontOfSize:14.0];
        _dailDateLable.textColor = [UIColor blackColor];
        [self addSubview:_dailDateLable];

        UIImage *arrowImg = [UIImage imageNamed:@"phone_detail"];
        CGRect arrowImageFrame = CGRectMake(MainWidth - 65, 0 , 65, 60);
        UIButton  *arrowImgButton = [[UIButton alloc]initWithFrame:arrowImageFrame];
        [arrowImgButton setImage:arrowImg forState:UIControlStateNormal];
        [arrowImgButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 30, 0.0, 0.0)];
        self.arrowImgButton = arrowImgButton;
        [self addSubview:arrowImgButton];
        [self.arrowImgButton addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return self;
}

- (void)arrowButtonClick{
    FriendDetailViewController *friDetailVC = [FriendDetailViewController new];
    friDetailVC.model = _model;
    [temVC.navigationController pushViewController:friDetailVC animated:YES];

}

@end
