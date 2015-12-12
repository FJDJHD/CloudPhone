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
#import "BuddleButton.h"

@interface MessageCell() {

    UIImageView *_iconView;
    BuddleButton *_textView;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [ColorTool backgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"icon.png"];
        [self addSubview:_iconView];
        
        _textView = [BuddleButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_textView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self addSubview:_textView];
        
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame {
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _textView.model = message; //判断点击的，给button加一个属性

    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];

    _iconView.frame = cellFrame.iconFrame;
    _textView.frame = cellFrame.textFrame;
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    
    if (message.messageType == kImageMessage) {
        //图片
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:message.image forState:UIControlStateNormal];
        [_textView setTitle:nil forState:UIControlStateNormal];
    } else if (message.messageType == kVoiceMessage) {
        //语音
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:nil forState:UIControlStateNormal];
        [_textView setTitle:@"语音" forState:UIControlStateNormal];
        
    }else {
        //文字
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:nil forState:UIControlStateNormal];
        [_textView setTitle:message.text forState:UIControlStateNormal];

    }
}

//- (void)buttonClick:(UIButton *)sender {
//    
//    BuddleButton *tempButton = (BuddleButton *)sender;
//    DLog(@"tempButton.model.text = %@",tempButton.model.text);
//    if (tempButton.model.messageType == kImageMessage) {
//        //图片
//    }else if (tempButton.model.messageType == kVoiceMessage) {
//        //语音
//        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:tempButton.model.voiceFilepath completion:^(NSError *error) {
//            if (!error) {
//                DLog(@"播放语音");
//            } else {
//                DLog(@"播放error ＝ %@",error);
//            }
//        }];
//
//    } else {
//    
//        //文字
//    }
//}


@end
