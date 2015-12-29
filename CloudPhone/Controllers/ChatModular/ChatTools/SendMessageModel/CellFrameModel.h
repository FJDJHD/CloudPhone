//
//  CellFrameModel.h
//  CloudPhone
//
//  Created by wangcong on 15/12/9.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#define textPadding 18


@interface CellFrameModel : NSObject

@property (nonatomic, strong) MessageModel *message;

@property (nonatomic, assign) CGRect textFrame;

@property (nonatomic, assign) CGRect iconFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end
