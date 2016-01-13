//
//  MessageModel.h
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"

typedef enum {
    kMessageModelTypeOther, //别人
    kMessageModelTypeMe     //自己
} MessageModelType;

typedef enum {
    kTextMessage,    //文字
    kImageMessage,   //图片
    kVoiceMessage,   //语音
    kLocationMessage //位置
} MessageType;

@interface MessageModel : NSObject


//文字
@property (nonatomic, copy) NSString *text;

//照片
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy)   NSString *imagePath;

//语音
@property (nonatomic, copy) NSString *voiceFilepath;
@property (nonatomic, copy) NSString *voiceTime;

//位置
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, copy)   NSString *address;

//聊天人头像
@property (nonatomic, strong) UIImage *otherPhoto;
//聊天人的jid
@property (nonatomic, strong) XMPPJID *chatJID;

//自己还是别人
@property (nonatomic, assign) MessageModelType type;

//消息类型
@property (nonatomic, assign) MessageType messageType;


//+ (instancetype)modelForData:(XMPPMessageArchiving_Message_CoreDataObject *)object;






@end
