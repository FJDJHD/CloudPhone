//
//  UIImage+ResizeImage.h
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-20.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImage)

+ (UIImage *)resizeImage:(NSString *)imageName;

/** 把图片缩小到指定的宽度范围内为止 */
- (UIImage *)scaleImageWithWidth:(CGFloat)width;

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;


//修改searchBar的颜色
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
