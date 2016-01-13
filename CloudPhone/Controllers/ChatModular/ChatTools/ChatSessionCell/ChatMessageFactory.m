//
//  ChatMessageFactory.m
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "ChatMessageFactory.h"


@implementation ChatMessageFactory

+ (OriginMessageCell *)configureDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller table:(UITableView *)tableView; {

    OriginMessageCell *cell = nil;
    
    switch (model.message.messageType) {
        case kTextMessage: {
            NSString *textIdentify = @"textIdentify";
            cell =  [tableView dequeueReusableCellWithIdentifier:textIdentify];
            if (!cell) {
                cell = [[TextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textIdentify];
            }
            
        }
            break;
        case kImageMessage: {
            NSString *imageIdentify = @"imageIdentify";
            cell =  [tableView dequeueReusableCellWithIdentifier:imageIdentify];
            if (!cell) {
                cell = [[PictureMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageIdentify];
            }
        
        }
            break;
        case kVoiceMessage: {
            NSString *voiceIdentify = @"voiceIdentify";
            cell =  [tableView dequeueReusableCellWithIdentifier:voiceIdentify];
            if (!cell) {
                cell = [[VoiceMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceIdentify];
            }
            
        }
            break;
        case kLocationMessage: {
            NSString *locIdentify = @"locIdentify";
            cell =  [tableView dequeueReusableCellWithIdentifier:locIdentify];
            if (!cell) {
                cell = [[LocationMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locIdentify];
            }
        }
            break;
        default:
            break;
    }
        
    return cell;
}


@end
