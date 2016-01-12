//
//  ColorTool.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ColorTool.h"

@implementation ColorTool

+(UIColor *)navigationColor{
    return [UIColor colorWithHexString:@"#2cceb7"];
}


+ (UIColor *)backgroundColor{
    return [UIColor colorWithHexString:@"#f7f2ee"];
}

+ (UIColor *)textColor{
    return [UIColor colorWithHexString:@"#323232"];
}

+(UIColor *)lightTextColor{
    return [UIColor colorWithHexString:@"#c8c8c8"];
}
@end
