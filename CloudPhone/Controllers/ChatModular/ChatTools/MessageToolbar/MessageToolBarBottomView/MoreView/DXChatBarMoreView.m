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
#import "Global.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8
#define OFFUPSIDE  12

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
    
    //相册照片
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, OFFUPSIDE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chat_photo"] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_photoButton.frame), CGRectGetMaxY(_photoButton.frame) + 5, _photoButton.frame.size.width, 20)];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.text = @"照片";
    photoLabel.font = [UIFont systemFontOfSize:13.0];
    photoLabel.textColor = RGB(102, 102, 102);
    [self addSubview:photoLabel];
    
    //拍照
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, OFFUPSIDE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chat_takePic"] forState:UIControlStateNormal];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    UILabel *picLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_takePicButton.frame), CGRectGetMaxY(_takePicButton.frame) + 5, _takePicButton.frame.size.width, 20)];
    picLabel.textAlignment = NSTextAlignmentCenter;
    picLabel.text = @"拍摄";
    picLabel.font = [UIFont systemFontOfSize:13.0];
    picLabel.textColor = RGB(102, 102, 102);
    [self addSubview:picLabel];
    
    //地图
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, OFFUPSIDE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chat_location"] forState:UIControlStateNormal];

    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_locationButton.frame), CGRectGetMaxY(_locationButton.frame) + 5, _locationButton.frame.size.width, 20)];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.text = @"位置";
    locationLabel.font = [UIFont systemFontOfSize:13.0];
    locationLabel.textColor = RGB(102, 102, 102);
    [self addSubview:locationLabel];
    
    
    //打电话
    _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, OFFUPSIDE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_audioCallButton setImage:[UIImage imageNamed:@"chat_playPhone"] forState:UIControlStateNormal];
    [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audioCallButton];
    
    UILabel *audioLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_audioCallButton.frame), CGRectGetMaxY(_audioCallButton.frame) + 5, _audioCallButton.frame.size.width, 20)];
    audioLabel.textAlignment = NSTextAlignmentCenter;
    audioLabel.text = @"电话";
    audioLabel.font = [UIFont systemFontOfSize:13.0];
    audioLabel.textColor = RGB(102, 102, 102);
    [self addSubview:audioLabel];
    
    
    //视频
    _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoCallButton setFrame:CGRectMake(insets, OFFUPSIDE + CHAT_BUTTON_SIZE + 35, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoCallButton setImage:[UIImage imageNamed:@"chat_palyVedio"] forState:UIControlStateNormal];
    [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_videoCallButton];
    
    UILabel *videoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_videoCallButton.frame), CGRectGetMaxY(_videoCallButton.frame) + 5, _videoCallButton.frame.size.width, 20)];
    videoLabel.textAlignment = NSTextAlignmentCenter;
    videoLabel.text = @"视频";
    videoLabel.font = [UIFont systemFontOfSize:13.0];
    videoLabel.textColor = RGB(102, 102, 102);
    [self addSubview:videoLabel];

    CGRect frame = self.frame;
    self.frame = CGRectMake(0, 0, frame.size.width, CHAT_BUTTON_SIZE*2 + 20*2 + 40);

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

- (void)locationAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]){
        [_delegate moreViewLocationAction:self];
    }
}



- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

@end
