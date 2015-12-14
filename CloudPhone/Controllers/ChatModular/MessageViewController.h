//
//  MessageViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface MessageViewController : UIViewController

@property (nonatomic, copy) NSString *chatUser;  //like 13113689077@clone.com

@property (nonatomic, strong) XMPPJID *chatJID;

@end