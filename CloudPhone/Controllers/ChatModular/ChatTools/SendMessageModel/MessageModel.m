//
//  MessageModel.m
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MessageModel.h"
#import "XMPPMessage+Tools.h"
#import "Global.h"

@implementation MessageModel

////文字
//@property (nonatomic, copy) NSString *text;
//
////照片
//@property (nonatomic, strong) UIImage *image;
//
////语音
//@property (nonatomic, copy) NSString *voiceFilepath;
//@property (nonatomic, copy) NSString *voiceTime;
//
////聊天人头像
//@property (nonatomic, strong) UIImage *otherPhoto;
////聊天人的jid
//@property (nonatomic, strong) XMPPJID *chatJID;
//
////自己还是别人
//@property (nonatomic, assign) MessageModelType type;
//
////消息类型
//@property (nonatomic,assign) MessageType messageType;




//    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    // 如果存进去了，就把字符串转化成简洁的节点后保存
//    if ([message.message saveAttachmentJID:self.chatJID.bare timestamp:message.timestamp]) {
//        message.messageStr = [message.message compactXMLString];
//        [[self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
//    }
//    _messageModel.voiceFilepath = nil;
//    NSString *path = [message.message pathForAttachment:self.chatJID.bare timestamp:message.timestamp];
//
//    if ([message.body isEqualToString:@"image"]) {
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        _messageModel.image = image;
//        _messageModel.messageType = kImageMessage; //图片类型
//
//    } else if ([message.body hasPrefix:@"audio"]) {
//
//        NSString *timeStr = [message.body substringFromIndex:5];
//        _messageModel.voiceTime = timeStr;
//        _messageModel.voiceFilepath = path; //音频路径
//        _messageModel.messageType = kVoiceMessage; //语音类型
//
//    } else {
//        _messageModel.messageType = kTextMessage; //文字类型
//    }
//    _messageModel.text = message.body;
//    _messageModel.otherPhoto = self.chatPhoto;
//    _messageModel.chatJID = self.chatJID;
//    _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
//    _cellModel.message = _messageModel;


//- (instancetype)initWithXMPPObject:(XMPPMessageArchiving_Message_CoreDataObject *)message {
//    
//    if (self = [super init]) {
//        if ([message.message saveAttachmentJID:self.chatJID.bare timestamp:message.timestamp]) {
//            message.messageStr = [message.message compactXMLString];
//            [[self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
//        }
//        NSString *path = [message.message pathForAttachment:self.chatJID.bare timestamp:message.timestamp];
//        if ([message.body isEqualToString:@"image"]) {
//            UIImage *image = [UIImage imageWithContentsOfFile:path];
//            self.image = image;
//            self.messageType = kImageMessage; //图片类型
//
//        }else if ([message.body hasPrefix:@"audio"]) {
//            
//            NSString *timeStr = [message.body substringFromIndex:5];
//            self.voiceTime = timeStr;
//            self.voiceFilepath = path; //音频路径
//            self.messageType = kVoiceMessage; //语音类型
//            
//        } else {
//            self.messageType = kTextMessage; //文字类型
//        }
//
//        self.text = message.body;
////        self.otherPhoto = self.chatPhoto;
////        self.chatJID = self.chatJID;
//        self.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
//
//        
//    }
//    return self;
//}
//
//+ (instancetype)modelForData:(XMPPMessageArchiving_Message_CoreDataObject *)object {
//
//    return [[self alloc]initWithXMPPObject:object];
//}
//
//
//- (AppDelegate *)appDelegate {
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}

@end
