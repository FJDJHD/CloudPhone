//
//  WifiVoipComingViewController.h
//  CloudPhone
//
//  Created by wangcong on 16/1/6.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kIncomingCallStatus_accepting = 19,
    kIncomingCallStatus_incoming,
    kIncomingCallStatus_accepted,
    kIncomingCallStatus_over
}KIncomingCallStatus;

@interface WifiVoipComingViewController : UIViewController


@property(nonatomic, strong) NSString *contactVoip;

@property (nonatomic,assign) KIncomingCallStatus status;


- (id)initWithName:(NSString *)name andPhoneNO:(NSString *)phoneNO andCallID:(NSString*)callid;


@end
