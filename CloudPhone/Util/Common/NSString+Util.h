//
//  NSString+Util.h
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

//去掉手机号的空格间隙等
- (NSString *)initTelephoneWithReformat;

@end
