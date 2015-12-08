//
//  MainChatViewController.h
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface MainChatViewController : UIViewController<NSFetchedResultsControllerDelegate> {

    NSFetchedResultsController *fetchedResultsController;
}


@end
