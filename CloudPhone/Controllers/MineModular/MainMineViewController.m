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
@interface MainMineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSNumber  *remainingTime;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) NSMutableDictionary *testDic;

@end

@implementation MainMineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _itemArray = @[@"免费通话时长",@"任务中心",@"关于云电话",@"帮助与反馈",@"设置"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    //图片路径
    NSString *iconPath = [self personalIconFilePath];
    UIImage *image = [UIImage imageNamed:@"mine_icon"];
    [UIImagePNGRepresentation(image) writeToFile:iconPath atomically:YES];

    //写入沙盒
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
    [infoDic setValue:iconPath forKey:@"personalIcon"];
    [infoDic setValue:@"王聪" forKey:@"personalName"];
    [infoDic setValue:@"13113689077" forKey:@"personalNumber"];
    BOOL result = [infoDic writeToFile:[self personalInfoFilePath] atomically:YES];
    if (result) {
        DLog(@"缓存成功");
    }
    
    [self initData];
}

- (void)initData {

    //先读取缓存
    NSString *cachePath = [self personalInfoFilePath];
    self.testDic = [[NSMutableDictionary alloc] initWithContentsOfFile:cachePath];
    [_tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    }
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    
    if (indexPath.section == 0) {
        if ([self.testDic objectForKey:@"personalIcon"]) {
            cell.imageView.image = [UIImage imageNamed:[self.testDic objectForKey:@"personalIcon"]];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"pic_touxiang@2x.png"];
        }
        cell.textLabel.text = [self.testDic objectForKey:@"personalName"];
        cell.detailTextLabel.text = [self.testDic objectForKey:@"personalNumber"];;
        
    } else {
        if(indexPath.row == 0){
           cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余%@分钟",self.remainingTime] ;
        }
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
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
