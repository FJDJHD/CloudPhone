//
//  MessageCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MessageCell.h"
#import "UIImage+ResizeImage.h"
#import "Global.h"
#import "EMCDDeviceManager.h"
#import "XMPPvCardTemp.h"

@interface MessageCell() {

    
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [ColorTool backgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"mine_icon"];
        _iconView.layer.cornerRadius = 24;
        _iconView.layer.masksToBounds = YES;
        [self addSubview:_iconView];
        
        _textView = [BuddleButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:15];
        [_textView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self addSubview:_textView];
        
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame {
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    //气泡
    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    //聊天背景颜色
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];

    //聊天头像
    _iconView.frame = cellFrame.iconFrame;
    //气泡frame
    _textView.frame = cellFrame.textFrame;
    
    if (message.type) {
        //他人
        if (message.otherPhoto != nil){
            _iconView.image = message.otherPhoto;
        }else{
            NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:message.chatJID];
            if (photoData != nil){
                _iconView.image = [UIImage imageWithData:photoData];
            }
        }
    } else{
        //自己
        XMPPvCardTemp *myvCardTemp = [[(AppDelegate *)[UIApplication sharedApplication].delegate xmppvCardTempModule] myvCardTemp];
        if (myvCardTemp.photo != nil) {
            _iconView.image = [UIImage imageWithData:myvCardTemp.photo];
        } else {
            _iconView.image = [UIImage imageNamed:@"mine_icon"];
        }

    }
    
    //消息类型
    if (message.messageType == kImageMessage) {
        //图片
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:message.image forState:UIControlStateNormal];
        [_textView setTitle:nil forState:UIControlStateNormal];
    } else if (message.messageType == kVoiceMessage) {
        //语音
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:nil forState:UIControlStateNormal];
        [_textView setTitle:[NSString stringWithFormat:@"%@''",message.voiceTime] forState:UIControlStateNormal];
        
    } else {
        //文字
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:nil forState:UIControlStateNormal];
        [_textView setTitle:message.text forState:UIControlStateNormal];
    }
    
    //这里给button传语音沙盒路径
    _textView.voicePath = message.voiceFilepath;
    //消息类型
    _textView.messageType = message.messageType;
    
}

- (void)buttonClick:(UIButton *)sender {
    
    BuddleButton *tempButton = (BuddleButton *)sender;
    if (tempButton.messageType == kImageMessage) {
        //图片
    }else if (tempButton.messageType == kVoiceMessage) {
        //语音
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:tempButton.voicePath completion:^(NSError *error) {
            if (!error) {
                DLog(@"播放语音");
            } else {
                DLog(@"播放error ＝ %@",error);
            }
        }];
        
    } else {
        
        //文字
    }
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
