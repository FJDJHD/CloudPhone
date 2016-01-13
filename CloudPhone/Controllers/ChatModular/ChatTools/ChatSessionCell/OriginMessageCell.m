//
//  OriginMessageCell.m
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "OriginMessageCell.h"
#import "ChatSendHelper.h"


@implementation OriginMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [ColorTool backgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"mine_icon"];
        _iconImgView.layer.cornerRadius = ChatIconSize/2.0;
        _iconImgView.layer.masksToBounds = YES;
        [self addSubview:_iconImgView];
        
        //气泡
        _buddleBtn = [BuddleButton buttonWithType:UIButtonTypeCustom];
        _buddleBtn.titleLabel.numberOfLines = 0;
        _buddleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buddleBtn addTarget:self action:@selector(buddleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _buddleBtn.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self addSubview:_buddleBtn];
    }
    return self;
}


- (void)cellForDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller {
    
    self.cellFrameModel = model;
    
    self.messageModel = model.message;
    
    //给button穿值，方便点击取值
    self.buddleBtn.model = model.message;
    
    //气泡
    NSString *buddleBackImage = _messageModel.type ? @"chat_recive_nor" : @"chat_send_nor";
    [_buddleBtn setBackgroundImage:[UIImage resizeImage:buddleBackImage] forState:UIControlStateNormal];
    
    //聊天文字背景颜色
    UIColor *textColor = _messageModel.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_buddleBtn setTitleColor:textColor forState:UIControlStateNormal];
    
    //气泡frame
    _buddleBtn.frame = model.textFrame;
    
    
    //聊天头像frame
    _iconImgView.frame = model.iconFrame;

    //头像
    if (_messageModel.type) {
        //他人
        UIImage *image = [ChatSendHelper getPhotoWithJID:_messageModel.chatJID];
        _iconImgView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
        
    } else{
        //自己
        UIImage *image = [ChatSendHelper getPhotoWithJID:[[(AppDelegate *)[UIApplication sharedApplication].delegate xmppStream] myJID]];
        _iconImgView.image = image ? image :[UIImage imageNamed:@"mine_icon"];
    }

}

- (void)buddleBtnClick:(UIButton *)sender {

}

@end
