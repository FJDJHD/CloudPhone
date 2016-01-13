//
//  OriginMessageCell.h
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "BuddleButton.h"
#import "UIImage+ResizeImage.h"

//#define MessageIconSize    45  //聊天默认头像宽

@interface OriginMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView; //头像

@property (nonatomic, strong) BuddleButton *buddleBtn;  //气泡

@property (nonatomic, strong) CellFrameModel *cellFrameModel; //frame vv

@property (nonatomic, strong) MessageModel *messageModel;   //消息类型



- (void)cellForDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller;

@end
