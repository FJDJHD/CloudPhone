//
//  LocationViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/12/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface LocationViewController : UIViewController


@property (nonatomic, copy) void (^locationBlock)(double latitude,double longitude, NSString *address);


//点击聊天对话框进来的
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate address:(NSString *)address;


@end
