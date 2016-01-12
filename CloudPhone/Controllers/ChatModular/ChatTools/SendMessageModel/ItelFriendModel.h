//
//  ItelFriendModel.h
//  CloudPhone
//
//  Created by wangcong on 15/12/18.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ItelFriendStatus) {
    kAlreadFriend = 0,
    kInviteFriend,
    kNotFriend
};


@interface ItelFriendModel : NSObject

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) ItelFriendStatus status;

@property (nonatomic,assign) NSInteger sectionNumber;

+ (instancetype)modelForData:(NSDictionary *)dic;

@end
