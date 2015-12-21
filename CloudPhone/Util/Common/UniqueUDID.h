//
//  UniqueUDID.h
//  CloudPhone
//
//  Created by wangcong on 15/12/18.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniqueUDID : NSObject

@property (nonatomic, copy) NSString *udid;




//由于identifierForVendor删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致，所以要解决这个问题可以把第一次生成的唯一标示符，保存到keyChain中，当应用被删除后keyChain中的数据还在，下次在从keyChain中取就OK了
+(instancetype)shareInstance;

@end
