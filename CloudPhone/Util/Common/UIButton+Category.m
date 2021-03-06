//
//  UIButton+Category.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "UIButton+Category.h"
#import "Global.h"
@implementation UIButton (Category)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {

    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16.0]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(105.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

@end
