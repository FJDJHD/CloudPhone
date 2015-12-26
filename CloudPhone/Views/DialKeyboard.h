//
//  DialKeyboard.h
//  willKeyboard
//
//  Created by iTelDeng on 15/12/26.
//  Copyright © 2015年 wille. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DialKeyboard;
@protocol DialKeyboardDelegate <NSObject>

@optional
/** 点击了数字按钮 */
- (void)keyboard:(DialKeyboard *)keyboard didClickButton:(UIButton *)button;
/** 点击删除按钮 */
- (void)keyboard:(DialKeyboard *)keyboard didClickDeleteBtn:(UIButton *)button;
/** 点击收起按钮 */
- (void)keyboard:(DialKeyboard *)keyboard didClickRemoveBtn:(UIButton *)button;
/** 点击拨打按钮 */
- (void)keyboard:(DialKeyboard *)keyboard didClickDialBtn:(UIButton *)button;

- (void)keyboardShow;
- (void)keyboardHidden;
@end

@interface DialKeyboard : UIView
@property (nonatomic, weak) id<DialKeyboardDelegate>delegate;
@end

