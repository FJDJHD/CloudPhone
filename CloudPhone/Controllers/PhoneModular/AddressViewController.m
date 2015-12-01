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

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,ABNewPersonViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *listTitleArray;
@property (nonatomic, strong) NSMutableArray *listContentArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddressViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _listTitleArray = [[NSMutableArray alloc]initWithCapacity:0];
        _listContentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"通讯录";
    
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //导航栏右按钮
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = CGRectMake(0, 0, 44, 44);
    addressButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [addressButton setTitle:@"添加" forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //添加表视图
    [self.view addSubview:self.tableView];
    
    [self loadAddressData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.rowHeight = 60;
        _tableView.sectionIndexColor = RGB(51, 51, 51);
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)loadAddressData {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self initData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });
    });
}

- (void)initData {
    self.listContentArray = [self getAllPerson];
    if (self.listContentArray == nil) {
        DLog(@"通讯录为空，或未获取访问权限");
        return;
    } else {
    
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        [self.listTitleArray removeAllObjects];
        [self.listTitleArray addObjectsFromArray:[theCollation sectionTitles]];
        
      
        NSMutableArray *existTitles = [NSMutableArray array];
        for (NSInteger i = 0; i < _listContentArray.count; i ++) {
            PersonModel *person = _listContentArray[i][0];
            for (NSInteger j = 0; j < _listTitleArray.count; j ++) {
                if (person.sectionNumber == j) {
                    [existTitles addObject:_listTitleArray[j]];
                }
            }
        }
        
        [self.listTitleArray removeAllObjects];
        self.listTitleArray = existTitles;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _listContentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_listContentArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (self.listContentArray && self.listContentArray.count > 0) {
        NSArray *sectionArr = [_listContentArray objectAtIndex:indexPath.section];
        PersonModel *model = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.phonename;
        cell.detailTextLabel.text = model.tel;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

//开启右侧索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return self.listTitleArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

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


#pragma mark - 获取通讯录内容
- (NSMutableArray *)getAllPerson {

    NSMutableArray *addressBookArray =[NSMutableArray array];
    NSMutableArray *listContent = [NSMutableArray array];
    NSMutableArray *sectionTitleArray = [NSMutableArray array];
    
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取通讯录访问授权
    ABAuthorizationStatus authorization = ABAddressBookGetAuthorizationStatus();
    if (authorization != kABAuthorizationStatusAuthorized) {
        NSLog(@"未获取通讯录访问授权");
        return nil;
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //发出访问通讯录的请求
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"未获取访问权限");
        }
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i = 0; i < nPeople; i ++) {
        PersonModel *model = [[PersonModel alloc]init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
        
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@ %@",nameString,lastNameString];
            }
        }
        
        model.name1 = nameString;
        model.phonename = nameString;
        model.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID mutiProperties[] = {
            kABPersonPhoneProperty, //电话
            kABPersonEmailProperty  //邮箱
        };
        
        NSInteger multiPropertiesTotal = sizeof(mutiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j ++) {
            ABPropertyID property = mutiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) {
                valuesCount = ABMultiValueGetCount(valuesRef);
            }
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            for (NSInteger k = 0; k < valuesCount; k ++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0:  //phone number
                        model.tel = [(__bridge NSString *)value initTelephoneWithReformat];
                        break;
                        
                    default:
                        model.email = (__bridge NSString *)value;
                        break;
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
            
        }
        [addressBookArray addObject:model];
        if (abName) {
            CFRelease(abName);
        }
        if (abLastName) {
            CFRelease(abLastName);
        }
        if (abFullName) {
            CFRelease(abFullName);
        }
    }
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    //对数组排序，按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [sectionTitleArray removeAllObjects];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    [sectionTitleArray addObjectsFromArray:[theCollation sectionTitles]];
    
    for (PersonModel *person in addressBookArray) {
        if (person.name1 != nil) {
            NSInteger sect = [theCollation sectionForObject:person collationStringSelector:@selector(name1)];
            person.sectionNumber = sect;
        }
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count]; //27
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (NSInteger i = 0; i <= highSection; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //把对应的名字放入这个27个数组中,将每个人按name分到某个section下
    for (PersonModel *person in addressBookArray) {
        [sectionArrays[person.sectionNumber] addObject:person];
    }
    
    for (NSMutableArray *temp in sectionArrays) {
        PersonModel *person = (PersonModel *)temp.firstObject;
        if (person.name1 == nil || [person.name1 isEqualToString:@""]) {
            continue;
        }
        if (person.name1 != nil) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:temp collationStringSelector:@selector(name1)];
            [listContent addObject:sortedSection];
        }
    }
    return listContent;
}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
