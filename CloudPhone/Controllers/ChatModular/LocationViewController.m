//
//  LocationViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "LocationViewController.h"
#import "Global.h"

@interface LocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate> {

    MKMapView *_mapView;
    MKPointAnnotation *_annotation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
}

@property (nonatomic, copy) NSString *addressString;

@property (nonatomic, strong) MBProgressHUD *HUD;


@end

@implementation LocationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate address:(NSString *)address
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
        _addressString = [NSString stringWithString:address];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏返回按钮
    
    self.title = @"位置信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //加载地图
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;
    [self.view addSubview:_mapView];
    
    if (_isSendLocation) {
        _mapView.showsUserLocation = YES;//显示当前位置
        
        //导航栏右按钮
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(0, 0, 44, 44);
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        [self startLocation];
    }
    else{
        [self moveToLocation:_currentLocationCoordinate];
    }

}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            weakSelf.addressString = [NSString stringWithString:placemark.name];
            
            [self moveToLocation:userLocation.coordinate];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self HUDHidden];
    if (error.code == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            
        }
        default:
            break;
    }
}

#pragma mark - public

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    [self AddHUD];
    
}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
{
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    if (_addressString && _addressString.length > 0) {
        _annotation.title = _addressString;
    }
    
    [_mapView addAnnotation:_annotation];
}


- (void)moveToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    [self HUDHidden];
    
    _currentLocationCoordinate = locationCoordinate;
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(_currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self createAnnotationWithCoords:_currentLocationCoordinate];
}


- (void)sendButtonClick {
    
    if (self.locationBlock) {
        self.locationBlock(_currentLocationCoordinate.latitude,_currentLocationCoordinate.longitude,_addressString);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MBProgressHUD Show or Hidden
- (void)AddHUD {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"请稍后...";
}

- (void)HUDHidden {
    if (_HUD) {
        _HUD.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
