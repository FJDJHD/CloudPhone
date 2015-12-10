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

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSAttributedString *attachStr;

@property (nonatomic, assign) MessageModelType type;

@end
