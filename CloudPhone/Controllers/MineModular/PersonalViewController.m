//
//  PersonalViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonalViewController.h"
#import "Global.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"

#import "PersonalNameViewController.h"
#import "PersonGenderViewController.h"
#import "PersonBirthdayViewController.h"
#import "PersonSignatureViewController.h"



@interface PersonalViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSDictionary *personalDic;

@property (nonatomic, strong) NSTextAttachment *attchIcon;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UserModel *user;


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
    [self.view addSubview:self.tableView];
      //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    [self requestPersonalInfo];
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
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"mine_icon"]];
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
        [changeIconSheet showInView:self.view];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        PersonalNameViewController *personalNameVC = [PersonalNameViewController new];
        personalNameVC.modifyNameBlock = ^(NSString *name){
            UITableViewCell *nameCell = [tableView cellForRowAtIndexPath:indexPath];
            nameCell.detailTextLabel.text = name;
            
        };
        [self.navigationController pushViewController:personalNameVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        PersonGenderViewController *genderVC = [PersonGenderViewController new];
        genderVC.modifyGenderBlock = ^(NSInteger gender){
            UITableViewCell *genderCell = [tableView cellForRowAtIndexPath:indexPath];
            if (gender == 0) {
                genderCell.detailTextLabel.text = @"保密";
            }else if (gender == 1)
            {
                genderCell.detailTextLabel.text = @"男";
            }else{
                genderCell.detailTextLabel.text = @"女";
            }
        };
        
        [self.navigationController pushViewController:genderVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        PersonBirthdayViewController *birthVC = [PersonBirthdayViewController new];
        birthVC.modifyBirthBlock = ^(NSString *birth){
            UITableViewCell *textCell = [tableView cellForRowAtIndexPath:indexPath];
            textCell.detailTextLabel.text = birth;
        };
        [self.navigationController pushViewController:birthVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 3){
      //电话号码不可更改
    }else if (indexPath.section == 1 && indexPath.row == 4){
        PersonSignatureViewController *signatuireVC = [PersonSignatureViewController new];
        signatuireVC.modifySignatureBlock = ^(NSString *text){
            UITableViewCell *textCell = [tableView cellForRowAtIndexPath:indexPath];
            textCell.detailTextLabel.text = text;
        };
        [self.navigationController pushViewController:signatuireVC animated:YES];
        
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
}

#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"editing===========");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self AddHUD];
//    [[AirCloudNetAPIManager sharedManager] updatePhotoOfImage:image WithBlock:^(id data, NSError *error) {
//        DLog(@"data = %@",data);
//        [self HUDHidden];
//        if (!error) {
//            NSDictionary *dic = (NSDictionary *)data;
//            if ([[dic objectForKey:@"status"] integerValue] == 1) {
//                NSLog(@"上传图片成功");
//                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//                UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
//                imageView.image = image;
//            } else {
//                [CustomMBHud customHudWindow:@"上传图片失败"];
//            }
//        }
//    }];
    [[AirCloudNetAPIManager sharedManager] updatePhotoOfImage:image params:nil WithBlock:^(id data, NSError *error) {
        DLog(@"data = %@",data);
        [self HUDHidden];
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                NSLog(@"上传图片成功");
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
                imageView.image = image;
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
                    _user = [[UserModel alloc]init];
                    _user.userNumber = [info objectForKey:@"mobile"];
                    _user.userName = [info objectForKey:@"nick_name"];
                    _user.userIcon = [info objectForKey:@"photo"];
                    _user.userBirthday = [info objectForKey:@"birthday"];
                    _user.userGender = [info objectForKey:@"gender"];
                    _user.userSignature = [info objectForKey:@"signature"];
                    [_tableView reloadData];
                }

                
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:[dic objectForKey:@"msg"]];
                
            }
        }
    }];
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
