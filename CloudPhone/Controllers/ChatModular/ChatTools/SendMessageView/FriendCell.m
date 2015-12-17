//
//  FriendCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/16.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "FriendCell.h"
#import "Global.h"

@implementation FriendCell

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
        
        _onlineLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), 200, 20)];
        _onlineLable.font = [UIFont systemFontOfSize:13];
        _onlineLable.textColor = [UIColor grayColor];
        [self addSubview:_onlineLable];

    }
    return self;
}

- (void)cellForData:(XMPPUserCoreDataStorageObject *)user {

    //名称
    NSArray *array = [user.displayName componentsSeparatedByString:XMPPSevser]; //从字符A中分隔成2个元素的数
    _nameLabel.text = user.nickname ? user.nickname :array[0];
    
    //是否在线
    if (user.section == 0) {
        _onlineLable.text = @"在线";
    } else if (user.section == 1) {
        _onlineLable.text = @"离开";
    } else if (user.section == 2) {
        _onlineLable.text = @"离线";
    } else {
        _onlineLable.text = @"未知";
    }
    
    //头像
    if (user.photo != nil){
        _iconImageView.image = user.photo;
    }else{
        NSData *photoData = [[[GeneralToolObject appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        if (photoData != nil){
            _iconImageView.image = [UIImage imageWithData:photoData];
        }
        else {
            _iconImageView.image = [UIImage imageNamed:@"mine_icon"];
        }
    }
}





@end
