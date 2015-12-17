//
//  ChatListCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/16.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ChatListCell.h"

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
        
        _lastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), 200, 20)];
        _lastMessageLabel.font = [UIFont systemFontOfSize:13];
        _lastMessageLabel.textColor = [UIColor grayColor];
        [self addSubview:_lastMessageLabel];
        
        
    }
    return self;
}

@end
