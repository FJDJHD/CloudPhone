//
//  AddressViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "AddressViewController.h"
#import "Global.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PersonModel.h"
#import "NSString+Util.h"
#import "UIImage+ResizeImage.h"
#import "FriendCell.h"
#import "AddressIconButton.h"
#import "AddressObject.h"
#import "DialingViewController.h"
#import "FriendDetailViewController.h"

#import "PersonModel.h"
#import <MessageUI/MessageUI.h>
#import "ItelFriendModel.h"
#import "JSONKit.h"
#import "AddFriendModel.h"
#import "AddressIconButton.h"
#import "CallRecordsModel.h"
#import "DilingButton.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,ABNewPersonViewControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,MFMessageComposeViewControllerDelegate>

//@property (nonatomic, strong) NSMutableArray *listContentArray;
//@property (nonatomic, strong) NSMutableArray *searchArray;
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchDisplayController *searchControl;

@property (nonatomic, strong) UITableView *tableView;


//索引
@property (nonatomic, strong) NSMutableArray *listTitleArray;

@property (nonatomic, strong) NSMutableArray *listContentArray;

@property (nonatomic, strong) NSMutableArray *allArray; //所有的人

@property (nonatomic, strong) NSMutableArray *friendArray; //好友



@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UISearchDisplayController *searchControl;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation AddressViewController{
  
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _listContentArray = [[NSMutableArray alloc]initWithCapacity:0];
        _listTitleArray = [[NSMutableArray alloc]initWithCapacity:0];
        _allArray = [[NSMutableArray alloc]initWithCapacity:0];
        _friendArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//[ColorTool backgroundColor];
    self.title = @"通讯录";
    
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //导航栏右按钮
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = CGRectMake(0, 0, 44, 44);
    [addressButton setImage:[UIImage imageNamed:@"phone_addMore"] forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //添加表视图
    [self.view addSubview:self.tableView];
    [self initWithSearchBar];
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, NULL), ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"未获得通讯录访问权限！");
            dispatch_async(dispatch_get_main_queue(), ^{
                [CustomMBHud customHudWindow:@"未获取访问通讯录权限"];
                
            });
        } else {
            [self loadAddressData];
        }
    });
   
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.rowHeight = 60;
        _tableView.sectionIndexColor = RGB(51, 51, 51);
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, CGFLOAT_MIN)];
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
    if (_friendArray.count > 0) {
        return [_listContentArray count] + 1;
    }
    return [_listContentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_friendArray.count > 0) {
        if (section == 0) {
            return _friendArray.count;
        } else {
            return [_listContentArray[section -1] count];
        }
    }
    return [_listContentArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.detailTextLabel.textColor = RGB(102, 102, 102);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        
        UIImage *image = [UIImage imageNamed:@"mine_icon.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (60 - 40)/2.0, 40, 40)];
        imageView.image = image;
        [cell addSubview:imageView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMinY(imageView.frame) + 2, 150, 20)];
        title.tag = 5551;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:15.0];
        [cell addSubview:title];
        
        UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(title.frame) + 2, 150, 20)];
        subtitle.tag = 5552;
        subtitle.textColor = RGB(102, 102, 102);
        subtitle.font = [UIFont systemFontOfSize:13.0];
        [cell addSubview:subtitle];
        
        CGRect arrowImageFrame = CGRectMake(MainWidth - 80, 0 , 60, 60);
        DilingButton  *arrowImgButton = [[DilingButton alloc]initWithFrame:arrowImageFrame];
        arrowImgButton.tag = 5553;
        [cell addSubview:arrowImgButton];
        [arrowImgButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_friendArray.count > 0) {
        if (indexPath.section == 0) {
            
            ItelFriendModel *model = (ItelFriendModel *)[_friendArray objectAtIndex:indexPath.row];
            
            UILabel *titleLab = (UILabel *)[cell viewWithTag:5551];
            UILabel *subtitleLab = (UILabel *)[cell viewWithTag:5552];
            DilingButton *arrowBtn = (DilingButton *)[cell viewWithTag:5553];
            
            arrowBtn.model = model;
            
            //名字
            titleLab.text = model.userName;
            
            //手机号
            subtitleLab.text = model.mobile;
            
            //状态
            if (model.status == kAlreadFriend) {
                [arrowBtn setImage:[UIImage imageNamed:@"phone_addressItelFlag"] forState:UIControlStateNormal];
            } else {
                [arrowBtn setImage:[UIImage imageNamed:@"phone_detail"] forState:UIControlStateNormal];
            }

            
        } else {
            
            NSArray *sectionArr=[_listContentArray objectAtIndex:indexPath.section - 1];
            ItelFriendModel *model = (ItelFriendModel *)[sectionArr objectAtIndex:indexPath.row];
            
            UILabel *titleLab = (UILabel *)[cell viewWithTag:5551];
            UILabel *subtitleLab = (UILabel *)[cell viewWithTag:5552];
            DilingButton *arrowBtn = (DilingButton *)[cell viewWithTag:5553];
            
            arrowBtn.model = model;
            
            //名字
            titleLab.text = model.userName;
            
            //手机号
            subtitleLab.text = model.mobile;
            
            //状态
            if (model.status == kAlreadFriend) {
                [arrowBtn setImage:[UIImage imageNamed:@"phone_addressItelFlag"] forState:UIControlStateNormal];
            } else {
                [arrowBtn setImage:[UIImage imageNamed:@"phone_detail"] forState:UIControlStateNormal];
            }

        
        }
        
        
    
    } else {
    
        NSArray *sectionArr=[_listContentArray objectAtIndex:indexPath.section];
        ItelFriendModel *model = (ItelFriendModel *)[sectionArr objectAtIndex:indexPath.row];
        
        UILabel *titleLab = (UILabel *)[cell viewWithTag:5551];
        UILabel *subtitleLab = (UILabel *)[cell viewWithTag:5552];
        DilingButton *arrowBtn = (DilingButton *)[cell viewWithTag:5553];
        
        arrowBtn.model = model;
        
        //名字
        titleLab.text = model.userName;
        
        //手机号
        subtitleLab.text = model.mobile;
        
        //状态
        if (model.status == kAlreadFriend) {
            [arrowBtn setImage:[UIImage imageNamed:@"phone_addressItelFlag"] forState:UIControlStateNormal];
        } else {
            [arrowBtn setImage:[UIImage imageNamed:@"phone_detail"] forState:UIControlStateNormal];
        }

    }
    
    return cell;
}

- (void)arrowButtonClick:(UIButton *)sender{
    DilingButton *button = (DilingButton *)sender;
    NSLog(@"number = %@",button.model.mobile);
    
    FriendDetailViewController *friDetailVC = [FriendDetailViewController new];
    CallRecordsModel *model = [[CallRecordsModel alloc] init];
    model.callerNo = button.model.mobile;
    model.callerName = button.model.userName;
    friDetailVC.model = model;
    [self.navigationController pushViewController:friDetailVC animated:YES];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSArray *sectionArr=[_listContentArray objectAtIndex:indexPath.section];
//    ItelFriendModel *model = (ItelFriendModel *)[sectionArr objectAtIndex:indexPath.row];
//    
//    DialingViewController *dialingVC = [[DialingViewController alloc] initWithCallerName:model.userName andCallerNo:model.mobile andVoipNo:@" "];
//    [self presentViewController:dialingVC animated:YES completion:nil];
}

//开启右侧索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.listTitleArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_friendArray.count > 0) {
        if (section == 0) {
            return nil;
        } else {
        
            if (self.listTitleArray && self.listTitleArray.count > 0) {
                UIView *contentView = [[UIView alloc] init];
                contentView.backgroundColor = RGB(240, 240, 240);
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
                label.backgroundColor = [UIColor clearColor];
                NSString *sectionStr = self.listTitleArray[section - 1];
                [label setText:sectionStr];
                [contentView addSubview:label];
                return contentView;
            } else {
                return nil;
            }

        }
        
    } else {
    
        if (self.listTitleArray && self.listTitleArray.count > 0) {
            UIView *contentView = [[UIView alloc] init];
            contentView.backgroundColor = RGB(240, 240, 240);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
            label.backgroundColor = [UIColor clearColor];
            NSString *sectionStr = self.listTitleArray[section];
            [label setText:sectionStr];
            [contentView addSubview:label];
            return contentView;
        } else {
            return nil;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *key = nil;
    if (index < self.listTitleArray.count) {
        key = [self.listTitleArray objectAtIndex:index];
        NSInteger desIndex = index;
        if (_friendArray.count > 0) {
            ++desIndex;
        }
        DLog(@"key = %@ ----%@",key,@(desIndex));

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:desIndex];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return index;
    
}


#pragma mark -

- (UIView *)sectionHeaderViewWithTitle:(NSString *)ti {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 30)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 200, 30)];
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.textColor = RGB(102, 102, 102);
    lable.text = ti;
    [view addSubview:lable];
    return view;
}

#pragma mark - 网络请求

- (void)loadAddressData {
    
    NSMutableArray *number = [NSMutableArray array];
    NSMutableArray *adressArray = [AddressObject shareInstance].allAddress;
    if (adressArray.count > 0) {
        for (NSInteger i = 0; i < adressArray.count; i ++) {
            NSArray *array = [adressArray objectAtIndex:i];
            for (PersonModel *model in array) {
                if (model.tel) {
                    NSString *name = model.phonename ? model.phonename : @"未备注";
                    NSDictionary *info = @{@"mobile":model.tel,@"username":name};
                    
                    [number addObject:info];
                }
            }
        }
    }
    
    //转化为json字符串
    if (number.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self AddHUD];
        });
        NSDictionary *dic = @{@"jsonMobile" : [GeneralToolObject dictionaryToJson:number]};
        [[AirCloudNetAPIManager sharedManager] postMailListOfParams:dic WithBlock:^(id data, NSError *error) {
            [self HUDHidden];
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if (dic) {
                    if ([[dic objectForKey:@"status"] integerValue] == 1) {
                        
                        NSArray *arr = [dic objectForKey:@"data"];
                        NSArray *friendArr = [NSArray array];
                        NSArray *invateArr = [NSArray array];
                        NSArray *addressArr = [NSArray array];
                        for (NSUInteger i = 0; i < arr.count; i++) {
                            NSDictionary *tempDic = [arr objectAtIndex:i];
                            //itel 好友
                            friendArr = [tempDic objectForKey:@"buddy_mobile"];
                            //itel 但不是好友
                            invateArr = [tempDic objectForKey:@"reg_mobile"];
                            //itel 没注册，通讯录
                            addressArr = [tempDic objectForKey:@"arr_mobile"];
                        }
                        
                        //这里只分两种
                        if (friendArr.count > 0) {
                            for (NSDictionary *friDic in friendArr) {
                                ItelFriendModel *model = [[ItelFriendModel alloc]init];
                                model.userName = [friDic objectForKey:@"username"];
                                model.mobile = [friDic objectForKey:@"mobile"];
                                model.status = kAlreadFriend;
                                [_friendArray addObject:model];
                            }
                        }
                        
                        if (invateArr.count > 0) {
                            for (NSDictionary *invDic in invateArr) {
                                ItelFriendModel *model = [[ItelFriendModel alloc]init];
                                model.userName = [invDic objectForKey:@"username"];
                                model.mobile = [invDic objectForKey:@"mobile"];
                                model.status = kNotFriend;
                                [_allArray addObject:model];
                            }
                        }
                        
                        if (addressArr.count > 0) {
                            for (NSDictionary *adsDic in addressArr) {
                                ItelFriendModel *model = [[ItelFriendModel alloc]init];
                                model.userName = [adsDic objectForKey:@"username"];
                                model.mobile = [adsDic objectForKey:@"mobile"];
                                model.status = kNotFriend;
                                [_allArray addObject:model];
                            }
                        }
                    
                    //排序
                    [self sortForAdressFirstLitter];
                    [_tableView reloadData];

                    
                    }else {
                        [CustomMBHud customHudWindow:@"请求失败"];
                    }
                }
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
            }
        }];
    }
}

- (void)sortForAdressFirstLitter {

    NSMutableArray *sectionTitleArray = [NSMutableArray array];
    //对数组排序，按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    [sectionTitleArray addObjectsFromArray:[theCollation sectionTitles]];
    
    for (ItelFriendModel *model in _allArray) {
        if (model.userName != nil) {
            NSInteger sect = [theCollation sectionForObject:model collationStringSelector:@selector(userName)];
            model.sectionNumber = sect;

        }
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count]; //27
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    
    for (NSInteger i = 0; i <= highSection; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:0];
        [sectionArrays addObject:sectionArray];
    }
    
    //把对应的名字放入这个27个数组中,将每个人按name分到某个section下
    for (ItelFriendModel *model in _allArray) {
        [[sectionArrays objectAtIndex:model.sectionNumber] addObject:model];
    }

    for (NSMutableArray *temp in sectionArrays) {
        ItelFriendModel *model = (ItelFriendModel *)temp.firstObject;
        if (model.userName == nil || [model.userName isEqualToString:@""]) {
            continue;
        }
        if (model.userName != nil) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:temp collationStringSelector:@selector(userName)];
            [_listContentArray addObject:sortedSection];
        }
    }
    
    //继续分类
    if (_listContentArray.count > 0) {
        //取数据排序
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        [_listTitleArray addObjectsFromArray:[collation sectionTitles]];
        NSMutableArray *existTitles = [NSMutableArray array];
        
        for (NSInteger i = 0; i < _listContentArray.count; i ++) {
            
            ItelFriendModel *model = _listContentArray[i][0];
            
            for (NSInteger j = 0; j < _listTitleArray.count; j ++) {
                
                if (model.sectionNumber == j) {

                    [existTitles addObject:_listTitleArray[j]];
                }
            }
        }
        [self.listTitleArray removeAllObjects];
        self.listTitleArray = existTitles;
    }
}



#pragma mark - MBProgressHUD Show or Hidden
- (void)AddHUD {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"请稍后...";
}

- (void)HUDHidden {
    if (_HUD) {
        _HUD.hidden = YES;
    }
}

#pragma mark - ABNewPersonViewControllerDelegate
//完成新增（点击取消和完成按钮时调用）,注意这里不用做实际的通讯录增加工作，此代理方法调用时已经完成新增，当保存成功的时候参数中得person会返回保存的记录，如果点击取消person为NULL
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    
    if (person) {
        DLog(@"%@保存信息成功",(__bridge NSString *)ABRecordCopyCompositeName(person));
    } else {
        
        DLog(@"取消");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


//导航栏右按钮
- (void)addressButtonClick {
    ABNewPersonViewController *newPersonController=[[ABNewPersonViewController alloc]init];
    //设置代理
    newPersonController.newPersonViewDelegate=self;
    //注意ABNewPersonViewController必须包装一层UINavigationController才能使用，否则不会出现取消和完成按钮，无法进行保存等操作
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:newPersonController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            DLog(@"信息发送成功");
            break;
            
        default:
            DLog(@"信息发送失败");
            break;
    }
}

- (void)showMessageView:(NSArray*)phones body:(NSString*)body {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示信息"
                                                    message:@"该设备不支持短信功能"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil,nil];
        [alert show];
    }
}


- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
