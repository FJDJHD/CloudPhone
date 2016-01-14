//
//  FriendDetailViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/8.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "Global.h"
@interface FriendDetailViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *dialDetailTableView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *detLabel;
@property (nonatomic, strong) UIButton *dialDetailButton;
@property (nonatomic, strong)  UIButton *detailInfoButton;
@property (nonatomic, strong)  UIView *coverView;
@property (nonatomic, strong) UILabel *signayureLabel;
@end

@implementation FriendDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"好友详情";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //导航栏右按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 44, 44);
    editButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //头像
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    iconImageView.frame = CGRectMake(0, 0, MainWidth * 0.3,  MainWidth * 0.3);
    iconImageView.center = CGPointMake(MainWidth / 2.0, 10 + iconImageView.frame.size.height / 2.0);
    [self.view addSubview:iconImageView];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    nameLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(iconImageView.frame) + 5 + (nameLabel.frame.size.height) / 2.0);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = self.model.callerName;
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nameLabel = nameLabel;
    [self.view addSubview:nameLabel];
    
    UILabel *signayureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 25)];
    signayureLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(nameLabel.frame) + 5 + (signayureLabel.frame.size.height) / 2.0);
    signayureLabel.textAlignment = NSTextAlignmentLeft;
    signayureLabel.textColor = [UIColor blackColor];
    signayureLabel.text = @"";
    signayureLabel.font = [UIFont systemFontOfSize:16.0];
    self.signayureLabel = signayureLabel;
    [self.view addSubview:signayureLabel];
    
    
    UIView *buttonBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signayureLabel.frame) + 20, MainWidth, 44)];
    buttonBg.backgroundColor = [ColorTool backgroundColor];
    [self.view addSubview:buttonBg];
    
    
    UIButton *dialDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dialDetailButton.frame = CGRectMake(61, CGRectGetMaxY(self.signayureLabel.frame) + 20, (MainWidth - 61 * 2) / 2.0, 44);
    dialDetailButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [dialDetailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dialDetailButton setTitleColor:[UIColor colorWithHexString:@"#049ff1"] forState:UIControlStateSelected];
    [dialDetailButton setTitle:@"详情信息" forState:UIControlStateNormal];
    dialDetailButton.selected = YES;
    dialDetailButton.backgroundColor = [ColorTool navigationColor];
    dialDetailButton.layer.cornerRadius = 2.0;
    [dialDetailButton addTarget:self action:@selector(dialDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.dialDetailButton = dialDetailButton;
    [self.view addSubview:dialDetailButton];
    
    UIButton *detailInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailInfoButton.frame = CGRectMake(CGRectGetMaxX(dialDetailButton.frame), CGRectGetMaxY(self.signayureLabel.frame) + 20, (MainWidth - 61 * 2) / 2.0, 44);
    detailInfoButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [detailInfoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailInfoButton setTitleColor:[UIColor colorWithHexString:@"#049ff1"] forState:UIControlStateSelected];
    [detailInfoButton setTitle:@"通话详情" forState:UIControlStateNormal];
    detailInfoButton.selected = NO;
    [detailInfoButton addTarget:self action:@selector(detailInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.detailInfoButton = detailInfoButton;
    [self.view addSubview:detailInfoButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dialDetailButton.frame), MainWidth, 1.0)];
    line.backgroundColor =  [ColorTool navigationColor];
    [self.view addSubview:line];
    
    [self.view insertSubview:self.tableView belowSubview:buttonBg];
    [self.view insertSubview:self.dialDetailTableView belowSubview:buttonBg];
    
    //发消息
    CGRect rect = CGRectMake(15, MainHeight - 50, MainWidth - 15*2.0, 44);
    UIButton *sendInfoButton = [self getButtonWithString:@"发消息" rect:rect taget:self action:@selector(sendInfoButtonClick) ];
    [self.view addSubview:sendInfoButton];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, CGRectGetMaxY(self.dialDetailButton.frame) - 36, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 9001;
        _tableView.bounces = NO;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [ColorTool backgroundColor];
    }
    return _tableView;
}

- (UITableView *)dialDetailTableView {
    if (!_dialDetailTableView) {
        CGRect tableViewFrame = CGRectMake(0, CGRectGetMaxY(self.dialDetailButton.frame), MainWidth, SCREEN_HEIGHT);
        _dialDetailTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _dialDetailTableView.delegate = self;
        _dialDetailTableView.dataSource = self;
        _dialDetailTableView.tag = 9002;
        _dialDetailTableView.scrollEnabled = NO;
        _dialDetailTableView.allowsSelection = NO;
        _dialDetailTableView.backgroundColor = [ColorTool backgroundColor];
    }
    return _dialDetailTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 9002) {
        return 3;
    }else{
        return 20;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 9002) {
        static NSString *ID = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            if (indexPath.row == 0) {
                UIImage *image = [UIImage imageNamed:@"freephone"];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(25, 10, image.size.width, image.size.height);
                [cell addSubview:imageView];
                
                UILabel *freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imageView.frame) + 5   , 60, 20)];
                freeLabel.font = [UIFont systemFontOfSize:12];
                freeLabel.textAlignment = NSTextAlignmentLeft;
                freeLabel.textColor = [UIColor blackColor];
                freeLabel.text = @"免费通话";
                [cell addSubview:freeLabel];
                
                UILabel *mobileLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(freeLabel.frame) + 15, 10, 180, 20)];
                mobileLable.font = [UIFont systemFontOfSize:14];
                mobileLable.textAlignment = NSTextAlignmentLeft;
                mobileLable.textColor = [UIColor blackColor];
                mobileLable.text = self.model.callerNo;
                [cell addSubview:mobileLable];
                
                UILabel *mobileLocationLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(freeLabel.frame) + 15, CGRectGetMaxY(mobileLable.frame), 180, 20)];
                mobileLocationLable.font = [UIFont systemFontOfSize:14];
                mobileLocationLable.textAlignment = NSTextAlignmentLeft;
                mobileLocationLable.textColor = [UIColor blackColor];
                mobileLocationLable.text = @"手机（广东深圳移动）";
                [cell addSubview:mobileLocationLable];
                
                UIImage *msgImage = [UIImage imageNamed:@"sendmsg"];
                UIImageView *msgImageView = [[UIImageView alloc]initWithImage:msgImage];
                msgImageView.frame = CGRectMake(MainWidth - 25 - msgImage.size.width, 10, msgImage.size.width, msgImage.size.height);
                [cell addSubview:msgImageView];
                
                UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 40 - msgImage.size.width, CGRectGetMaxY(msgImageView.frame) + 5, 60, 20)];
                msgLabel.font = [UIFont systemFontOfSize:12];
                msgLabel.textAlignment = NSTextAlignmentCenter;
                msgLabel.textColor = [UIColor blackColor];
                msgLabel.text = @"发送短信";
                [cell addSubview:msgLabel];
            }else {
                UILabel *detLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 200, 60)];
                detLabel.font = [UIFont systemFontOfSize:16];
                detLabel.textAlignment = NSTextAlignmentLeft;
                detLabel.textColor = [UIColor blackColor];
                self.detLabel = detLabel;
                [cell addSubview:detLabel];
            }
            
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"简介";
            self.detLabel.text = @"简介";
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"店铺";
            self.detLabel.text = @"没蓝女装品牌专卖店";
        }
        return cell;
        
    }else{
        static NSString *ID = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.text = @"通话时刻";
            cell.detailTextLabel.text = @"通话时长";
        }
        
        return cell;
    }
}

//编辑按钮
- (void)editClick{
    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_NAV_BAR_HEIGHT + 120, MainWidth, MainHeight *0.45)];
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [coverView addSubview:view];
    
    //修改备注
    CGRect rect = CGRectMake(15, 20 + (44 + 10) * 0, MainWidth - 15*2.0, 44);
    UIButton *modifyButton = [self getButtonWithString:@"修改备注" rect:rect taget:self action:@selector(modifyButtonClick)];
    [view addSubview:modifyButton];
    //屏蔽此人
    rect = CGRectMake(15, 20 + (44 + 10) * 1, MainWidth - 15*2.0, 44);
    UIButton *forbidButton = [self getButtonWithString:@"屏蔽此人" rect:rect taget:self action:@selector(forbidButtonClick)];
    [view addSubview:forbidButton];
    //取消
    rect = CGRectMake(15, 20 + (44 + 10) * 2, MainWidth - 15*2.0, 44);
    UIButton *cancelButton = [self getButtonWithString:@"取消" rect:rect taget:self action:@selector(cancelButtonClick)];
    [view addSubview:cancelButton];
}

- (UIButton *)getButtonWithString:(NSString *)title rect:(CGRect)rect taget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [ColorTool navigationColor];
    button.layer.cornerRadius = 2.0;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}



//发消息
- (void)sendInfoButtonClick{
    
}

- (void)detailInfoButtonClick{
    self.detailInfoButton.selected = YES;
    self.dialDetailButton.selected = NO;
    self.tableView.hidden = YES;
    self.dialDetailTableView.hidden = NO;
    
    self.detailInfoButton.backgroundColor = [ColorTool navigationColor];
    self.dialDetailButton.backgroundColor = [ColorTool backgroundColor];
    
    
}

- (void)dialDetailButtonClick{
    self.detailInfoButton.selected = NO;
    self.dialDetailButton.selected = YES;
    self.tableView.hidden = NO;
    self.dialDetailTableView.hidden = YES;
    
    self.dialDetailButton.backgroundColor = [ColorTool navigationColor];
    self.detailInfoButton.backgroundColor = [ColorTool backgroundColor];
}

- (void)modifyButtonClick{
    
}

- (void)forbidButtonClick{
    
}

- (void)cancelButtonClick{
    [self.coverView removeFromSuperview];
}


#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
