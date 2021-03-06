//
//  BuddleButton.h
//  CloudPhone
//
//  Created by wangcong on 15/12/11.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

//typedef void(^TapButtonActionBlock) (UIButton *button);

@interface BuddleButton : UIButton

@property (nonatomic, strong) MessageModel *model;

@property (nonatomic,assign) MessageType messageType; //消息类型

@property (nonatomic, copy) NSString *voicePath; //语音路径

@property (nonatomic, copy) NSString *imagePath; //图片路径

@property (nonatomic, assign) double lat; //经纬度
@property (nonatomic, assign) double lon;
@property (nonatomic, copy)   NSString *address;




//@property (nonatomic, copy) TapButtonActionBlock action;


@end
