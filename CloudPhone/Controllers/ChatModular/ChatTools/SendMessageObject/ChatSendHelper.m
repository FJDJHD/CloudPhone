//
//  ChatSendHelper.m
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ChatSendHelper.h"
#import "XMPPvCardTemp.h"

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
    
    //发回自己服务器
    if (username.length > 0) {
        NSArray *array = [username componentsSeparatedByString:XMPPSevser];
        if (array.count > 0) {
            [[AirCloudNetAPIManager sharedManager] saveSendMessageOfParams:@{@"mobile" : array[0],@"content" : str} WithBlock:^(id data, NSError *error) {
                if (!error) {
                    NSDictionary *dic = (NSDictionary *)data;
                    if ([[dic objectForKey:@"status"] integerValue] == 1) {
                        DLog(@"****");
                    } else {
                        DLog(@"******%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]]);
                    }
                }
            }];
        }
    }
}


//发送图片
+ (void)sendImageMessageWithImage:(UIImage *)image toUsername:(XMPPJID *)jid {
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
    
    //发回自己服务器
//    if (jid.user.length > 0) {
//        NSArray *array = [jid.user componentsSeparatedByString:XMPPSevser];
//        if (array.count > 0) {
//            [[AirCloudNetAPIManager sharedManager] saveSendPhotoOfImage:image params:@{@"mobile" : array[0]} WithBlock:^(id data, NSError *error) {
//                if (!error) {
//                    NSDictionary *dic = (NSDictionary *)data;
//                    if ([[dic objectForKey:@"status"] integerValue] == 1) {
//                        DLog(@"****");
//                    } else {
//                        DLog(@"******%@",[dic objectForKey:@"msg"]);
//                    }
//                }
//            }];
//        }
//    }
}

//发送语音
+ (void)sendVoiceMessageWithAudio:(NSData *)data time:(NSInteger)duration toUsername:(XMPPJID *)jid {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid]; //发送的目标
    [message addBody:[NSString stringWithFormat:@"audio%ld",(long)duration]];//时间路径都放这
    //转化base64编码
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    //设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
    //包含子节点
    [message addChild:attachment];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] sendElement:message];

}

//修改xmpp用户头像
+ (void)modifyUserHeadPortraitWithImage:(UIImage *)image nickName:(NSString *)name {
    
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns: @"vcard-temp"];
    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
    UIImage *imag = image;
    if (imag == nil) {
        imag = [UIImage imageWithContentsOfFile:[GeneralToolObject personalIconFilePath]];
        if (imag == nil) {
            imag = [UIImage imageNamed:@"mine_icon"];
        }
    }
    NSData *dataFromImage = UIImageJPEGRepresentation(imag, 0.5f);
    NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL" stringValue:[dataFromImage base64EncodedStringWithOptions:0]];
    
    [photoXML addChild:typeXML];
    [photoXML addChild:binvalXML];
    [vCardXML addChild:photoXML];
    
    XMPPvCardTemp *myvCardTemp = [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] myvCardTemp];
    
    if (myvCardTemp) {
        myvCardTemp.photo = dataFromImage;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] updateMyvCardTemp:myvCardTemp];
    } else {
        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
        [newvCardTemp setNickname:name];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] updateMyvCardTemp:newvCardTemp];
    }
}

//修改xmpp用户昵称
+ (void)modifyUserNicknameWithString:(NSString *)str {
    
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns: @"vcard-temp"];
//    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
//    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
//    
//    UIImage *image = [UIImage imageWithContentsOfFile:[GeneralToolObject personalIconFilePath]];
//    if (image == nil) {
//        image = [UIImage imageNamed:@"mine_icon"];
//    }
//
//    NSData *dataFromImage = UIImageJPEGRepresentation(image, 0.5f);
//    NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL" stringValue:[dataFromImage base64EncodedStringWithOptions:0]];
//    
//    [photoXML addChild:typeXML];
//    [photoXML addChild:binvalXML];
//    [vCardXML addChild:photoXML];
    
    XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
    [newvCardTemp setNickname:str];
//    [newvCardTemp setPhoto:dataFromImage];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] updateMyvCardTemp:newvCardTemp];
    
//    XMPPvCardTemp *myvCardTemp = [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] myvCardTemp];
//    myvCardTemp.photo = dataFromImage;
//    myvCardTemp.nickname = str;
//    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] updateMyvCardTemp:myvCardTemp];
}


//根据jid获取用户头像包括自己的头像
+ (UIImage *)getPhotoWithJID:(XMPPJID *)jid {

    UIImage *image = nil;
    if ([jid isEqualToJID:[[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] myJID]]) {
        //自己的头像
        XMPPvCardTemp *myvCardTemp = [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] myvCardTemp];
        if (myvCardTemp.photo != nil) {
            image = [UIImage imageWithData:myvCardTemp.photo];
        }

    } else {
        //jid 的头像
        NSData *photoData = [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardAvatarModule] photoDataForJID:jid];
        if (photoData != nil){
            image = [UIImage imageWithData:photoData];
        }
    }
    return image;
}




@end
