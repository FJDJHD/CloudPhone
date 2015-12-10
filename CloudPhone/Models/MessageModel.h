//
//  MessageModel.h
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMessageModelTypeOther,
    kMessageModelTypeMe
} MessageModelType;

typedef enum {
    kTextMessage,  //文字
    kImageMessage  //图片
} MessageType;

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) MessageModelType type;

@property (nonatomic,assign) MessageType messageType;

@end
