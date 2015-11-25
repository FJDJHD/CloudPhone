//
//  AirCloudNetAPIClient.h
//  AirCloud
//
//  Created by mc on 15/3/31.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MBProgressHUD.h"

//typedef enum {
//    Http = 0,
//    Https
//} HTTPType;

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface AirCloudNetAPIClient : AFHTTPRequestOperationManager

+ (AirCloudNetAPIClient *)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     serviceType:(NSString *)serviceType
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block;

@end
