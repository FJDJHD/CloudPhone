//
//  ChatMessageFactory.h
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OriginMessageCell.h"
#import "TextMessageCell.h"
#import "PictureMessageCell.h"
#import "VoiceMessageCell.h"
#import "LocationMessageCell.h"

@interface ChatMessageFactory : NSObject

+ (OriginMessageCell *)configureDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller table:(UITableView *)tableView;


@end
