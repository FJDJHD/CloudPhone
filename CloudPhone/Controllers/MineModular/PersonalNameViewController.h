//
//  PersonalNameViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/12/2.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalNameViewController : UIViewController

@property (nonatomic,copy) void (^modifyNameBlock)(NSString *);

@end
