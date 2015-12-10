//
//  ChatSendHelper.m
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ChatSendHelper.h"

@implementation ChatSendHelper

//发送文字信息
+ (void)sendTextMessageWithString:(NSString *)str toUsername:(NSString *)username {

    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:str];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = username; //发送的目标
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] sendElement:message];

}


//发送图片
+ (void)sendImageMessageWithImage:(UIImage *)image toUsername:(XMPPJID *)jid; {
    
    NSData *data= UIImageJPEGRepresentation(image, 0.5);
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid]; //发送的目标
    [message addBody:@"image"];
    //转化base64编码
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    //设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
    //包含子节点
    [message addChild:attachment];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] sendElement:message];
}



@end
