//
//  MessageModel.h
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMessageModelTypeOther, //别人
    kMessageModelTypeMe     //自己
} MessageModelType;

typedef enum {
    kTextMessage,   //文字
    kImageMessage,  //图片
    kVoiceMessage   //语音
} MessageType;

@interface MessageModel : NSObject


//文字
@property (nonatomic, copy) NSString *text;

//照片
@property (nonatomic, strong) UIImage *image;

//语音
@property (nonatomic, copy) NSString *voiceFilepath;
@property (nonatomic, copy) NSString *voiceTime;


//自己还是别人
@property (nonatomic, assign) MessageModelType type;

//消息类型
@property (nonatomic,assign) MessageType messageType;

@end
