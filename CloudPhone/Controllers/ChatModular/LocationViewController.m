//
//  LocationViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "LocationViewController.h"
#import "Global.h"
#import <MapKit/MapKit.h>

@interface LocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate> {

    MKMapView *_mapView;
    MKPointAnnotation *_annotation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //导航栏右按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 44, 44);
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -12;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    self.title = @"位置信息";
}




- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
