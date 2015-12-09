//
//  MessageChatViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"


@interface MessageChatViewController : UIViewController

@property (nonatomic, copy) NSString *chatUser;
@property (nonatomic, strong) XMPPJID *chatJID;

@end
