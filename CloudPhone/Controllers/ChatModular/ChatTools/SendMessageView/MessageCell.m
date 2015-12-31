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
#import "ChatSendHelper.h"
#import "MWPhotoBrowser.h"
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

@interface MessageCell()<MWPhotoBrowserDelegate> {
    UIImageView *_animationImageView;
    NSMutableArray *_senderAnimationImages;
    NSMutableArray *_recevierAnimationImages;
}

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) UIViewController *tempController;



@end

@implementation MessageCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [ColorTool backgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"mine_icon"];
        _iconView.layer.cornerRadius = ChatIconSize/2.0;
        _iconView.layer.masksToBounds = YES;
        [self addSubview:_iconView];
        
        _textView = [BuddleButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:15];
        [_textView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self addSubview:_textView];
        
        //语音动画。。。放这里。。有点
        _animationImageView = [[UIImageView alloc] init];
        _animationImageView.animationDuration = ANIMATION_IMAGEVIEW_SPEED;
        [self addSubview:_animationImageView];
        
        _senderAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
        _recevierAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
        
    }
    return self;
}

- (void)cellForDataWithModel:(CellFrameModel *)cellFrame indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller{

    _textView.tag = indexPath.row;
    _tempController = controller;
    
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    //气泡
    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    //聊天背景颜色
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    
    //聊天头像frame
    _iconView.frame = cellFrame.iconFrame;
    //气泡frame
    _textView.frame = cellFrame.textFrame;
    
    if (message.type) {
        //他人
        if (message.otherPhoto != nil){
            _iconView.image = message.otherPhoto;
        }else{
            UIImage *image = [ChatSendHelper getPhotoWithJID:message.chatJID];
            _iconView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
        }
    } else{
        //自己
        UIImage *image = [ChatSendHelper getPhotoWithJID:[[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] myJID]];
        _iconView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
    }
    
    //消息类型
    if (message.messageType == kImageMessage) {
        //图片
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:message.image forState:UIControlStateNormal];
        [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, 0,0, 0)];
        _textView.imageView.layer.cornerRadius = 7.0;
        _textView.imageView.layer.masksToBounds = YES;
        [_textView setTitle:nil forState:UIControlStateNormal];
        _animationImageView.image = nil;
        [_textView addSubview:_animationImageView];
    } else if (message.messageType == kVoiceMessage) {
        //语音
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:nil forState:UIControlStateNormal];
        _textView.imageView.layer.cornerRadius = 0.0;
        [_textView setTitle:[NSString stringWithFormat:@"%@''",message.voiceTime] forState:UIControlStateNormal];
        if (message.type) {
            //别人的语音
            [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, 20,0, -20)];
            _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
            _animationImageView.frame = CGRectMake(20, (_textView.frame.size.height - ANIMATION_IMAGEVIEW_SIZE)/2.0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE);
            _animationImageView.animationImages = _recevierAnimationImages;
            [_textView addSubview:_animationImageView];
        } else {
            //自己的语音
            [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, -20,0, 20)];
            _animationImageView.image = [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
            _animationImageView.frame = CGRectMake(_textView.frame.size.width - ANIMATION_IMAGEVIEW_SIZE - 20, (_textView.frame.size.height - ANIMATION_IMAGEVIEW_SIZE)/2.0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE);
            _animationImageView.animationImages = _senderAnimationImages;
            [_textView addSubview:_animationImageView];
        }
        
    } else {
        //文字
        [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, 0,0, 0)];
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setImage:nil forState:UIControlStateNormal];
        _textView.imageView.layer.cornerRadius = 0.0;
        [_textView setTitle:message.text forState:UIControlStateNormal];
        _animationImageView.image = nil;
        [_textView addSubview:_animationImageView];
    }
    
    //这里给button传语音沙盒路径
    _textView.voicePath = message.voiceFilepath;
    _textView.imagePath = message.imagePath;
    
    //消息类型
    _textView.messageType = message.messageType;
    
}

- (void)buttonClick:(UIButton *)sender {
    
    BuddleButton *tempButton = (BuddleButton *)sender;
    
    if (tempButton.messageType == kImageMessage) {
        
        //图片
        [self browserClickImage:tempButton.imagePath];
        
    }else if (tempButton.messageType == kVoiceMessage) {
        
        //播放语音
        [self playClickAudio:tempButton.voicePath];
        
    } else {
        
        //文字
    }
}

//放大图片
- (void)browserClickImage:(NSString *)path {

    _photos = [[NSMutableArray alloc]initWithCapacity:0];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSArray *arr = [NSArray arrayWithObject:image];
    [self showPhotoBrowser:arr index:0];

}

//播放语音
- (void)playClickAudio:(NSString *)path {
    //先暂停当前语音
     [[EMCDDeviceManager sharedInstance] stopPlaying];
    
    //获取屏幕中可视视图
    MessageViewController *tempControl = (MessageViewController *)self.tempController;
    NSArray *indexPaths = [tempControl.tableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleIndexPath in indexPaths) {
        MessageCell *cell = [tempControl.tableView cellForRowAtIndexPath:visibleIndexPath];
        [cell stopAudioAnimation];
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
                
            });            DLog(@"播放error ＝ %@",error);
        }
    }];

}


-(void)showPhotoBrowser:(NSArray*)imageArray index:(NSInteger)currentIndex{
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [MWPhoto photoWithImage:object];
            } else if ([object isKindOfClass:[NSURL class]]) {
                photo = [MWPhoto photoWithURL:object];
            } else if ([object isKindOfClass:[NSString class]]) {
                photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:object]];
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = NO;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    [photoBrowser setCurrentPhotoIndex:currentIndex];
    
    MessageViewController *tempControl = (MessageViewController *)self.tempController;
    tempControl.scrollType = ScrollStillType;
    [self.tempController.navigationController pushViewController:photoBrowser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count) {
        return self.photos[index];
    }
    return nil;
}


-(void)startAudioAnimation
{
    [_animationImageView startAnimating];
}

-(void)stopAudioAnimation
{
    [_animationImageView stopAnimating];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}



//- (void)setCellFrame:(CellFrameModel *)cellFrame {
//    _cellFrame = cellFrame;
//    MessageModel *message = cellFrame.message;
//    
//    //气泡
//    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
//    //聊天背景颜色
//    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
//    [_textView setTitleColor:textColor forState:UIControlStateNormal];
//    
//    //聊天头像frame
//    _iconView.frame = cellFrame.iconFrame;
//    //气泡frame
//    _textView.frame = cellFrame.textFrame;
//    
//    if (message.type) {
//        //他人
//        if (message.otherPhoto != nil){
//            _iconView.image = message.otherPhoto;
//        }else{
//            UIImage *image = [ChatSendHelper getPhotoWithJID:message.chatJID];
//            _iconView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
//        }
//    } else{
//        //自己
//        UIImage *image = [ChatSendHelper getPhotoWithJID:[[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] myJID]];
//        _iconView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
//    }
//    
//    //消息类型
//    if (message.messageType == kImageMessage) {
//        //图片
//        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
//        [_textView setImage:message.image forState:UIControlStateNormal];
//        [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, 0,0, 0)];
//        _textView.imageView.layer.cornerRadius = 7.0;
//        _textView.imageView.layer.masksToBounds = YES;
//        [_textView setTitle:nil forState:UIControlStateNormal];
//        _animationImageView.image = nil;
//        [_textView addSubview:_animationImageView];
//    } else if (message.messageType == kVoiceMessage) {
//        //语音
//        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
//        [_textView setImage:nil forState:UIControlStateNormal];
//        _textView.imageView.layer.cornerRadius = 0.0;
//        [_textView setTitle:[NSString stringWithFormat:@"%@''",message.voiceTime] forState:UIControlStateNormal];
//        if (message.type) {
//            //别人的语音
//            [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, 20,0, -20)];
//            _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
//            _animationImageView.frame = CGRectMake(20, (_textView.frame.size.height - ANIMATION_IMAGEVIEW_SIZE)/2.0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE);
//            _animationImageView.animationImages = _recevierAnimationImages;
//            [_textView addSubview:_animationImageView];
//        } else {
//            //自己的语音
//            [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, -20,0, 20)];
//            _animationImageView.image = [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
//            _animationImageView.frame = CGRectMake(_textView.frame.size.width - ANIMATION_IMAGEVIEW_SIZE - 20, (_textView.frame.size.height - ANIMATION_IMAGEVIEW_SIZE)/2.0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE);
//            _animationImageView.animationImages = _senderAnimationImages;
//            [_textView addSubview:_animationImageView];
//        }
//        
//    } else {
//        //文字
//        [_textView setTitleEdgeInsets:UIEdgeInsetsMake(0, 0,0, 0)];
//        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
//        [_textView setImage:nil forState:UIControlStateNormal];
//        _textView.imageView.layer.cornerRadius = 0.0;
//        [_textView setTitle:message.text forState:UIControlStateNormal];
//        _animationImageView.image = nil;
//        [_textView addSubview:_animationImageView];
//    }
//    
//    //这里给button传语音沙盒路径
//    _textView.voicePath = message.voiceFilepath;
//    _textView.imagePath = message.imagePath;
//    //消息类型
//    _textView.messageType = message.messageType;
//    
//}

@end
