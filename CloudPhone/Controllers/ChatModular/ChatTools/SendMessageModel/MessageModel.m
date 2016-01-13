//
//  MessageModel.m
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MessageModel.h"
#import "XMPPMessage+Tools.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "Global.h"
#import "NSFileManager+Tools.h"

@implementation MessageModel

+ (instancetype)modelForData:(XMPPMessageArchiving_Message_CoreDataObject *)message jid:(XMPPJID *)chatJID{
        
    MessageModel *messagemodel = [[MessageModel alloc]init];
    if ([message.body hasPrefix:@"ImgBase64"]) {
        //先存本地一份（放大图片从本地取不会失真，好神奇）
        [messagemodel saveDataWithJID:chatJID.bare timestamp:message.timestamp content:message.body messageType:@"image"];
        NSString *path = [messagemodel pathForData:chatJID.bare timestamp:message.timestamp];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        messagemodel.image = image;
        messagemodel.imagePath = path;
        messagemodel.messageType = kImageMessage; //图片类型
        messagemodel.text = @"照片";
    } else if ([message.body hasPrefix:@"AudioBase64"]) {
        
        NSString *jsonStr = [message.body substringFromIndex:11];
        if (jsonStr) {
            NSDictionary *audioDic = [GeneralToolObject parseJSONStringToNSDictionary:jsonStr];
            
            [messagemodel saveDataWithJID:chatJID.bare timestamp:message.timestamp content:[audioDic objectForKey:@"data"] messageType:@"audio"];
            NSString *path = [messagemodel pathForData:chatJID.bare timestamp:message.timestamp];
            
            messagemodel.voiceTime = [audioDic objectForKey:@"duration"];
            messagemodel.voiceFilepath = path;
        }
        
        messagemodel.messageType = kVoiceMessage; //语音类型
        messagemodel.text = @"语音";
        
    } else if ([message.body hasPrefix:@"TextBase64"]){
        
        messagemodel.text = [message.body substringFromIndex:10];
        messagemodel.messageType = kTextMessage; //文字类型
        
    } else if ([message.body hasPrefix:@"LonBase64"]){
        
        NSString *jsonStr = [message.body substringFromIndex:9];
        if (jsonStr) {
            NSDictionary *locDic = [GeneralToolObject parseJSONStringToNSDictionary:jsonStr];
            messagemodel.lat = [[locDic objectForKey:@"latitude"] doubleValue];
            messagemodel.lon = [[locDic objectForKey:@"longitude"] doubleValue];
            messagemodel.address = [locDic objectForKey:@"address"];
        }
        messagemodel.messageType = kLocationMessage; //地理位置类型
        messagemodel.text = @"位置";
        
    } else {
        messagemodel.text = @"不配配类型。。。。";
        messagemodel.messageType = kTextMessage; //文字类型
    }
    messagemodel.chatJID = chatJID;
    messagemodel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
    
    return messagemodel;
}

#pragma maek - 发送图片语音存放本地
//图片和语音存到本地 ，，
- (void)saveDataWithJID:(NSString *)jid timestamp:(NSDate *)timestamp
                content:(NSString *)body messageType:(NSString *)type{
    if ([type isEqualToString:@"image"]) {
        NSString *base64str = [body substringFromIndex:9];
        NSData *data = [base64str base64DecodedData];
        //存到本地
        [data writeToFile:[self pathForData:jid timestamp:timestamp] atomically:YES];
        
    } else if ([type isEqualToString:@"audio"]) {
        NSData *data = [body base64DecodedData];
        //存到本地
        [data writeToFile:[self pathForData:jid timestamp:timestamp] atomically:YES];
    }
}

- (NSString *)pathForData:(NSString *)jid timestamp:(NSDate *)timestamp {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [fileManager applicationCachesDirectory];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%f",jid,[timestamp timeIntervalSince1970]]];
    return filePath;
}
//AudioBase64{%ld}
- (NSString *)getTimeString:(NSString *)content{
    
    NSRange start = [content rangeOfString:@"{"];
    NSRange end = [content rangeOfString:@"}"];
    NSString *sub = [content substringWithRange:NSMakeRange(start.location + 1, end.location-start.location-1)];
    return sub;
}


@end
