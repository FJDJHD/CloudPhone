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

@property (nonatomic, copy) NSString *chatJIDStr;  //like 13113689077@clone.com

@property (nonatomic, strong) UIImage *chatPhoto; //头像

@property (nonatomic, strong) XMPPJID *chatJID;

@property (nonatomic, copy) NSString *chatName; //名字

@end
