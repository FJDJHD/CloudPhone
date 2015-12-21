//
//  MainMineViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MainMineViewController.h"
#import "Global.h"
#import "PersonalViewController.h"
#import "UserModel.h"

#import "HelpAndFeedbackViewController.h"
#import "AboutCloudPhoneViewController.h"
#import "SettingViewController.h"
#import "TaskCenterViewController.h"
#import "FreeCallPhoneTimesViewController.h"

@interface MainMineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSNumber  *remainingTime;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSArray *iamgeArray;
@property (nonatomic, strong) NSMutableDictionary *testDic;

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray *infoArray;
@end

@implementation MainMineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _itemArray = @[@"免费通话时长",@"任务中心",@"关于云电话",@"帮助与反馈",@"设置"];
        _iamgeArray = @[@"mine_freetimes",@"mine_task",@"mine_aboutcloud",@"mine_helper",@"mine_setting"];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:UserNumber];
    
    _infoArray = [DBOperate queryData:T_personalInfo theColumn:@"phoneNum" theColumnValue:number withAll:NO];
    if (_infoArray.count > 0) {
        NSArray *temp = _infoArray[0];
        _user = [[UserModel alloc]init];
        _user.userNumber = [temp objectAtIndex:info_phoneNum];
        _user.userName = [temp objectAtIndex:info_name];
        _user.userIcon = [temp objectAtIndex:info_iconPath];
        _user.userBirthday = [temp objectAtIndex:info_birthday];
        _user.userGender = [temp objectAtIndex:info_sex];
        _user.userSignature = [temp objectAtIndex:info_signature];
        [_tableView reloadData];
        
    } else {
        [self requestPersonalInfo];
    }
   // [self requestPersonalCenter];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [ColorTool backgroundColor];
    }
    return _tableView;
}

#pragma mark - UITabvleViewDatasource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return _itemArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            UIImage *image = [UIImage imageNamed:@"pic_touxiang@2x.png"];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.layer.cornerRadius = image.size.height/2.0;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(15, 10, image.size.width, image.size.height);
            imageView.tag = 200;
            [cell addSubview:imageView];
            
            UILabel *userLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 15, 200, 30)];
            userLable.font = [UIFont systemFontOfSize:18];
            userLable.textAlignment = NSTextAlignmentLeft;
            userLable.textColor = [UIColor blackColor];
            userLable.tag = 201;
            [cell addSubview:userLable];
            
            UILabel *mobileLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10 , 45, 200, 30)];
            mobileLable.font = [UIFont systemFontOfSize:16];
            mobileLable.textAlignment = NSTextAlignmentLeft;
            mobileLable.textColor = [UIColor lightGrayColor];
            mobileLable.tag = 202;
            [cell addSubview:mobileLable];

        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    
    if (indexPath.section == 0) {
        UserModel *model = self.user;
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:200];
        UILabel *userLable = (UILabel *)[cell viewWithTag:201];
        UILabel *mobileLable = (UILabel *)[cell viewWithTag:202];
        //电话
        if (model.userNumber == nil || model.userNumber.length == 0 || [model.userNumber isEqualToString:@""]) {
            mobileLable.text = @"";
        } else {
            mobileLable.text = model.userNumber;
        }
        //昵称
        if (model.userName == nil || model.userName.length == 0 || [model.userName isEqualToString:@"" ]) {
            userLable.text = @"昵称";
        } else {
            userLable.text = model.userName;
        }
        //头像
        if (model.userIcon == nil || model.userIcon.length == 0 || [model.userIcon isEqualToString:@"/"]) {
            
        }else {
            if (_infoArray.count > 0) {
                
                UIImage *iconImage = [UIImage imageWithContentsOfFile:model.userIcon];
                if (iconImage) {
                    imageView.image = iconImage;
                } else {
                    imageView.image = [UIImage imageNamed:@"pic_touxiang@2x.png"];
                }
                
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"pic_touxiang@2x.png"]];
            }
        }

        
    } else {
        if(indexPath.row == 0){
           cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余123分钟"] ;
        }
        [cell.imageView setImage:[UIImage imageNamed:_iamgeArray[indexPath.row]]];
        cell.textLabel.text = _itemArray[indexPath.row];
    }
    return cell;

}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 20;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 0) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        PersonalViewController *personalViewController = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:personalViewController animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        FreeCallPhoneTimesViewController *freeVC = [FreeCallPhoneTimesViewController new];
        [self.navigationController pushViewController:freeVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        TaskCenterViewController *taskVC = [TaskCenterViewController new];
        [self.navigationController pushViewController:taskVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        AboutCloudPhoneViewController *aboutVC = [AboutCloudPhoneViewController new];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 3){
        HelpAndFeedbackViewController *helpVC = [HelpAndFeedbackViewController new];
        [self.navigationController pushViewController:helpVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 4){
        SettingViewController *setVC = [SettingViewController new];
        [self.navigationController pushViewController:setVC animated:YES];
        
    }
}


//- (void)requestPersonalCenter {
//
//    //用户中心首页
//    [[AirCloudNetAPIManager sharedManager] getUserCenterOfParams:nil WithBlock:^(id data, NSError *error) {
//        
//        if (!error) {
//            NSDictionary *dic = (NSDictionary *)data;
//            
//            if (dic) {
//                if ([[dic objectForKey:@"status"] integerValue] == 1) {
//                    DLog(@"成功------%@",[dic objectForKey:@"msg"]);
//                    
//                    NSDictionary *info = [dic objectForKey:@"data"];
//                    if (info) {
//                        _user = [[UserModel alloc]init];
//                        _user.userNumber = [info objectForKey:@"mobile"];
//                        _user.userName = [info objectForKey:@"nick_name"];
//                        _user.userIcon = [info objectForKey:@"photo"];
//                        [_tableView reloadData];
//                    }
//                    
//                } else {
//                    DLog(@"******%@",[dic objectForKey:@"msg"]);
//                }
//            }
//        }
//    }];
//}

- (void)requestPersonalInfo {
    NSDictionary *dic = @{@"us":@"us"};
    [[AirCloudNetAPIManager sharedManager] getUserCenterInfoOfParams:dic WithBlock:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                DLog(@"成功------%@",[dic objectForKey:@"msg"]);
                NSDictionary *info = [dic objectForKey:@"data"];
                if (info) {
                    
                    UserModel *model = [[UserModel alloc]init];
                    model.userNumber = [info objectForKey:@"mobile"];
                    model.userName = [info objectForKey:@"nick_name"];
                    model.userIcon = [info objectForKey:@"photo"];
                    model.userBirthday = [info objectForKey:@"birthday"];
                    model.userGender = [info objectForKey:@"gender"];
                    model.userSignature = [info objectForKey:@"signature"];
                    
                    self.user = model;
                    NSArray *infoArray = [NSArray arrayWithObjects:model.userNumber,model.userName,[GeneralToolObject personalIconFilePath],model.userGender,model.userBirthday,model.userSignature,nil];
                    [DBOperate insertDataWithnotAutoID:infoArray tableName:T_personalInfo];
                    
                    
                    [_tableView reloadData];
                }
                
                
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]]];
                
            }
        }
    }];
}

#pragma mark ---file read and write

//个人头像保存在沙盒
- (NSString *)personalIconFilePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"personalIcon.png"];
    return filePath;
}

//保存在plist文件中
- (NSString *)personalInfoFilePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"personalInfo.plist"];
    return filePath;
}

//cell下划线的距离
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}


@end
