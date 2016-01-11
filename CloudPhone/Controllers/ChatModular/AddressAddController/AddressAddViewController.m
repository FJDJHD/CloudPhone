//
//  AddressAddViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/17.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "AddressAddViewController.h"
#import "Global.h"
#import "AddressObject.h"
#import "PersonModel.h"
#import <MessageUI/MessageUI.h>
#import "ItelFriendModel.h"
#import "JSONKit.h"
#import "AddFriendModel.h"
#import "AddressIconButton.h"
#import "ChatSendHelper.h"

@interface AddressAddViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listContentArray;

@property (nonatomic, strong) NSMutableArray *numberArray;

@property (nonatomic, strong) NSMutableArray *addArray;

@property (nonatomic, strong) NSMutableArray *friendArray;  //itel好友

@property (nonatomic, strong) NSMutableArray *invateArray;  //注册过的

@property (nonatomic, strong) NSMutableArray *addressArray; //剩下通讯录的

@property (nonatomic, strong) MBProgressHUD *HUD;


@end

@implementation AddressAddViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addFriendNotification)
                                                     name:FriendAdding object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.title = @"新的好友";
    
    _addArray = [[NSMutableArray alloc]initWithCapacity:0];
    _numberArray = [[NSMutableArray alloc]initWithCapacity:0];
    _friendArray = [[NSMutableArray alloc]initWithCapacity:0];
    _invateArray = [[NSMutableArray alloc]initWithCapacity:0];
    _addressArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //请求添加好友的
    [self loadFriendFromFMDB];
    
    [self.view addSubview:self.tableView];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"dismiss" forKey:XMPPAddFriend];
    [defaults synchronize];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, CGFLOAT_MIN)];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)loadFriendFromFMDB {
    [_addArray removeAllObjects];
    NSArray *array = [DBOperate queryData:T_addFriend theColumn:nil theColumnValue:nil withAll:YES];
    if (array.count > 0) {
        for (NSArray *temp in array) {
            AddFriendModel *model = [[AddFriendModel alloc]init];
            model.jidStr = [temp objectAtIndex:add_jidStr];
            model.status = [temp objectAtIndex:add_isAgree];
            [_addArray addObject:model];
        }
    }
}

#pragma mark - UITabvleViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _addArray.count + 1;
    } else if (section == 1) {
        //itel 好友
        return _friendArray.count;
    } else if (section == 2) {
        //注册 itel
        return _invateArray.count;
    } else {
        //通讯录
        return _addressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.detailTextLabel.textColor = RGB(102, 102, 102);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        
        AddressIconButton *button = [AddressIconButton buttonWithTitle:@""];
        button.tag = 550;
        [cell addSubview:button];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + 10, CGRectGetMinY(button.frame) + 2, 150, 20)];
        title.tag = 551;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:15.0];
        [cell addSubview:title];
        
        UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + 10, CGRectGetMaxY(title.frame) + 2, 150, 20)];
        subtitle.tag = 552;
        subtitle.textColor = RGB(102, 102, 102);
        subtitle.font = [UIFont systemFontOfSize:13.0];
        [cell addSubview:subtitle];
        
    }
    
    //    cell.imageView.image = [UIImage imageNamed:@"mine_icon"];
    
    cell.accessoryView = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *textcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"text"];
            //            textcell.imageView.image = [UIImage imageNamed:@"mine_icon"];
            
            AddressIconButton *button = [AddressIconButton buttonWithTitle:@"＋"];
            button.tag = 580;
            [textcell addSubview:button];
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, MainWidth - 80, 60)];
            textField.placeholder = @"输入添加新的好友号码";
            textField.font = [UIFont systemFontOfSize:17.0];
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [textcell addSubview:textField];
            return textcell;
            
        } else {
            if (_addArray.count > 0) {
                AddFriendModel *model = [_addArray objectAtIndex:indexPath.row - 1];
                NSArray *array = [model.jidStr componentsSeparatedByString:XMPPSevser]; //从字符A中分隔成2个元素的数组
                UILabel *titleLab = (UILabel *)[cell viewWithTag:551];
                UILabel *subtitleLab = (UILabel *)[cell viewWithTag:552];
                titleLab.text = array[0] ? array[0] : @"";
                subtitleLab.text = @"请求添加好友";
                
                AddressIconButton *button = [cell viewWithTag:550];
                if (titleLab.text.length > 0) {
                    [button setTitle:[titleLab.text substringToIndex:1] forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"" forState:UIControlStateNormal];
                }
                
                if ([model.status isEqualToString:@"unagree"]) {
                    cell.accessoryView = [self statusButtonWithTitle:@"同意"];
                } else {
                    cell.accessoryView = [self statusButtonWithTitle:@"已添加"];
                }
                
                
            }
        }
        
    } else if (indexPath.section == 1) {
        //itel 好友 (好友)
        if (_friendArray.count > 0) {
            ItelFriendModel *model = [_friendArray objectAtIndex:indexPath.row];
            
            UILabel *titleLab = (UILabel *)[cell viewWithTag:551];
            UILabel *subtitleLab = (UILabel *)[cell viewWithTag:552];
            titleLab.text = model.userName;
            subtitleLab.text = model.mobile;
            
            AddressIconButton *button = [cell viewWithTag:550];
            if (model.userName.length > 0) {
                [button setTitle:[model.userName substringToIndex:1] forState:UIControlStateNormal];
            } else {
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_addressItelFlag"]];
            
            
        }
        
    } else if (indexPath.section == 2) {
        //注册itel （添加好友）
        if (_invateArray.count > 0) {
            ItelFriendModel *model = [_invateArray objectAtIndex:indexPath.row];
            UILabel *titleLab = (UILabel *)[cell viewWithTag:551];
            UILabel *subtitleLab = (UILabel *)[cell viewWithTag:552];
            titleLab.text = model.userName;
            subtitleLab.text = model.mobile;
            
            AddressIconButton *button = [cell viewWithTag:550];
            if (model.userName.length > 0) {
                [button setTitle:[model.userName substringToIndex:1] forState:UIControlStateNormal];
            } else {
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            
            cell.accessoryView = [self statusButtonWithTitle:@"加为好友"];
            
            
        }
        
    } else {
        //通讯录 （邀请）
        if (_addressArray.count > 0) {
            ItelFriendModel *model = [_addressArray objectAtIndex:indexPath.row];
            
            UILabel *titleLab = (UILabel *)[cell viewWithTag:551];
            UILabel *subtitleLab = (UILabel *)[cell viewWithTag:552];
            titleLab.text = model.userName;
            subtitleLab.text = model.mobile;
            
            AddressIconButton *button = [cell viewWithTag:550];
            if (model.userName.length > 0) {
                [button setTitle:[model.userName substringToIndex:1] forState:UIControlStateNormal];
            } else {
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            
            
            cell.accessoryView = [self statusButtonWithTitle:@"邀请"];
            
        }
    }
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else if (section == 1) {
        if (_friendArray.count > 0) {
            return 30.0;
        }
        return CGFLOAT_MIN;
    } else if (section == 2) {
        if (_invateArray.count > 0) {
            return 30.0;
        }
        return CGFLOAT_MIN;
    }  else {
        if (_addressArray.count > 0) {
            return 30.0;
        }
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        //itel 好友 (好友)
        if (_friendArray.count > 0) {
            NSString *str = [NSString stringWithFormat:@"itel好友(%lu)",(unsigned long)_friendArray.count];
            return [self sectionHeaderViewWithTitle:str];
        }
        
    } else if (section == 2) {
        //注册itel （添加好友）
        if (_invateArray.count > 0) {
            NSString *str = [NSString stringWithFormat:@"添加成itel好友(%lu)",(unsigned long)_invateArray.count];
            return [self sectionHeaderViewWithTitle:str];
        }
        
    } else {
        //通讯录 （邀请）
        if (_addressArray.count > 0) {
            NSString *str = [NSString stringWithFormat:@"邀请注册云电话(%lu)",(unsigned long)_addressArray.count];
            return [self sectionHeaderViewWithTitle:str];
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //添加好哟
        if (indexPath.row == 0) {
            
        } else {
            //同意与否
            if ([[self appDelegate].xmppStream isConnected]) {
                AddFriendModel *model = [_addArray objectAtIndex:indexPath.row -1];
                if ([model.status isEqualToString:@"unagree"]) {
                    XMPPJID *jid = [XMPPJID jidWithString:model.jidStr];
                    [[self appDelegate].xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
                    
                    [DBOperate updateData:T_addFriend tableColumn:@"isAgree" columnValue:@"agree" conditionColumn:@"jidStr" conditionColumnValue:model.jidStr];
                    [self loadFriendFromFMDB];
                    [_tableView reloadData];
                }
            }
        }
        
    }else if (indexPath.section == 1) {
        //itel 好友 (好友)
        
    } else if (indexPath.section == 2) {
        //注册itel （添加好友）
        if (_invateArray.count > 0) {
            if ([[self appDelegate].xmppStream isConnected]) {
                [CustomMBHud customHudWindow:@"等待对方同意"];
                ItelFriendModel *model = [_invateArray objectAtIndex:indexPath.row];
                NSString *jidStr = [NSString stringWithFormat:@"%@%@",model.mobile,XMPPSevser];
                
                XMPPJID *jid = [XMPPJID jidWithString:jidStr];
                [[self appDelegate].xmppRoster subscribePresenceToUser:jid];
            }
        }
        
    } else {
        //通讯录 （邀请）
        if (_addressArray.count > 0) {
            ItelFriendModel *model = [_addressArray objectAtIndex:indexPath.row];
            //发送系统信息
            [self showMessageView:[NSArray arrayWithObjects:model.mobile, nil]  body:MessageItel];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - ios8方法 －－－－－－－－－－－－－－－－
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        
        //先自己删除了拒绝的人
        AddFriendModel *model = [_addArray objectAtIndex:indexPath.row - 1];
        if ([model.status isEqualToString:@"unread"]) {
            XMPPJID *jid = [XMPPJID jidWithString:model.jidStr];
            [[self appDelegate].xmppRoster removeUser:jid];
            [[self appDelegate].xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
        }
        [DBOperate deleteData:T_addFriend tableColumn:@"jidStr" columnValue:model.jidStr];
        [self loadFriendFromFMDB];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    return @[deleteRowAction];
}

#pragma mark - UITextFelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"sure = %@",textField.text);
    NSString *desUser = [NSString stringWithFormat:@"%@%@",textField.text,XMPPSevser];
    
    // 如果已经是好友就不需要再次添加
    XMPPJID *jid = [XMPPJID jidWithString:desUser];
    
    BOOL contains = [[self appDelegate].xmppRosterStorage userExistsWithJID:jid xmppStream:[self appDelegate].xmppStream];
    if (contains) {
        DLog(@"已是好友");
        [CustomMBHud customHudWindow:@"已是好友"];
        return YES;
    }
    
    if ([[[self appDelegate] xmppStream] isConnected]) {
        if (textField.text.length > 0) {
            [[self appDelegate].xmppRoster subscribePresenceToUser:jid];
            [CustomMBHud customHudWindow:@"等待对方同意"];
        }
    }
    
    [self.view endEditing:YES];
    return YES;
}


- (UIView *)sectionHeaderViewWithTitle:(NSString *)title {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 30)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 200, 30)];
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.textColor = RGB(102, 102, 102);
    lable.text = title;
    [view addSubview:lable];
    return view;
}

- (UIButton *)statusButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    button.frame = CGRectMake(0,0, 53, 30);
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.5;
    if ([title isEqualToString:@"加为好友"]) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    } else {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    }
    button.layer.borderColor = [UIColor colorWithHexString:@"#049ff1"].CGColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#049ff1"] forState:UIControlStateNormal];
    
    return button;
}

#pragma mark AlertDelegate
//添加好友。。。。。
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *userNameField = [alertView textFieldAtIndex:0];
        NSString *desUser = [NSString stringWithFormat:@"%@%@",userNameField.text,XMPPSevser];
        
        // 如果已经是好友就不需要再次添加
        XMPPJID *jid = [XMPPJID jidWithString:desUser];
        
        BOOL contains = [[self appDelegate].xmppRosterStorage userExistsWithJID:jid xmppStream:[self appDelegate].xmppStream];
        if (contains) {
            DLog(@"");
            return;
        }
        [[self appDelegate].xmppRoster subscribePresenceToUser:jid];
        
    } else {
        DLog(@"取消");
    }
}

#pragma mark - 网络请求

- (void)loadAddressData {
    
    self.listContentArray = [AddressObject shareInstance].allAddress;
    if (self.listContentArray.count > 0 && self.listContentArray) {
        for (NSInteger i = 0; i < self.listContentArray.count; i ++) {
            NSArray *array = [self.listContentArray objectAtIndex:i];
            for (PersonModel *model in array) {
                if (model.tel) {
                    NSString *name = model.phonename ? model.phonename : @"未备注";
                    NSDictionary *info = @{@"mobile":model.tel,@"username":name};
                    
                    [_numberArray addObject:info];
                }
            }
        }
    }
    
    //转化为json字符串
    if (_numberArray.count > 0 && _numberArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self AddHUD];
        });
        NSDictionary *dic = @{@"jsonMobile" : [GeneralToolObject dictionaryToJson:_numberArray]};
        [[AirCloudNetAPIManager sharedManager] postMailListOfParams:dic WithBlock:^(id data, NSError *error) {
            [self HUDHidden];
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if (dic) {
                    if ([[dic objectForKey:@"status"] integerValue] == 1) {
                        
                        NSArray *arr = [dic objectForKey:@"data"];
                        for (NSUInteger i = 0; i < arr.count; i++) {
                            NSDictionary *tempDic = [arr objectAtIndex:i];
                            //itel 好友
                            NSArray *friendArr = [tempDic objectForKey:@"buddy_mobile"];
                            //itel 但不是好友
                            NSArray *invateArr = [tempDic objectForKey:@"reg_mobile"];
                            //itel 没注册，通讯录
                            NSArray *addressArr = [tempDic objectForKey:@"arr_mobile"];
                            
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
                                    model.status = kInviteFriend;
                                    [_invateArray addObject:model];
                                }
                            }
                            
                            if (addressArr.count > 0) {
                                for (NSDictionary *adsDic in addressArr) {
                                    ItelFriendModel *model = [[ItelFriendModel alloc]init];
                                    model.userName = [adsDic objectForKey:@"username"];
                                    model.mobile = [adsDic objectForKey:@"mobile"];
                                    model.status = kNotFriend;
                                    [_addressArray addObject:model];
                                }
                            }
                        }
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

#pragma mark - CustomMedth

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)addFriendNotification {
    DLog(@"聊天界面，接受通知");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadFriendFromFMDB];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
    
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
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

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -didReceiveMemoryWarning and dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendAdding object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
