//
//  PersonalViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonalViewController.h"
#import "Global.h"

@interface PersonalViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSDictionary *personalDic;

@property (nonatomic, strong) NSTextAttachment *attchIcon;

@end


@implementation PersonalViewController
- (NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray = @[@"昵称",@"性别",@"生日",@"手机",@"个性签名"];
    }
    return _itemArray;
}


- (void)initData {
    
    //先读取缓存
    NSString *cachePath = [self personalInfoFilePath];
    self.personalDic = [[NSMutableDictionary alloc] initWithContentsOfFile:cachePath];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"账号";
    [self.view addSubview:self.tableView];
      //返回
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];



    //图片路径
    NSString *iconPath = [self personalIconFilePath];
    UIImage *image = [UIImage imageNamed:@"tabbar_homepage_selected.png"];
    [UIImagePNGRepresentation(image) writeToFile:iconPath atomically:YES];
    
    //写入沙盒
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
    [infoDic setValue:iconPath forKey:@"personalIcon"];
    [infoDic setValue:@"王聪" forKey:@"personalName"];
    [infoDic setValue:@"13113689077" forKey:@"personalNumber"];
    [infoDic setObject:@"小白" forKey:@"nickname"];
    [infoDic setObject:@"男" forKey:@"gender"];
    [infoDic setObject:@"20150302" forKey:@"birthDate"];
    [infoDic setObject:@"火狐哈哈哈" forKey:@"signingMsg"];
    BOOL result = [infoDic writeToFile:[self personalInfoFilePath] atomically:YES];
    if (result) {
        DLog(@"缓存成功");
    }

    [self initData];
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
            //手机号
            UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (60 - 20)/2.0, 60, 20)];
            iconLabel.font = [UIFont systemFontOfSize:17.0];
            iconLabel.text = @"头像";
            [cell addSubview:iconLabel];
        }
      
    }
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    
    if (indexPath.section == 0) {
       
        _attchIcon = [[NSTextAttachment alloc] init];
        _attchIcon.bounds = CGRectMake(0, 0, 40, 40);
        if ([self.personalDic objectForKey:@"personalIcon"]) {
          _attchIcon.image = [UIImage imageNamed:@"mine_icon"];
        } else {
          _attchIcon.image = [UIImage imageNamed:@"mine_icon"];
        }
        NSAttributedString *iconString = [NSAttributedString attributedStringWithAttachment:_attchIcon];
        cell.detailTextLabel.attributedText = iconString;
       
        
    } else {
        cell.textLabel.text = self.itemArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [self.personalDic objectForKey:@"nickname"];
        }else if (indexPath.row == 1){
            cell.detailTextLabel.text = [self.personalDic objectForKey:@"gender"];
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = [self.personalDic objectForKey:@"birthDate"];
        }else if (indexPath.row == 3){
            cell.detailTextLabel.text = [self.personalDic objectForKey:@"personalNumber"];
        }else{
            cell.detailTextLabel.text = [self.personalDic objectForKey:@"signingMsg"];
        }
        
    }

    return cell;
}

- (void)initDate{
    //先读取缓存
    NSString *cachePath = [self personalInfoFilePath];
    self.personalDic = [[NSMutableDictionary alloc] initWithContentsOfFile:cachePath];
    [_tableView reloadData];
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
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc]init];
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickController animated:YES completion:^{}];
            
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
    
    _attchIcon.image = image;
    
    //    [self upLoadImage:UIImageJPEGRepresentation(image, 0.05)];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
