//
//  LocationMessageCell.m
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "LocationMessageCell.h"
#import "LocationViewController.h"

@interface LocationMessageCell()

@property (nonatomic, strong) UILabel *locLabel;

@property (nonatomic, strong) UIViewController *tempController;

@end

@implementation LocationMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _locLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 83, 100, 40)];
        _locLabel.numberOfLines = 0;
        _locLabel.textAlignment = NSTextAlignmentCenter;
        _locLabel.textColor = [UIColor whiteColor];
        _locLabel.font = [UIFont systemFontOfSize:10];
        [self.buddleBtn addSubview:_locLabel];
        
    }
    return self;
}

- (void)cellForDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller {
    
    [super cellForDataWithModel:model indexPath:indexPath controller:controller];
    
    self.tempController = controller;
    
    //赋值
    [self.buddleBtn setImage:[UIImage imageNamed:@"chatView_location_map"] forState:UIControlStateNormal];
    self.buddleBtn.imageView.layer.cornerRadius = 7.0;
    self.buddleBtn.imageView.layer.masksToBounds = YES;
    
    _locLabel.text = self.messageModel.address;
    
}

//点击图片放大
- (void)buddleBtnClick:(UIButton *)sender {
    
    BuddleButton *tempButton = (BuddleButton *)sender;
    
    //地理位置
    CLLocationCoordinate2D coor = (CLLocationCoordinate2D){tempButton.model.lat,tempButton.model.lon};
    LocationViewController *controller = [[LocationViewController alloc]initWithLocation:coor address:tempButton.address];
    [self.tempController.navigationController pushViewController:controller animated:NO];
}




@end
