//
//  ChatSendHelper.h
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface ChatSendHelper : NSObject

//发送文字信息
+ (void)sendTextMessageWithString:(NSString *)str toUsername:(NSString *)username;


//发送图片
+ (void)sendImageMessageWithImage:(UIImage *)image toUsername:(XMPPJID *)jid;


@end
