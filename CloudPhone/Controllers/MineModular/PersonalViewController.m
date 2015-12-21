//
//  PersonalViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonalViewController.h"
#import "Global.h"
#import "AppDelegate.h"
#import "UserModel.h"

#import "PersonSignatureViewController.h"
#import "ChatSendHelper.h"


@interface PersonalViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSDictionary *personalDic;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) UITextView *setSignatureView;
@property (nonatomic, strong) NSString *setBirthStr;


@property (nonatomic, strong) NSArray *infoArray;


@end


@implementation PersonalViewController
- (NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray = @[@"昵称",@"性别",@"生日",@"手机",@"个性签名"];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"账号";
    
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    [self.view addSubview:self.tableView];
   
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self HUDHidden];
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
    if (section == 0) {
        return 1;
    }else{
    return  self.itemArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if (indexPath.section == 0) {
            UIImage *image = [UIImage imageNamed:@"mine_icon"];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = CGRectMake(MainWidth - image.size.width - 30, (60 - image.size.height)/2.0, image.size.width, image.size.height);
            imageView.tag = 100;
            [cell addSubview:imageView];
        }
      
    }
    if (!(indexPath.section == 1 && indexPath.row == 3)) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    } else {
        cell.accessoryView = [[UIView alloc]init];
    }
    
    UserModel *model = self.user;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"头像";
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        //头像
        if (model.userIcon == nil || model.userIcon.length == 0 || [model.userIcon isEqualToString:@"/"] || [model.userIcon isEqual:[NSNull null]]) {
        } else {
            if (_infoArray.count > 0) {
                UIImage *iconImage = [UIImage imageWithContentsOfFile:model.userIcon];
                if (iconImage) {
                    imageView.image = iconImage;
                } else {
                    imageView.image = [UIImage imageNamed:@"mine_icon"];
                }
                
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"mine_icon"]];
            }
        }
        
    } else {
        cell.textLabel.text = self.itemArray[indexPath.row];
        
        
        if (indexPath.row == 0) {
            //昵称
            if (model.userName == nil || model.userName.length == 0 || [model.userName isEqualToString:@""]) {
                cell.detailTextLabel.text = @"请设置";
            } else {
                cell.detailTextLabel.text = model.userName;
            }

        }else if (indexPath.row == 1){
            //性别
            cell.detailTextLabel.text = model.userGender;
        }else if (indexPath.row == 2){
            //生日
            cell.detailTextLabel.text = model.userBirthday;
        }else if (indexPath.row == 3){
            //电话
            if (model.userNumber == nil || model.userNumber.length == 0 || [model.userNumber isEqualToString:@""]) {
                cell.detailTextLabel.text = @"电话";
            } else {
                cell.detailTextLabel.text = model.userNumber;
            }

        }else if(indexPath.row == 4){
            //个性签名
            if (model.userSignature == nil || model.userSignature.length == 0 || [model.userSignature isEqualToString:@""]) {
                cell.detailTextLabel.text = @"请设置";
            } else {
                cell.detailTextLabel.text = model.userSignature;
            }
        }
    }

    return cell;
}


#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
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

    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet *changeIconSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
        changeIconSheet.tag = 1001;
        [changeIconSheet showInView:self.view];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2001;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        UIActionSheet *changeGenderSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
        changeGenderSheet.tag = 1002;
        [changeGenderSheet showInView:self.view];
    }else if (indexPath.section == 1 && indexPath.row == 2){
         [self setBrithSelectView];
    }else if (indexPath.section == 1 && indexPath.row == 3){
      //电话号码不可更改
    }else if (indexPath.section == 1 && indexPath.row == 4){
       // [self addSignatureView];
        PersonSignatureViewController *signatuireVC = [PersonSignatureViewController new];
        signatuireVC.modifySignatureBlock = ^(NSString *text){
            UITableViewCell *textCell = [tableView cellForRowAtIndexPath:indexPath];
            textCell.detailTextLabel.text = text;
        };
        [self.navigationController pushViewController:signatuireVC animated:YES];
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2001 && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            NSDictionary *dic = @{@"field":@"nick_name",@"fieval":textField.text};
            [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
                if (!error) {
                    NSDictionary *dic = (NSDictionary *)data;
                    if ([[dic objectForKey:@"status"] integerValue] == 1) {
                        [CustomMBHud customHudWindow:@"昵称修改成功"];
                        UITableViewCell *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                        nameCell.detailTextLabel.text = textField.text;
                        
                        
                        
                        //这里把xmpp的个人信息修改一下
                        [ChatSendHelper modifyUserNicknameWithString:textField.text];
                        [ChatSendHelper modifyUserHeadPortraitWithImage:nil nickName:textField.text];
                    } else {
                        [CustomMBHud customHudWindow:@"昵称修改失败"];
                    }
                }
            }];
        }
    } else {
        DLog(@"取消");
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1001) {
    switch (buttonIndex) {
        case 0:
        {
            BOOL iscamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if (!iscamera) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
                return;
            }
            UIImagePickerController *pick = [[UIImagePickerController alloc]init];
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.allowsEditing = YES;
            [self presentViewController:pick animated:YES completion:NULL];
            
        }
            break;
        case 1:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc]init];
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickController animated:YES completion:^{}];
        }
            break;
            
        default:
            break;
       }
    
    }else if (actionSheet.tag == 1002){
        if(buttonIndex!=2){
        NSDictionary *dic = @{@"field":@"gender",@"fieval":[NSNumber numberWithInteger:buttonIndex + 1]};
        [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    [CustomMBHud customHudWindow:@"修改成功"];
                    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    if (buttonIndex == 0) {
                        cell.detailTextLabel.text = @"男";
                    }else if (buttonIndex == 1){
                        cell.detailTextLabel.text = @"女";
                    }
                  };
                } else {
                    [CustomMBHud customHudWindow:@"修改失败"];
            }
        }];
    }
  }
}

- (void)setBrithSelectView{
    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight * 0.70, MainWidth, MainHeight *0.45)];
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [coverView addSubview:view];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    datePicker.frame = CGRectMake(0, 0 , MainWidth, 150);
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate* minDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-366*24*3600*60];
    NSDate* maxDate = [[NSDate alloc]init];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:datePicker];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0, CGRectGetMaxY(self.datePicker.frame), MainWidth / 2.0, 44);
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    sureButton.layer.borderColor = [UIColor blackColor].CGColor;
    sureButton.layer.borderWidth = 0.5;
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton = sureButton;
    [view addSubview:sureButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(MainWidth / 2.0, CGRectGetMaxY(self.datePicker.frame), MainWidth / 2.0, 44);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;
    [view addSubview:cancelButton];
}
- (void)addSignatureView{
    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight * 0.70, MainWidth, MainHeight *0.45)];
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [coverView addSubview:view];
    
    UITextView *setSignatureView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 150)];
    setSignatureView.backgroundColor = [UIColor whiteColor];
    setSignatureView.font = [UIFont systemFontOfSize:20];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.setSignatureView = setSignatureView;
    self.setSignatureView.delegate = self;
    [view addSubview:setSignatureView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0, CGRectGetMaxY(self.setSignatureView.frame), MainWidth / 2.0, 44);
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    sureButton.layer.borderColor = [UIColor blackColor].CGColor;
    sureButton.layer.borderWidth = 0.5;
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton = sureButton;
    [view addSubview:sureButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(MainWidth / 2.0, CGRectGetMaxY(self.setSignatureView.frame), MainWidth / 2.0, 44);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;
    [view addSubview:cancelButton];
}
#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    [self AddHUD];
    [[AirCloudNetAPIManager sharedManager] updatePhotoOfImage:image params:nil WithBlock:^(id data, NSError *error) {
        DLog(@"data = %@",data);
        [self HUDHidden];
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                DLog(@"上传图片成功");
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
                imageView.image = image;
                
                //图片保存到本地路径
                NSString *iconPath = [GeneralToolObject personalIconFilePath];
                [UIImagePNGRepresentation(image) writeToFile:iconPath atomically:YES];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *number = [defaults objectForKey:UserNumber];
                [DBOperate updateData:T_personalInfo tableColumn:@"iconPath" columnValue:iconPath conditionColumn:@"phoneNum" conditionColumnValue:number];
                
                //这里把xmpp的个人信息修改一下
                [ChatSendHelper modifyUserHeadPortraitWithImage:image nickName:nil];
                
            } else {
                [CustomMBHud customHudWindow:@"上传图片失败"];
            }
        }

    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)requestPersonalInfo {
    NSDictionary *dic = @{@"us":@"us"};
    [self AddHUD];
    [[AirCloudNetAPIManager sharedManager] getUserCenterInfoOfParams:dic WithBlock:^(id data, NSError *error) {
        [self HUDHidden];
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
- (void)sureButtonClick{
    if (self.setBirthStr.length > 0) {
    NSDictionary *dic = @{@"field":@"birthday",@"fieval":self.setBirthStr};
    [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                [CustomMBHud customHudWindow:@"修改成功"];
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                cell.detailTextLabel.text = self.setBirthStr;
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:@"修改失败"];
            }
        }
        
    }];
    [self.coverView removeFromSuperview];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:2 inSection:1   ];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.coverView removeFromSuperview];
    }
}
- (void)cancelButtonClick{
    [self.coverView removeFromSuperview];
}



- (void)dateChange:(UIDatePicker *)datePicker{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate: datePicker.date];
    self.setBirthStr = dateString;
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

#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
