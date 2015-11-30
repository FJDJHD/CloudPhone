//
//  NSString+MD5.m
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

- (NSString *)md5 {
    
    NSString *md5string = [NSString string];
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)[self length], buffer);
    
    int i;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        md5string = [md5string stringByAppendingString:[NSString stringWithFormat:@"%02x", buffer[i]]];
    
    return md5string;
}

- (NSString *)uppercaseMd5;
{
    return [[self md5] uppercaseString];
}





@end
