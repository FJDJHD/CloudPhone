//
//  NSString+Util.m
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (NSString*)initTelephoneWithReformat
{
    
    if ([self containsString:@"-"])
    {
        self = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self containsString:@" "])
    {
        self = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self containsString:@"("])
    {
        self = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsString:@")"])
    {
        self = [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return self;
}

@end
