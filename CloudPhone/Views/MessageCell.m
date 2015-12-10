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

@interface MessageCell() {

    UIImageView *_iconView;
    UIButton *_textView;
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
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:15];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self addSubview:_textView];
        
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame {
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _iconView.frame = cellFrame.iconFrame;
    
    _textView.frame = cellFrame.textFrame;
    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];

    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    
    if (message.messageType == kImageMessage) {
        //图片
        [_textView setImage:message.image forState:UIControlStateNormal];
        [_textView setTitle:nil forState:UIControlStateNormal];
    } else {
        //文字
        [_textView setImage:nil forState:UIControlStateNormal];
        [_textView setTitle:message.text forState:UIControlStateNormal];

    }
 
    
}


@end
