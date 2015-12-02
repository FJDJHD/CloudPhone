//
//  AirCloudNetAPIClient.m
//  AirCloud
//
//  Created by mc on 15/3/31.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import "AirCloudNetAPIClient.h"
#import "GeneralToolObject.h"
#import "NSString+MD5.h"

@implementation AirCloudNetAPIClient

+ (AirCloudNetAPIClient *)sharedJsonClient {
    static AirCloudNetAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        sharedClient = [[AirCloudNetAPIClient alloc] init];
    });
    
    return sharedClient;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    // 这里服务器需要是这样的属性（post 请求，body是json格式）
    self.requestSerializer =  [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",nil];
    
//    long timeInt =[[NSDate date] timeIntervalSince1970];
//    NSString *imei = [GeneralToolObject CPUuidString];
//    NSString *versionName = APP_VERSION;
//    NSString *version = APP_BUNDLEID;
//    
//    NSString *time = [NSString stringWithFormat:@"%ld",timeInt];
//    NSString *md5VersionName = [versionName md5];
//    NSString *md5imei = [imei md5];
//    
//    NSString *tokenq = [NSString stringWithFormat:@"%@%@%@itel2105@@$*",md5VersionName,md5imei,time];
//    
//    NSString *tokens = [NSString stringWithFormat:@"%@",[tokenq md5]];
//    
//    NSString *value = [NSString stringWithFormat:@"itel_version/%@ version/%@ from/ios imei/%@ key/%@ time/%@ token/%@ mobile_model/iphone",versionName,version,imei,md5imei,time,tokens];
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                       serviceType:(NSString *)serviceType
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block{
    
    //域名拼接
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@",serviceType,aPath];
    
    //发起请求
    switch (NetworkMethod) {
        case Get:{
            [self GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                    block(responseObject,nil);
             
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                block(nil, error);
                [self showError:error];
            }];
            break;
        }
        case Post:{
            
            [self POST:urlString parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                 block(responseObject,nil);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                block(nil, error);
                [self showError:error];
            }];
            break;}
        case Put:{
            [self PUT:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self showError:error];
                block(nil, error);
            }];
            break;}
        case Delete:{
            [self DELETE:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self showError:error];
                block(nil, error);
            }];
        }
        default:
            break;
    }
}

- (void)uploadImageWithPath:(NSString *)aPath
                serviceType:(NSString *)serviceType
                 withParams:(NSDictionary*)params
                withImage:(UIImage *)image
                   andBlock:(void (^)(id data, NSError *error))block {
    //域名拼接
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@",serviceType,aPath];
    
    [self POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *filePath = [GeneralToolObject personalIconFilePath];
//        UIImage *fileImage = [UIImage imageWithContentsOfFile:filePath];
        NSData * data= UIImageJPEGRepresentation(image, 0.1);//UIImagePNGRepresentation(fileImage);
        [formData appendPartWithFileData:data name:@"photo" fileName:filePath mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"上传图片 = %@",responseObject);
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"上传图片 = %@",error);
        block(nil, error);
    }];


}

#pragma mark - 显示错误

-(id)handleResponse:(id)responseJSON{
    NSError *error = nil;
    //code为非0值时，表示有错
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
    if (resultCode.intValue != 0) {
        DLog(@"resultCode = %@",resultCode);
    }
    return error;
}

- (void)showError:(NSError *)error{
    [CustomMBHud customHudWindow:NetWorking_NoNetWork];

}

@end
