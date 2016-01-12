//
//  TaskCenterViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "TaskCenterViewController.h"
#import "Global.h"
#import "OpenShareHeader.h"
@interface TaskCenterViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)   UIView *shareBar;
@end

@implementation TaskCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"任务中心";
    [self.view addSubview:self.tableView];
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,140)];
    UIImage *image = [UIImage imageNamed:@"find_adv01"];
    headerView.contentMode = UIViewContentModeCenter;
    headerView.image = image;
    self.tableView.tableHeaderView = headerView;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if (indexPath.section == 1 && indexPath.row == 1) {
            UIView *shareBar= [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 120)];
            shareBar.backgroundColor = [UIColor whiteColor];
            self.shareBar = shareBar;
            [self setShareBar];
            [cell addSubview:shareBar];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.section == 0 ) {
    cell.textLabel.text = @"登录签到每次奖励5分钟";
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    } else  if (indexPath.section == 1 && indexPath.row == 0){
    cell.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    cell.textLabel.text = @"分享云电话，奖励30分钟";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(MainWidth - 60, 10, 40, 30)];
    label.textColor = [UIColor colorWithHexString:@"#2cceb7"];
    label.text = @"说明";
    cell.accessoryView = label;
    }
    return cell;
}

- (void)setShareBar{
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"mine_penyouquan",@"mine_qqspace",@"mine_qq",@"mine_weixin"];
    NSArray *nameArray = [NSArray array];
    nameArray = @[@"盆友圈",@"空间",@"QQ",@"微信"];
    NSArray *addTimesArray = [NSArray array];
    addTimesArray = @[@"+10分钟",@"+10分钟",@"+5分钟",@"+5分钟"];

    UIView *line= [[UIView alloc] initWithFrame:CGRectMake(15, 60, MainWidth - 2*15, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.shareBar addSubview:line];
    
    for (int i = 0; i < imageArray.count; i++) {
        int col = i % 2;
        int row = i / 2;
        CGFloat  btWidth = 40;
        CGFloat  btHeight = 40.0;
        CGFloat  btX = col ? MainWidth - 89 - btWidth : 34 - 15;
        CGFloat  btY = 10 + row * (btHeight + 20);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btX, btY, btWidth, btHeight);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBar addSubview:button];
        
        CGRect textLableFrame = CGRectMake(CGRectGetMaxX(button.frame) + 5, btY, 50, 25);
        UILabel *textLabel = [[UILabel alloc]initWithFrame:textLableFrame];
        textLabel.font = [UIFont systemFontOfSize:16.0];
        textLabel.text = nameArray[i];
        textLabel.textColor = [UIColor blackColor];
        [self.shareBar addSubview:textLabel];
        
        CGRect detailTextLableFrame = CGRectMake(CGRectGetMaxX(button.frame) + 5,CGRectGetMaxY(textLabel.frame), 50, 10);
        UILabel *detailTextLable = [[UILabel alloc]initWithFrame:detailTextLableFrame];
        detailTextLable.text = addTimesArray[i];
        detailTextLable.font = [UIFont systemFontOfSize:10.0];
        detailTextLable.textColor = [UIColor lightGrayColor];
        [self.shareBar addSubview:detailTextLable];
        
    }
}

#pragma mark - UITableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 120;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // NSLog(@"%ld",(long)indexPath.row);
}


- (void)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title=@"iTel云电话，0话费0流量 ";
            msg.extInfo = @"注册云电话赠送100分钟通话时长，免费拨打国内电话。";
            msg.link=@"http://www.baidu.com/";//分享到朋友圈以后，微信就不会调用app了，跟news类型分享到朋友圈一样。
            msg.image=[UIImage imageNamed:@"itel_logo"];
            msg.thumbnail=[UIImage imageNamed:@"itel_logo"];
            msg.multimediaType=OSMultimediaTypeApp;
            
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                DLog(@"微信分享到朋友圈成功：\n%@",message);
            } Fail:^(OSMessage *message, NSError *error) {
                DLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
            }];
        }
            break;
            
        case 1:{
            OSMessage *msg=[[OSMessage alloc] init];
            msg.title=[NSString stringWithFormat:@"iTel云电话，0话费0流量"];
            msg.image=[UIImage imageNamed:@"itel_logo"];
            msg.thumbnail=[UIImage imageNamed:@"itel_logo"];
            msg.desc=[NSString stringWithFormat:@"注册云电话赠送100分钟通话时长，免费拨打国内电话"];
           // msg.link=@"http://sports.qq.com/a/20120510/000650.htm";


            [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                DLog(@"分享到QQ空间成功:%@",msg);
            } Fail:^(OSMessage *message, NSError *error) {
                DLog(@"分享到QQ空间失败:%@\n%@",msg,error);
            }];

        }
            break;
            
        case 2:{
            OSMessage *msg=[[OSMessage alloc] init];
            msg.title=[NSString stringWithFormat:@"iTel云电话，0话费0流量"];
            msg.image=[UIImage imageNamed:@"itel_logo"];
            msg.thumbnail=[UIImage imageNamed:@"itel_logo"];
            msg.desc=[NSString stringWithFormat:@"注册云电话赠送100分钟通话时长，免费拨打国内电话"];
           // msg.link=@"http://sports.qq.com/a/20120510/000650.htm";

            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                DLog(@"分享到QQ好友成功:%@",msg);
            } Fail:^(OSMessage *message, NSError *error) {
                DLog(@"分享到QQ好友失败:%@\n%@",msg,error);
            }];
        }
            break;
            
        case 3:{
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title=@"iTel云电话，0话费0流量";
            msg.desc=@"注册云电话赠送100分钟通话时长，免费拨打国内电话。";
            msg.link=@"http://www.baidu.com/";//分享到朋友圈以后，微信就不会调用app了，跟news类型分享到朋友圈一样。
            msg.image=[UIImage imageNamed:@"itel_logo"];
            msg.thumbnail=[UIImage imageNamed:@"itel_logo"];
            msg.multimediaType=OSMultimediaTypeApp;
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
               DLog(@"微信分享到会话成功：\n%@",message);
            } Fail:^(OSMessage *message, NSError *error) {
               DLog(@"微信分享到会话失败：\n%@\n%@",error,message);
            }];

        }
            break;            
        default:
            break;
    }
    
}


- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
