//
//  TextMessageCell.m
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "TextMessageCell.h"

@implementation TextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)cellForDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller {

    [super cellForDataWithModel:model indexPath:indexPath controller:controller];
    
    
    //赋值
    [self.buddleBtn setTitle:self.messageModel.text forState:UIControlStateNormal];
    
}

- (void)buddleBtnClick:(UIButton *)sender {
    
    BuddleButton *tempButton = (BuddleButton *)sender;
    
}

@end
