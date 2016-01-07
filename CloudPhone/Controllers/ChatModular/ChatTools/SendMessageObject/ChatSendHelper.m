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
    
//    //信息包装成json字符串
//    NSDictionary *dic = @{@"messageType":@"text",@"data":str};
//    NSString *jsonString = [GeneralToolObject dictionaryToJson:dic];

    [body setStringValue:[NSString stringWithFormat:@"TextBase64%@",str]];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = username; //发送的目标
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    
    //添加回执
    NSXMLElement *recieved = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [recieved addAttributeWithName:@"id" stringValue:[message attributeStringValueForName:@"id"]];
    [message addChild:recieved];
    
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
    NSData *data= UIImageJPEGRepresentation(image, 0.1);
    
    NSString *siID = [XMPPStream generateUUID];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid elementID:siID]; //发送的目标
    
    //添加回执
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    //转化base64编码
    NSString *base64Str = [data base64EncodedString];
    
    NSMutableString *imageString = [[NSMutableString alloc]initWithString:@"ImgBase64"];
    [imageString appendString:base64Str];
    
//    NSDictionary *dic = @{@"messageType":@"image",@"data":base64Str};
//    NSString *jsonString = [GeneralToolObject dictionaryToJson:dic];
    
    [message addBody:imageString];
    
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
    
    NSString *siID = [XMPPStream generateUUID];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid elementID:siID]; //发送的目标
    
    //添加回执
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    //转化base64编码
    NSString *base64Str = [data base64EncodedString];
    
    NSDictionary *dic = @{@"data":base64Str,@"duration":[NSString stringWithFormat:@"%ld",(long)duration]};
    NSString *jsonString = [GeneralToolObject dictionaryToJson:dic];
    
    NSMutableString *audioString = [[NSMutableString alloc]initWithString:@"AudioBase64"];
    [audioString appendString:jsonString];
    
//    NSMutableString *audioString = [[NSMutableString alloc]initWithFormat:@"AudioBase64{%ld}",(long)duration];
//    [audioString appendString:base64Str];
    
    
    
    [message addBody:audioString];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] sendElement:message];

}

//发送地理位置
+ (void)sendLocationMessageWithLatitude:(double)lat longitude:(double)lon adress:(NSString *)address toUsername:(XMPPJID *)jid {
    NSString *siID = [XMPPStream generateUUID];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid elementID:siID]; //发送的目标
    
    //添加回执
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    //包在一个json字符串里
    NSDictionary *dic = @{@"latitude":[NSNumber numberWithDouble:lat],@"longitude":[NSNumber numberWithDouble:lon],@"address":address};
    NSString *jsonString = [GeneralToolObject dictionaryToJson:dic];
    
    NSMutableString *audioString = [[NSMutableString alloc]initWithString:@"LonBase64"];
    [audioString appendString:jsonString];
    
    [message addBody:audioString];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] sendElement:message];

}

//修改xmpp用户头像
+ (void)modifyUserHeadPortraitWithImage:(UIImage *)image nickName:(NSString *)name {
    
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns: @"vcard-temp"];
    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
    UIImage *imag = image;
    if (imag == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *num = [defaults objectForKey:UserNumber];
        imag = [UIImage imageWithContentsOfFile:[GeneralToolObject personalIconFilePath:num]];
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
    XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
    [newvCardTemp setNickname:str];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] updateMyvCardTemp:newvCardTemp];
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
