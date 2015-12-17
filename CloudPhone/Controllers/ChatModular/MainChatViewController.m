//
//  MainChatViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MainChatViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import <CoreData/CoreData.h>

#import "MessageViewController.h"
#import "FriendCell.h"
#import "ChatListCell.h"

typedef enum {
    kFriend,
    kMessage

}FriendMessageType;

@interface MainChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) FriendMessageType selectType; //朋友还是消息列表

@property (nonatomic, copy) NSArray *chatListArray;


@end

@implementation MainChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *titleSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"好友",@"消息",nil]];
    titleSegment.frame = CGRectMake(0, 0, 120, 30);
    titleSegment.tintColor = [UIColor brownColor];
    [titleSegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    titleSegment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = titleSegment;
    
    //导航栏右按钮
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = CGRectMake(0, 0, 44, 44);
    addressButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addressButton setTitle:@"添加" forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //添加列表试图
    [self.view addSubview:self.tableView];
    
    [self.fetchedResultsController performFetch:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITabvleViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectType == kFriend) {
        //好友
        static NSString *ID = @"FriendCell";
        FriendCell *friCell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!friCell) {
            friCell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        [friCell cellForData:user];
        
        return friCell;
        
    } else {
        //消息
        static NSString *ID = @"ChatListCell";
        ChatListCell *chatCell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!chatCell) {
            chatCell = [[ChatListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
   
        return chatCell;
    
    }
    return nil;
   
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    MessageViewController *controller = [[MessageViewController alloc]init];
    controller.chatUser = user.jidStr;
    controller.chatJID = user.jid;
    controller.chatPhoto = user.photo;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        XMPPJID *jid = user.jid;
        [[self appDelegate].xmppRoster removeUser:jid];
    }
}

//结果调度器有一个代理方法，一旦上下文改变触发，也就是刚加了好友，或删除好友时会触发
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"上下文改变");
    [self.tableView reloadData];
}

//这里需要用到查询结果调度器(写完了结果调度器之后要切记在viewdidload页面首次加载中加上一句，否则不干活
- (NSFetchedResultsController *)fetchedResultsController{
    // 推荐写法，减少嵌套的层次
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    // 指定查询的实体
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    // 在线状态排序
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionNum" ascending:YES];
    // 显示的名称排序
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    // 添加排序
    request.sortDescriptors = @[sort1,sort2];
    // 添加谓词过滤器
    request.predicate = [NSPredicate predicateWithFormat:@"!(subscription CONTAINS 'none')"];
    // 添加上下文
    NSManagedObjectContext *ctx = [[GeneralToolObject appDelegate] managedObjectContext_roster];
    // 实例化结果控制器
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    // 设置他的代理
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - 从fmdb获取聊天消息列表
- (void)loadMessageDataFromFMDB {
    
    _chatListArray = [DBOperate queryData:T_chatMessage theColumn:nil theColumnValue:nil withAll:YES];
    
//    if (getArray.count > 0) {
//        for (NSArray *temp in getArray) {
//            NSString *jidStr = [temp objectAtIndex:message_id];
//            DLog(@"jidStr = %@",jidStr);
//        }
//    }
}


- (void)addressButtonClick {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"添加好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

}

//添加好友。。。。。
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *userNameField = [alertView textFieldAtIndex:0];
        NSString *desUser = [NSString stringWithFormat:@"%@%@",userNameField.text,XMPPSevser];
        
        // 如果已经是好友就不需要再次添加
        XMPPJID *jid = [XMPPJID jidWithString:desUser];
        
        BOOL contains = [[self appDelegate].xmppRosterStorage userExistsWithJID:jid xmppStream:[self appDelegate].xmppStream];
        if (contains) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是好友，无需添加" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return;
        }
        [[self appDelegate].xmppRoster subscribePresenceToUser:jid];
    } else {
    
        DLog(@"取消");
    }
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//切换状态
- (void)segmentClick:(UISegmentedControl *)sender {

    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        self.selectType = kFriend;  //表示朋友列表
    
    } else {
        self.selectType = kMessage; //表示消息列表
        
        [self loadMessageDataFromFMDB];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
