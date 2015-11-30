//
//  ColorTool.h
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Category.h"
@interface ColorTool : NSObject

//导航栏颜色
+ (UIColor *)navigationColor;

//背景颜色
+ (UIColor *)backgroundColor;

//字体颜色
+ (UIColor *)textColor;

//浅色字体颜色
+ (UIColor *)lightTextColor;

@end
