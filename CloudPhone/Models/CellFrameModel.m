//
//  CellFrameModel.m
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "CellFrameModel.h"

#define padding 10
#define iconW   40
#define iconH   iconW
#define textW   150

@implementation CellFrameModel

- (void)setMessage:(MessageModel *)message {

    _message = message;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //头像frame
    CGFloat iconFrameX = message.type ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = 10;
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //内容frame
    //3.内容的Frame
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    CGSize textSize = [_message.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height +textPadding * 2);
    CGFloat textFrameY = iconFrameY;
    CGFloat textFrameX = message.type ? (2 * padding + iconFrameW) : (frame.size.width - 2 * padding - iconFrameW - textRealSize.width);
    _textFrame = (CGRect){textFrameX,textFrameY,textRealSize};
    
    //cell 的高度
    _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
    
}

@end