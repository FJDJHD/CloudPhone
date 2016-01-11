//
//  DialKeyboard.m
//  willKeyboard
//
//  Created by iTelDeng on 15/12/26.
//  Copyright © 2015年 wille. All rights reserved.
//

#import "DialKeyboard.h"
#import "Global.h"
@interface DialKeyboard()
@end

@implementation DialKeyboard

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIView * keyboard = [[UIView alloc] init];
    keyboard.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    keyboard.userInteractionEnabled = YES;
    UIImage *bgImage = [GeneralToolObject imageWithColor:[UIColor lightGrayColor]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - (keyboard.frame.size.height - 5)/5);
    [keyboard addSubview:bgImageView];
   // keyboard.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:keyboard];
    for (int i = 0; i<15; i++) {
        
        UIButton * btn = [[UIButton alloc]init];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.showsTouchWhenHighlighted = YES;
        NSString * titleSTR = nil;
        btn.titleLabel.font = [UIFont systemFontOfSize:30.0];
        switch (i) {
            case 9:
                titleSTR = @"*";
                btn.titleEdgeInsets = UIEdgeInsetsMake(keyboard.frame.size.height / 5 * 0.25 , 0, 0, 0);
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 10:
                titleSTR = @"0";
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 11:
                titleSTR = @"#";
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 12:
                titleSTR = @" ";
                [ btn addTarget:self action:@selector(removeBtnclick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 13:
                [btn setImage:[UIImage imageNamed:@"phone_dial"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(dialBtnclick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 14:
                [btn setImage:[UIImage imageNamed:@"phone_delete"] forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                titleSTR = [NSString stringWithFormat:@"%d",i+1 ] ;
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        
        [btn setTitle: titleSTR forState:UIControlStateNormal];
        CGFloat dis = 1;
        CGFloat btnW =(keyboard.frame.size.width - (2*dis))/3 ;
        CGFloat btnH = (keyboard.frame.size.height - (5*dis))/5 ;
        CGFloat btnY = (1 + (i/3)*(btnH + dis));
        CGFloat btnX = (i%3)*(btnW + dis);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [keyboard addSubview:btn];
    }
   
    return self;
}

- (void)numBtnClick:(UIButton *)numBtn {
    
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickButton:)]) {
        [self.delegate keyboard:self didClickButton:numBtn];
    }
}

- (void)deleteBtnClick:(UIButton *)deleteBtn {
    
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickDeleteBtn:)]) {
        [self.delegate keyboard:self didClickDeleteBtn:deleteBtn];
    }
}

- (void)removeBtnclick:(UIButton *)removeBtn {
    
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickRemoveBtn:)]) {
        [self.delegate keyboard:self didClickRemoveBtn:removeBtn];
    }
}

- (void)dialBtnclick:(UIButton *)dialBtn {
    
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickDialBtn:)]) {
        [self.delegate keyboard:self didClickDialBtn:dialBtn];
    }
}

@end
