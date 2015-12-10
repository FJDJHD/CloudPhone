//
//  UIImage+ResizeImage.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-20.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "UIImage+ResizeImage.h"

@implementation UIImage (ResizeImage)

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}

/** 把图片缩小到指定的宽度范围内为止 */
- (UIImage *)scaleImageWithWidth:(CGFloat)width{
    if (self.size.width <width || width <= 0) {
        return self;
    }
    
    CGFloat scale = self.size.width/width;
    CGFloat height = self.size.height/scale;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // 开始上下文 目标大小是 这么大
    UIGraphicsBeginImageContext(rect.size);
    
    // 在指定区域内绘制图像
    [self drawInRect:rect];
    
    // 从上下文中获得绘制结果
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文返回结果
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
