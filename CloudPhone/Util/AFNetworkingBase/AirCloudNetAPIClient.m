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
@interface AirCloudNetAPIClient()<UIAlertViewDelegate>
@end
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
                
                if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                    NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                    if (dataDic) {
                        if ([dataDic objectForKey:@"is_login"]) {
                            if ([[dataDic objectForKey:@"is_login"] integerValue] == 0) {
                                //退出
                                [GeneralToolObject userLoginOut];
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你的帐号在另一台设备登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [alert show];
                            } 
                            
                        }else if ([dataDic objectForKey:@"is_update"]){
                            if ([[dataDic objectForKey:@"is_update"] integerValue] == 1) {
                                //版本更新
                                UIAlertView  *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"应用程序有新版本，请更新" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                alterView.tag = 1001;
                                [alterView show];
                            }
                        }else if ([dataDic objectForKey:@"is_mainiain"]){
                            if ([[dataDic objectForKey:@"is_mainiain"] integerValue] == 1) {
                                //系统维护中
                                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wating"]];
                                imageView.frame = [UIScreen mainScreen].bounds;
                                [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:imageView];
                                
                            }
                        }
                    }
                }
                block(responseObject, nil);
                
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
                 
                 if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                     NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                     if (dataDic) {
                         if ([dataDic objectForKey:@"is_login"]) {
                             if ([[dataDic objectForKey:@"is_login"] integerValue] == 0) {
                                 //退出
                                 [GeneralToolObject userLoginOut];
                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你的帐号在另一台设备登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                 [alert show];
                             }
                             
                         }else if ([dataDic objectForKey:@"is_update"]){
                             if ([[dataDic objectForKey:@"is_update"] integerValue] == 1) {
                                 //版本更新
                                 UIAlertView  *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"应用程序有新版本，请更新" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                 alterView.tag = 1001;
                                 [alterView show];
                            }
                        }else if ([dataDic objectForKey:@"is_mainiain"]){
                            if ([[dataDic objectForKey:@"is_mainiain"] integerValue] == 1) {
                                //系统维护中
                                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wating"]];
                                imageView.frame = [UIScreen mainScreen].bounds;
                                [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:imageView];
                            }
                        }
                     }
                 }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
       
        //更新版本
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-qu-bao/id890385562?mt=8"]];
        
        
//      [[AirCloudNetAPIManager sharedManager] getHelpCenterInfoOfParams:nil WithBlock:^(id data, NSError *error){
//            if (!error) {
//                NSDictionary *dic = (NSDictionary *)data;
//                if ([[dic objectForKey:@"status"] integerValue] == 1) {
//                    DLog(@"------%@",[dic objectForKey:@"msg"]);
//                    
//                } else {
//                    DLog(@"******%@",[dic objectForKey:@"msg"]);
//                    [CustomMBHud customHudWindow:@"数据请求失败"];
//                    
//                    
//                }
//            }
//            
//        }];


    }
}

@end
