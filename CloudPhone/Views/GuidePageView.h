//
//  GuidePageView.h
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageView : UIView

@property (nonatomic, strong) UIButton *startButton;

- (id)initWithImages:(NSArray *)imagesArray;
- (id)initWithImages:(NSArray *)imagesArray andMargin:(NSInteger)margin;
- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imagesArray;
- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imagesArray andMargin:(NSInteger)margin;

- (void)setStartButtonHidden:(BOOL)hidden;

@end
