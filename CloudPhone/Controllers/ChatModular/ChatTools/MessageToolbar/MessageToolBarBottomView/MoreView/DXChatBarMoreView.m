/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 20, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chat_photo"] forState:UIControlStateNormal];
//    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 20, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chat_takePic"] forState:UIControlStateNormal];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
//    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_takePicButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
//    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
//    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_takePicButton];

    CGRect frame = self.frame;
//    if (type == ChatMoreTypeChat) {
//        frame.size.height = 150;
//        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
//        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
//        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_audioCallButton];
//        
//        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_videoCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
//        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
//        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_videoCallButton];
//    }
//    else if (type == ChatMoreTypeGroupChat)
//    {
//        frame.size.height = 80;
//    }
    self.frame = CGRectMake(0, 0, frame.size.width, CHAT_BUTTON_SIZE*2 + 20*2 + 40);
}

#pragma mark - action

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)takePicAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]) {
        [_delegate moreViewTakePicAction:self];
    }
}

//- (void)takePicAction{
//    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
//        [_delegate moreViewTakePicAction:self];
//    }
//}



//- (void)takeAudioCallAction
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
//        [_delegate moreViewAudioCallAction:self];
//    }
//}
//
//- (void)takeVideoCallAction
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
//        [_delegate moreViewVideoCallAction:self];
//    }
//}

@end
