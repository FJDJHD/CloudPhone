//
//  VoiceMessageCell.m
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "VoiceMessageCell.h"
#import "EMCDDeviceManager.h"
#import "MessageViewController.h"

#define ANIMATION_IMAGEVIEW_SIZE 25 // 小喇叭图片尺寸
#define ANIMATION_IMAGEVIEW_SPEED 1 // 小喇叭动画播放速度

// 发送
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"chat_sender_audio_playing_full" // 小喇叭默认图片
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_01 @"chat_sender_audio_playing_000" // 小喇叭动画第一帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_02 @"chat_sender_audio_playing_001" // 小喇叭动画第二帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_03 @"chat_sender_audio_playing_002" // 小喇叭动画第三帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_04 @"chat_sender_audio_playing_003" // 小喇叭动画第四帧


// 接收
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"chat_receiver_audio_playing_full" // 小喇叭默认图片
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01 @"chat_receiver_audio_playing000" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02 @"chat_receiver_audio_playing001" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03 @"chat_receiver_audio_playing002" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04 @"chat_receiver_audio_playing003" // 小喇叭动画第四帧

@interface VoiceMessageCell()

@property (nonatomic, strong) UIImageView *animationImageView;

@property (nonatomic, strong) NSMutableArray *senderAnimationImages;

@property (nonatomic, strong) NSMutableArray *recevierAnimationImages;

@property (nonatomic, strong) UIViewController *tempController;

@end

@implementation VoiceMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //语音动画
        _animationImageView = [[UIImageView alloc] init];
        _animationImageView.animationDuration = ANIMATION_IMAGEVIEW_SPEED;
        [self addSubview:_animationImageView];
        
        
    }
    return self;
}

- (void)cellForDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller {
    
    [super cellForDataWithModel:model indexPath:indexPath controller:controller];
    
    self.tempController = controller;
    
    //赋值
    [self.buddleBtn setTitle:[NSString stringWithFormat:@"%@''",self.messageModel.voiceTime] forState:UIControlStateNormal];
    if (self.messageModel.type) {
        //别人的语音
        [self.buddleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20,0, -20)];
        _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
        _animationImageView.frame = CGRectMake(20, (self.buddleBtn.frame.size.height - ANIMATION_IMAGEVIEW_SIZE)/2.0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE);
        _animationImageView.animationImages = self.recevierAnimationImages;
        [self.buddleBtn addSubview:_animationImageView];
    } else {
        //自己的语音
        [self.buddleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20,0, 20)];
        _animationImageView.image = [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
        _animationImageView.frame = CGRectMake(self.buddleBtn.frame.size.width - ANIMATION_IMAGEVIEW_SIZE - 20, (self.buddleBtn.frame.size.height - ANIMATION_IMAGEVIEW_SIZE)/2.0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE);
        _animationImageView.animationImages = self.senderAnimationImages;
        [self.buddleBtn addSubview:_animationImageView];
    }
}

- (void)buddleBtnClick:(UIButton *)sender {
    
    BuddleButton *tempButton = (BuddleButton *)sender;

    //播放语音
    [self playClickAudio:tempButton.model.voiceFilepath];
}


//播放语音
- (void)playClickAudio:(NSString *)path {
    //先暂停当前语音
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    
    //获取屏幕中可视视图
    MessageViewController *tempControl = (MessageViewController *)self.tempController;
    NSArray *indexPaths = [tempControl.tableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleIndexPath in indexPaths) {
        OriginMessageCell *cell = [tempControl.tableView cellForRowAtIndexPath:visibleIndexPath];
        if ([cell isKindOfClass:[VoiceMessageCell class]]) {
            VoiceMessageCell *voiceCell = (VoiceMessageCell *)cell;
            [voiceCell stopAudioAnimation];
        }
    }
    
    //语音动画
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[EMCDDeviceManager sharedInstance] isPlaying]) {
            [self startAudioAnimation];
        } else {
            [self stopAudioAnimation];
        }
    });
    
    
    //语音
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        if (!error) {
            DLog(@"播放语音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAudioAnimation];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopAudioAnimation];
            });
            DLog(@"播放error ＝ %@",error);
        }
    }];
}


-(void)startAudioAnimation
{
    [_animationImageView startAnimating];
}

-(void)stopAudioAnimation
{
    [_animationImageView stopAnimating];
}

//懒加载
- (NSMutableArray *)senderAnimationImages {
    if (!_senderAnimationImages) {
        _senderAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
        
    }
    return _senderAnimationImages;
}

- (NSMutableArray *)recevierAnimationImages {
    if (!_recevierAnimationImages) {
        _recevierAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
        
    }
    return _recevierAnimationImages;
}


@end
