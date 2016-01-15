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
@property (nonatomic, strong) NSArray *iamgeArray;
@property (nonatomic, strong) NSArray *iamgeNolArray;
@end

@implementation DialKeyboard

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.iamgeArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    self.iamgeNolArray = @[@"1n",@"2n",@"3n",@"4n",@"5n",@"6n",@"7n",@"8n",@"9n"];
    UIView * keyboard = [[UIView alloc] init];
    keyboard.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    keyboard.userInteractionEnabled = YES;
   // UIImage *bgImage = [GeneralToolObject imageWithColor:[UIColor whiteColor]];
    UIImage *bgImage = [UIImage imageNamed:@"seperateline"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - (keyboard.frame.size.height - 5)/5);
    [keyboard addSubview:bgImageView];
   // keyboard.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:keyboard];
    for (int i = 0; i<15; i++) {
        
        UIButton * btn = [[UIButton alloc]init];
        btn.tag = i +1;
        btn.backgroundColor = [UIColor whiteColor];
        btn.showsTouchWhenHighlighted = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:30.0];
        switch (i) {
            case 9:
                [btn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"-n"] forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 10:
                [btn setImage:[UIImage imageNamed:@"0"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"0n"] forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 11:
                [btn setImage:[UIImage imageNamed:@"#"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"#n"] forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 12:
                [btn setImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];
                break;
            case 13:
                [btn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(dialBtnclick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 14:
                [btn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"deleten"] forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.iamgeArray[i]]] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.iamgeNolArray[i]]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        
        CGFloat dis = 0.0;
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
