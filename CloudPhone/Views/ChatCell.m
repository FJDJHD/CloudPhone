//
//  ChatCell.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ChatCell.h"
#import "Global.h"
@implementation ChatCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *dailImg = [UIImage imageNamed:@"mine_icon"];
        CGRect dailImageFrame = CGRectMake(15, (60 - dailImg.size.height)/2.0 , dailImg.size.width, dailImg.size.height);
        _chatImageView = [[UIImageView alloc]initWithImage:dailImg];
        _chatImageView.frame = dailImageFrame;
        [self addSubview:_chatImageView];
        
        CGRect nameLableFrame = CGRectMake(CGRectGetMaxX(_chatImageView.frame) + 10, 10, 190, 20);
        _chatNameLabel = [[UILabel alloc]initWithFrame:nameLableFrame];
        _chatNameLabel.font = [UIFont systemFontOfSize:14.0];
        _chatNameLabel.textColor = [UIColor blackColor];
        [self addSubview:_chatNameLabel];
        
        CGRect numberLableFrame = CGRectMake(CGRectGetMaxX(_chatImageView.frame) + 10,CGRectGetMaxY(_chatNameLabel.frame), 190, 20);
        _chatLastContentLabel = [[UILabel alloc]initWithFrame:numberLableFrame];
        _chatLastContentLabel.text = @"你准备好了没？";
        _chatLastContentLabel.font = [UIFont systemFontOfSize:14.0];
        _chatLastContentLabel.textColor = [UIColor blackColor];
        [self addSubview:_chatLastContentLabel];
        
        
        CGRect timeLableFrame = CGRectMake(MainWidth - 60, 20, 50, 20);
        _chatTimeLabel = [[UILabel alloc]initWithFrame:timeLableFrame];
        _chatTimeLabel.text = @"10:00";
        _chatTimeLabel.textAlignment = NSTextAlignmentRight;
        _chatTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _chatTimeLabel.textColor = [UIColor blackColor];
        [self addSubview:_chatTimeLabel];
        
        }
    return self;
}

@end
