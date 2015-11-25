//
//  UIImage_extra.m
//  LqzTest
//
//  Created by Kyle Yang on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage_extra.h"

@implementation UIImage (extra)
+ (UIImage *)imageScaleNamed:(NSString *)name{
    UIImage *img = [UIImage imageNamed:name];
    NSArray *arr1 = [name componentsSeparatedByString:@"#"];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];  
    if (arr1 && [arr1 count]==3) {
        NSString *tmpStr = [arr1 objectAtIndex:1];
        NSArray *arr2 = [tmpStr componentsSeparatedByString:@"_"];
        if ([arr2 count]==4) {
            if (version >= 5.0)  
            {  
                UIEdgeInsets edgeInsets = UIEdgeInsetsMake([[arr2 objectAtIndex:0] doubleValue], [[arr2 objectAtIndex:1] doubleValue], [[arr2 objectAtIndex:2] doubleValue], [[arr2 objectAtIndex:3] doubleValue]);
                img = [img resizableImageWithCapInsets:edgeInsets];
            }else{
                double leftCapWidth = MAX([[arr2 objectAtIndex:1] doubleValue], [[arr2 objectAtIndex:3] doubleValue]);
                double topCapHeight = MAX([[arr2 objectAtIndex:0] doubleValue], [[arr2 objectAtIndex:2] doubleValue]);
                img = [img stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
            }
        }
    }
    return img;
}

//1.等比率缩放
- (UIImage *)scaleImageToScale:(float)scaleSize

{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


//2.自定长宽
- (UIImage *)reSizeImageToSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}


//3.处理某个特定View 只要是继承UIView的object 都可以处理
-(UIImage*)captureView:(UIView *)theView
{
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}
@end
