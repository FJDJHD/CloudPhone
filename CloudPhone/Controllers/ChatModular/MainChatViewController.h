//
//  MainChatViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kFriend,
    kMessage
    
}FriendMessageType;

@interface MainChatViewController : UIViewController {

    
}

@property (nonatomic, assign) FriendMessageType selectType; //朋友还是消息列表



@end
