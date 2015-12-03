//
//  PersonGenderViewController.h
//  CloudPhone
//
//  Created by iTelDeng on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonGenderViewController : UIViewController
@property (nonatomic,copy) void (^modifyGenderBlock)(NSInteger);
@end
