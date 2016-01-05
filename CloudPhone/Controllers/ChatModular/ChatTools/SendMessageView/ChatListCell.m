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
        _iconImageView.layer.cornerRadius = ChatIconSize/2.0;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.frame = CGRectMake(15, (60 - ChatIconSize)/2.0, ChatIconSize, ChatIconSize);
        [self addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, CGRectGetMinY(_iconImageView.frame) + 2, 200, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
        
        _lastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame)+2, 100, 20)];
        _lastMessageLabel.font = [UIFont systemFontOfSize:13];
        _lastMessageLabel.textColor = [UIColor grayColor];
        [self addSubview:_lastMessageLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(MainWidth - 70, CGRectGetMinY(_iconImageView.frame) + 3, 60, 18)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        //小红点
        _unreadLabel = [[UILabel alloc]init];
        _unreadLabel.layer.cornerRadius = 9;
        _unreadLabel.clipsToBounds = YES;
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.hidden = YES;
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.font = [UIFont boldSystemFontOfSize:10];
        [self addSubview:_unreadLabel];
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
        
        //小红点
        NSString *unread = [temp objectAtIndex:message_unreadMessage];
        NSInteger tempUnread = [unread integerValue];
        if (0 < tempUnread && tempUnread <= 99) {
            _unreadLabel.hidden = NO;
            _unreadLabel.text = unread;
            _unreadLabel.frame = CGRectMake(MainWidth - 30, (60 - 18)/2.0 + 10, 18, 18);
        } else if (tempUnread > 99) {
            _unreadLabel.hidden = NO;
            _unreadLabel.frame = CGRectMake(MainWidth - 36, (60 - 18)/2.0 + 10, 24, 18);
            _unreadLabel.text = @"99+";
        } else {
            _unreadLabel.hidden = YES;
        }
        
        //时间
        NSTimeInterval timeInt = [[temp objectAtIndex:message_time] integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt];
        _timeLabel.text = [GeneralToolObject compareCurrentTime:date];
        

        //头像
        XMPPJID *jid = [XMPPJID jidWithString:[temp objectAtIndex:message_id]];
        UIImage *image = [ChatSendHelper getPhotoWithJID:jid];
        _iconImageView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
    }

}



//加上8小时
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger interval = [zone secondsFromGMTForDate:date];
//        NSDate *localeDate = [date  dateByAddingTimeInterval:interval];



@end
