//
//  NSString+MD5.h
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 *	@brief	MD5加密（小写）
 *
 *	@return	返回小写的加密串
 */
- (NSString *)md5;


/**
 *	@brief	MD5加密（大写）
 *
 *	@return	返回大写的加密串
 */
- (NSString *)uppercaseMd5;

@end
