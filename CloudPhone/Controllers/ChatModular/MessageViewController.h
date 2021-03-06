//
//  MessageViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

typedef NS_ENUM(NSInteger, ScrollType) {
    ScrollStillType,
    ScrollToBottomType
};

@interface MessageViewController : UIViewController

@property (nonatomic, copy)   NSString *chatJIDStr;  //like 13113689077@clone.com

@property (nonatomic, strong) UIImage *chatPhoto; //头像

@property (nonatomic, strong) XMPPJID *chatJID;

@property (nonatomic, copy)   NSString *chatName; //名字

@property (nonatomic, assign) ScrollType scrollType;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
