//
//  ChatListCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/16.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ChatListCell.h"
#import "Global.h"
#import "ChatSendHelper.h"

@implementation ChatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:@"mine_icon"];
        _iconImageView = [[UIImageView alloc]initWithImage:image];
        _iconImageView.layer.cornerRadius = 24;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.frame = CGRectMake(15, (60 - 48)/2.0, 48, 48);
        [self addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, CGRectGetMinY(_iconImageView.frame) + 5, 200, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
        
        _lastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), 100, 20)];
        _lastMessageLabel.font = [UIFont systemFontOfSize:13];
        _lastMessageLabel.textColor = [UIColor grayColor];
        [self addSubview:_lastMessageLabel];
        
        //小红点
//        CGRect chatNotifyLabelRect = CGRectMake(MainWidth - 60, (60 - 20)/2.0, 20, 20);
//        _unreadLabel = [[UILabel alloc]initWithFrame:chatNotifyLabelRect];
//        _unreadLabel.layer.cornerRadius = 10;
//        _unreadLabel.clipsToBounds = YES;
//        _unreadLabel.textAlignment = NSTextAlignmentCenter;
//        _unreadLabel.text = @"10";
//        _unreadLabel.textColor = [UIColor whiteColor];
////        _unreadLabel.hidden = YES;
//        _unreadLabel.backgroundColor = [UIColor redColor];
//        _unreadLabel.font = [UIFont systemFontOfSize:9];
//        [self addSubview:_unreadLabel];
    }
    return self;
}


- (void)cellForData:(NSArray *)array index:(NSIndexPath *)indexpath {

    if (array.count > 0) {
        NSArray *temp = [array objectAtIndex:indexpath.row];
        //名称
        _nameLabel.text = [temp objectAtIndex:message_name];
        
        //最后信息
        _lastMessageLabel.text = [temp objectAtIndex:message_lastMessage];
        
        //头像
        XMPPJID *jid = [XMPPJID jidWithString:[temp objectAtIndex:message_id]];
        UIImage *image = [ChatSendHelper getPhotoWithJID:jid];
        _iconImageView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
    }

}







@end
