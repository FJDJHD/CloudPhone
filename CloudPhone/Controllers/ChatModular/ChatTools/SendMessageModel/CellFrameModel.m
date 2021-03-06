//
//  CellFrameModel.m
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "CellFrameModel.h"
#import "UIImage+ResizeImage.h"

#define padding    10
#define iconW      ChatIconSize
#define iconH      iconW
#define textW      150

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
    
    //3.内容的Frame
    CGFloat textFrameY = iconFrameY;
 
    if (_message.messageType == kImageMessage) {
        //*******图片******//
        
        _message.image = [_message.image scaleImageWithWidth:120];
        CGFloat textFrameX = message.type ? (2 * padding + iconFrameW) : (frame.size.width - 2 * padding - iconFrameW - _message.image.size.width);
        _textFrame = CGRectMake(textFrameX, textFrameY - 3, _message.image.size.width, _message.image.size.height);
        
    } else if (_message.messageType == kVoiceMessage) {
        //********语音******//
       
        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        CGSize textSize = [@"暂时写固a" boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height +textPadding * 2);
         CGFloat textFrameX = message.type ? (2 * padding + iconFrameW) : (frame.size.width - 2 * padding - iconFrameW - textRealSize.width);
        _textFrame = (CGRect){textFrameX,textFrameY - 3,textRealSize};

    } else if (_message.messageType == kLocationMessage) {
       //********地理位置******//
        
        UIImage *locImage = [UIImage imageNamed:@"chatView_location_map"];
        CGFloat textFrameX = message.type ? (2 * padding + iconFrameW) : (frame.size.width - 2 * padding - iconFrameW - locImage.size.width - 35);
        _textFrame = CGRectMake(textFrameX, textFrameY - 3, locImage.size.width + 35, locImage.size.height+35);
        
    } else {
        //***********文字*********//
        
        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        CGSize textSize = [_message.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height +textPadding * 2);
        CGFloat textFrameX = message.type ? (2 * padding + iconFrameW) : (frame.size.width - 2 * padding - iconFrameW - textRealSize.width);
        _textFrame = (CGRect){textFrameX,textFrameY - 3,textRealSize};
    
    }
    
    //cell 的高度
    _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
    
}

@end
