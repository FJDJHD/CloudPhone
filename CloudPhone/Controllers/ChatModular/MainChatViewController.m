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
#import "AddressAddViewController.h"
#import "MessageViewController.h"
#import "FriendCell.h"
#import "ChatListCell.h"
#import "UIImage+ResizeImage.h"
#import "XMPPvCardTemp.h"
@interface MainChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSMutableArray *chatListArray;

@property (nonatomic, strong) UISearchDisplayController *searchControl;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic,  getter = isKCurrentController) BOOL kCurrentController; //默认不是当前的 no

@property (nonatomic, strong) UILabel *unreadAddLabel; //好友添加

@property (nonatomic, strong) NSIndexPath *tempIndexPath;


@end

@implementation MainChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(chatMessageNotification:)
                                                     name:ChatMessageComeing object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addFriendNotification)
                                                     name:FriendAdding object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *titleSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"消息",@"好友",nil]];
    titleSegment.frame = CGRectMake(0, 0, 120, 30);
    titleSegment.tintColor = [UIColor colorWithHexString:@"#049ff1"];
    [titleSegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    titleSegment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = titleSegment;
    
    //导航栏右按钮
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = CGRectMake(0, 0, 44, 44);
    [addressButton setImage:[UIImage imageNamed:@"chat_addfriend.png"] forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -12;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    

    //有好友添加的小红点
    _unreadAddLabel = [[UILabel alloc]init];
    _unreadAddLabel.frame = CGRectMake(addressButton.frame.size.width-20, 8, 10, 10);
    _unreadAddLabel.tag = 1400;
    _unreadAddLabel.layer.cornerRadius = 5;
    _unreadAddLabel.clipsToBounds = YES;
    _unreadAddLabel.textAlignment = NSTextAlignmentCenter;
    _unreadAddLabel.hidden = YES;
    _unreadAddLabel.backgroundColor = [UIColor redColor];
    _unreadAddLabel.font = [UIFont systemFontOfSize:9];
    [addressButton addSubview:_unreadAddLabel];
    
    _searchArray = [[NSMutableArray alloc]initWithCapacity:0];
    _chatListArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //添加列表试图
    [self.view addSubview:self.tableView];
    [self initWithSearchBar];
    
    [self.fetchedResultsController performFetch:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //查看下小红点
    [self tabbarUnreadMessageisShow];
    
    if (self.selectType == kMessage) {
        [self loadMessageDataFromFMDB];
        [self.tableView reloadData];
    }
    
    //添加好友小红点
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:XMPPAddFriend];
    if ([str isEqualToString:@"somebodyAdd"]) {
        _unreadAddLabel.hidden = NO;
    } else {
        _unreadAddLabel.hidden = YES;
    }
  
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.kCurrentController = YES; //一个标志
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    self.kCurrentController = NO; //一个标志

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

- (void)initWithSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.frame = CGRectMake(0.0f, 0.f, MainWidth, 44.0f);
    self.searchBar.placeholder=@"查找朋友";
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage imageWithColor:[ColorTool backgroundColor] size:self.searchBar.bounds.size];
    
    //设置为聊天列表头
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44.0f)];
    [self.tableView.tableHeaderView addSubview:self.searchBar];
    
    //搜索控制器
    self.searchControl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    self.searchControl.searchResultsDataSource = self;
    self.searchControl.searchResultsDelegate = self;
    self.searchControl.delegate = self;
    
}

#pragma mark - UITabvleViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView  == self.searchControl.searchResultsTableView) {
        //搜索栏
        return _searchArray.count;
    } else {
        
        if (self.selectType == kFriend) {
            return self.fetchedResultsController.fetchedObjects.count;
        } else {
            return _chatListArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchControl.searchResultsTableView) {
        //搜索
        static NSString *ID = @"SearchCell";
        FriendCell *searchCell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!searchCell) {
            searchCell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        if (_searchArray.count > 0) {
            XMPPUserCoreDataStorageObject *user = [_searchArray objectAtIndex:indexPath.row];
            [searchCell cellForData:user];
        }
        return searchCell;
        
    } else {
        
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
            [chatCell cellForData:_chatListArray index:indexPath];
            return chatCell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchControl.searchResultsTableView) {
        //搜索
        XMPPUserCoreDataStorageObject *user = [_searchArray objectAtIndex:indexPath.row];
        MessageViewController *controller = [[MessageViewController alloc]init];
        controller.chatJIDStr = user.jidStr;
        controller.chatJID = user.jid;
        controller.chatPhoto = user.photo;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
    
        if (self.selectType == kFriend) {
            //好友
            XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            MessageViewController *controller = [[MessageViewController alloc]init];
            controller.scrollType = ScrollToBottomType;
            controller.chatJIDStr = user.jidStr;
            controller.chatJID = user.jid;
            controller.chatPhoto = user.photo;
            
            //名字有优先级
            if (user.nickname.length > 0 && user.nickname) {
                controller.chatName = user.nickname;
                
            } else {
                XMPPvCardTemp *xmppvCardTemp = [[[GeneralToolObject appDelegate] xmppvCardTempModule] vCardTempForJID:user.jid shouldFetch:YES];
                if (xmppvCardTemp.nickname.length > 0 && xmppvCardTemp.nickname) {
                    controller.chatName = xmppvCardTemp.nickname;
                } else {
                    controller.chatName = user.jid.user;
                }
            }

            
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            //消息界面
            if (_chatListArray.count > 0) {
                NSArray *temp = [_chatListArray objectAtIndex:indexPath.row];
                MessageViewController *controller = [[MessageViewController alloc]init];
                controller.scrollType = ScrollToBottomType;
                controller.chatJIDStr = [temp objectAtIndex:message_id];
                
                XMPPJID *jid = [XMPPJID jidWithString:[temp objectAtIndex:message_id]];
                controller.chatJID = jid;
                
                //传个名字
                if (self.fetchedResultsController.fetchedObjects.count > 0) {
                    for (XMPPUserCoreDataStorageObject *user in self.fetchedResultsController.fetchedObjects) {
                        if ([user.jid isEqualToJID:jid]) {
                            if (user.nickname.length > 0 && user.nickname) {
                                controller.chatName = user.nickname;
                            } else {
                                XMPPvCardTemp *xmppvCardTemp = [[[GeneralToolObject appDelegate] xmppvCardTempModule] vCardTempForJID:user.jid shouldFetch:YES];
                                if (xmppvCardTemp.nickname.length > 0 && xmppvCardTemp.nickname) {
                                    controller.chatName = xmppvCardTemp.nickname;
                                } else {
                                    controller.chatName = user.jid.user;
                                }
                            }
                        }
                    }
                }
                [self.navigationController pushViewController:controller animated:YES];
            }
        }

    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (tableView == self.searchControl.searchResultsTableView) {
//        //搜索 这里还不需要做啥处理
//        return;
//    } else {
//        
//        if (self.selectType == kFriend) {
//            //好友
//            if (editingStyle == UITableViewCellEditingStyleDelete) {
//                XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//                XMPPJID *jid = user.jid;
//                [[self appDelegate] deleteFriend:user.jidStr];
////                [[self appDelegate].xmppRoster removeUser:jid];
//            }
//        } else {
//            //消息
//            if (editingStyle == UITableViewCellEditingStyleDelete) {
//                NSArray *temp = [_chatListArray objectAtIndex:indexPath.row];
//                [DBOperate deleteData:T_chatMessage tableColumn:@"jidStr" columnValue:[temp objectAtIndex:message_id]];
//                //删除后重新再更新下数据库
//                [self loadMessageDataFromFMDB];
//                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


#pragma mark - ios8方法 －－－－－－－－－－－－－－－－
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        if (self.selectType == kFriend) {
            //好友
            XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            XMPPJID *jid = user.jid;
            [[self appDelegate].xmppRoster removeUser:jid];
            //如果消息列表有也顺便删除了
            [DBOperate deleteData:T_chatMessage tableColumn:@"jidStr" columnValue:user.jidStr];
            //把好友添加的也删了
            [DBOperate deleteData:T_addFriend tableColumn:@"jidStr" columnValue:user.jidStr];
            //删除后重新再更新下数据库
            [self loadMessageDataFromFMDB];

        } else {
            //消息
            NSArray *temp = [_chatListArray objectAtIndex:indexPath.row];
            [DBOperate deleteData:T_chatMessage tableColumn:@"jidStr" columnValue:[temp objectAtIndex:message_id]];
            //删除后重新再更新下数据库
            [self loadMessageDataFromFMDB];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        //判断tabbar小红点出现
        [self tabbarUnreadMessageisShow];

    }];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了备注");
        self.tempIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改备注" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
        alert.tag = 700;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }];
    if (self.selectType == kFriend) {
        return @[deleteRowAction, moreRowAction];

    }  else {
        return @[deleteRowAction];
    }
    
}

//结果调度器有一个代理方法，一旦上下文改变触发，也就是刚加了好友，或删除好友时会触发
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    DLog(@"上下文改变");
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
    [self.chatListArray removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:UserNumber];
    
    NSArray *tempArr = [DBOperate queryData:T_chatMessage theColumn:nil theColumnValue:nil withAll:YES];
    
    if (tempArr.count > 0) {
        for (NSArray *temp in tempArr) {
            if ([number isEqualToString:[temp objectAtIndex:message_mineNumber]]) {
                [self.chatListArray addObject:temp];
            }
        }
    }
}


- (void)tabbarUnreadMessageisShow {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:XMPPAddFriend];
    
    BOOL reg = [self seekUnreadMessageFromFMDB];
    if (reg || [str isEqualToString:@"somebodyAdd"]) {
        [self appDelegate].unreadChatLabel.hidden = NO;
    } else {
        [self appDelegate].unreadChatLabel.hidden = YES;
    }
}

//查询是否有未读的message
- (BOOL)seekUnreadMessageFromFMDB {
    NSArray *arr = [DBOperate queryData:T_chatMessage theColumn:nil theColumnValue:nil withAll:YES];
    BOOL unreadFlag = NO;
    for (NSArray *temp in arr) {
        NSString *unreadTemp = [temp objectAtIndex:message_unreadMessage];
        NSInteger unreadInt = [unreadTemp integerValue];
        if (unreadInt > 0) {
            unreadFlag = YES;
        }
    }
    return unreadFlag;
}

//添加好友。。。。。
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *userNameField = [alertView textFieldAtIndex:0];
        if (alertView.tag == 700) {
            //修改备注
            if (userNameField.text.length > 0) {
                XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:self.tempIndexPath];
                [[[self appDelegate] xmppRoster] setNickname:userNameField.text forUser:user.jid];
            }
        }
    } else {
        DLog(@"取消");
    }
}

#pragma mark -- UISearchBarDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searchBar.showsCancelButton = YES;
    for (UIView *view in [self.searchBar.subviews[0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchArray removeAllObjects];
    
    if (self.searchBar.text.length > 0) {
        for (XMPPUserCoreDataStorageObject *user in self.fetchedResultsController.fetchedObjects) {
             NSArray *array = [user.displayName componentsSeparatedByString:XMPPSevser];
             NSString *friendName = user.nickname ? user.nickname :array[0];
            
            if ([friendName hasPrefix:self.searchBar.text]) {
                [_searchArray addObject:user];
            }
        }
        
        //这里在做一个补充查询
        if (_searchArray.count == 0) {
            for (XMPPUserCoreDataStorageObject *user in self.fetchedResultsController.fetchedObjects) {
                NSArray *array = [user.displayName componentsSeparatedByString:XMPPSevser];
                NSString *friendName = user.nickname ? user.nickname :array[0];
                
                if (_searchArray.count == 0) {
                    if ([friendName rangeOfString:self.searchBar.text].location !=NSNotFound) {
                        [_searchArray addObject:user];
                    }
                }
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (_searchArray.count == 0) {
        UITableView *tempTable = self.searchControl.searchResultsTableView;
        for (UIView *view in tempTable.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *lable = (UILabel *)view;
                lable.text = [NSString stringWithFormat:@"没有找到'%@'相关好友",self.searchBar.text];
            }
        }
    }
    
    return YES;
}

#pragma mark - 聊天消息通知
- (void)chatMessageNotification:(NSNotification *)sender {
    
    //这里是修改消息的名字的
    NSString *jidStr = sender.userInfo[@"jidStr"];
    NSArray *nameArray = [jidStr componentsSeparatedByString:XMPPSevser];
    NSString *realName = nameArray[0] ? nameArray[0] :@"好友";
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        for (XMPPUserCoreDataStorageObject *user in self.fetchedResultsController.fetchedObjects) {
            if ([user.jid isEqualToJID:[XMPPJID jidWithString:jidStr]]) {
                if (user.nickname.length > 0 && user.nickname) {
                    realName = user.nickname;
                } else {
                    XMPPvCardTemp *xmppvCardTemp = [[[GeneralToolObject appDelegate] xmppvCardTempModule] vCardTempForJID:user.jid shouldFetch:YES];
                    if (xmppvCardTemp.nickname.length > 0 && xmppvCardTemp.nickname) {
                        realName = xmppvCardTemp.nickname;
                    } else {
                        realName = user.jid.user;
                    }
                }
            }
        }
    }
    [DBOperate updateData:T_chatMessage tableColumn:@"name" columnValue:realName conditionColumn:@"jidStr" conditionColumnValue:jidStr];

    //出现红点的
    [self appDelegate].unreadChatLabel.hidden = NO;
    if (self.kCurrentController == YES && self.selectType == kMessage) {
        //在当前界面消息
        [self loadMessageDataFromFMDB];
        [self.tableView reloadData];
     }
}

#pragma mark - 添加好友
- (void)addFriendNotification {
    DLog(@"好友界面，接受通知");
    dispatch_async(dispatch_get_main_queue(), ^{
        _unreadAddLabel.hidden = NO;
    });
}


#pragma mark - CustomMedth

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
#pragma mark - 导航栏右按钮
- (void)addressButtonClick {
    AddressAddViewController *controller = [[AddressAddViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

//切换状态
- (void)segmentClick:(UISegmentedControl *)sender {

    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        self.selectType = kMessage;  //表示消息列表
        [self loadMessageDataFromFMDB];
        [self.tableView reloadData];
    
    } else {
        self.selectType = kFriend; //表示朋友列表
       
        [self.tableView reloadData];
    
    }
}

#pragma mark -didReceiveMemoryWarning and dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChatMessageComeing object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendAdding object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
