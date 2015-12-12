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

@interface MainChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end

@implementation MainChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    //名称
    NSArray *array = [user.displayName componentsSeparatedByString:XMPPSevser]; //从字符A中分隔成2个元素的数组
    if (array.count > 0) {
        cell.textLabel.text = array[0] ? array[0] : @"";
    }
    
    //头像
    [self configurePhotoForCell:cell user:user];
    
    //是否在线
    if (user.section == 0) {
        cell.detailTextLabel.text = @"在线";
    } else {
        cell.detailTextLabel.text = @"离线";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    MessageViewController *controller = [[MessageViewController alloc]init];
    controller.chatUser = user.displayName;
    controller.chatJID = user.jid;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        XMPPJID *jid = user.jid;
        [[self appDelegate].xmppRoster removeUser:jid];
    }
}


- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user{
    if (user.photo != nil){
        cell.imageView.image = user.photo;
    }else{
        NSData *photoData = [[[GeneralToolObject appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        if (photoData != nil){
            cell.imageView.image = [UIImage imageWithData:photoData];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"mine_icon"];

        }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
