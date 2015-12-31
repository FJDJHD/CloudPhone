//
//  MessageViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MessageViewController.h"
#import "DXMessageToolBar.h"
#import "ChatSendHelper.h"
#import "MessageCell.h"
#import "UIImage+ResizeImage.h"
#import "XMPPMessage+Tools.h"
#import <AVFoundation/AVFoundation.h>
#import "EMCDDeviceManager.h"
#import "EMAudioPlayerUtil.h"
#import "XMPPvCardTemp.h"
#import "NSFileManager+Tools.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,DXChatBarMoreViewDelegate, DXMessageToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) DXMessageToolBar *chatToolBar;

@property (nonatomic, strong) NSMutableArray *dataMessageArray;

@property (nonatomic, strong) CellFrameModel *cellModel;

//@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];

    //标题
    self.title = _chatName;
    
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //这里建一个模型就够了
    _cellModel = [[CellFrameModel alloc]init];
    
    //消息数据源
    _dataMessageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatToolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    [self.fetchedResultsController performFetch:NULL];
    [self loadXMPPMessageData];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.scrollType == ScrollToBottomType) {
        [self scrollViewToBottom:NO];
    }

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    //最后的消息保存到数据库中
    [self saveLastMessageToFMDB];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //停止语音信息
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    
   
}

#pragma mark - 初始化组建
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [ColorTool backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        _refreshControl = [[UIRefreshControl alloc]init];
//        [_refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
//        [_tableView addSubview:_refreshControl];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

//- (void)refreshAction {
//   [_refreshControl endRefreshing];
//}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        
        ChatMoreType type = ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) type:type];
        _chatToolBar.moreView.backgroundColor = RGBA(240, 242, 247, 1);
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _chatToolBar;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSFetchedResultsController *)fetchedResultsController {
    // 推荐写法，减少嵌套的层次
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    // 先确定需要用到哪个实体
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    // 每一个聊天界面，只关心聊天对象的消息
    if (self.chatJID.bare) {
        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.chatJID.bare];
    }
    // 从自己写的工具类里的属性中得到上下文
    NSManagedObjectContext *ctx = [self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    // 实例化，里面要填上上面的各种参数
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchedResultsController.fetchedObjects.count;
//    return _dataMessageArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (_dataMessageArray.count > 0) {
        MessageModel *model = [_dataMessageArray objectAtIndex:indexPath.row];
        _cellModel.message = model;
        [cell cellForDataWithModel:_cellModel indexPath:indexPath controller:self];

    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_dataMessageArray.count > 0) {
        MessageModel *model = [_dataMessageArray objectAtIndex:indexPath.row];
        _cellModel.message = model;
        return _cellModel.cellHeight;
    }
    return 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self keyBoardHidden];
}

#pragma mark - 保存最后的信息
- (void)saveLastMessageToFMDB {

    //如果进来聊天界面，有消息则加入消息前一个界面的消息列表
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        
        XMPPMessageArchiving_Message_CoreDataObject *message = self.fetchedResultsController.fetchedObjects.lastObject;
        NSString *lastStr = @"";
        if ([message.body hasPrefix:@"ImgBase64"]) {
            lastStr = @"[图片]";
        } else if ([message.body hasPrefix:@"AudioBase64"]) {
            lastStr = @"[语音]";
        } else if ([message.body hasPrefix:@"TextBase64"]){
            lastStr = [message.message.body substringFromIndex:10];
        } else if ([message.body hasPrefix:@"LonBase64"]) {
            lastStr = @"[位置]";
        } else {
            lastStr = @"不配配类型。。。。。";
        }

        NSString *lastTime = [NSString stringWithFormat:@"%f",[message.timestamp timeIntervalSince1970]];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *number = [defaults objectForKey:UserNumber];
        NSArray *messageArray = [NSArray arrayWithObjects:self.chatJIDStr,self.chatName,lastStr,lastTime,@"0",number,nil];
        
        NSArray *chatArray = [DBOperate queryData:T_chatMessage theColumn:@"jidStr" equalValue:self.chatJIDStr theColumn:@"mineNumber" equalValue:number];
        if (chatArray.count > 0) {
            
            //最后一条信息
            [DBOperate updateData:T_chatMessage tableColumn:@"lastMessage" columnValue:lastStr conditionColumn:@"jidStr" conditionColumnValue:self.chatJIDStr];
            
            //最后的时间
             [DBOperate updateData:T_chatMessage tableColumn:@"time" columnValue:lastTime conditionColumn:@"jidStr" conditionColumnValue:self.chatJIDStr];
            
            //红点清零
             [DBOperate updateData:T_chatMessage tableColumn:@"unreadMessage" columnValue:@"0" conditionColumn:@"jidStr" conditionColumnValue:self.chatJIDStr];
            
        } else {
            [DBOperate insertDataWithnotAutoID:messageArray tableName:T_chatMessage];
        }
    }
}


#pragma mark - NSFetchedResultsControllerDelegate
//结果调度器有一个代理方法，一旦上下文改变触发，也就是刚加了好友，或删除好友时会触发
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    DLog(@"上下文改变");

    [self loadXMPPMessageData];
    
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
}


- (void)loadXMPPMessageData {
    [_dataMessageArray removeAllObjects];
    
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in self.fetchedResultsController.fetchedObjects) {
            
            MessageModel *messagemodel = [[MessageModel alloc]init];

            if ([message.body hasPrefix:@"ImgBase64"]) {
                //先存本地一份（放大图片从本地取不会失真，好神奇）
                [self saveDataWithJID:self.chatJID.bare timestamp:message.timestamp content:message.body messageType:@"image"];
                NSString *path = [self pathForData:self.chatJID.bare timestamp:message.timestamp];
                
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                messagemodel.image = image;
                messagemodel.imagePath = path;
                messagemodel.messageType = kImageMessage; //图片类型
                messagemodel.text = @"照片";
                
            } else if ([message.body hasPrefix:@"AudioBase64"]) {
                NSString *timeStr = [self getTimeString:message.body];
                [self saveDataWithJID:self.chatJID.bare timestamp:message.timestamp content:message.body messageType:@"audio"];
                NSString *path = [self pathForData:self.chatJID.bare timestamp:message.timestamp];
                
                messagemodel.voiceTime = timeStr;
                messagemodel.voiceFilepath = path;
                messagemodel.messageType = kVoiceMessage; //语音类型
                messagemodel.text = @"语音";
                
            } else if ([message.body hasPrefix:@"TextBase64"]){
                
                messagemodel.text = [message.body substringFromIndex:10];
                messagemodel.messageType = kTextMessage; //文字类型
                
            } else if ([message.body hasPrefix:@"LonBase64"]){
                
                NSString *jsonStr = [message.body substringFromIndex:9];
                if (jsonStr) {
                    NSDictionary *locDic = [GeneralToolObject parseJSONStringToNSDictionary:jsonStr];
                    messagemodel.lat = [[locDic objectForKey:@"latitude"] doubleValue];
                    messagemodel.lon = [[locDic objectForKey:@"longitude"] doubleValue];
                    messagemodel.address = [locDic objectForKey:@"address"];
                }
                messagemodel.messageType = kLocationMessage; //地理位置类型
            
            } else {
                messagemodel.text = @"不配配类型。。。。";
                messagemodel.messageType = kTextMessage; //文字类型
            }
            messagemodel.otherPhoto = self.chatPhoto;
            messagemodel.chatJID = self.chatJID;
            messagemodel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
            
            [_dataMessageArray addObject:messagemodel];
        }
    }
   
}

#pragma maek - 发送图片语音存放本地
//图片和语音存到本地 ，，
- (void)saveDataWithJID:(NSString *)jid timestamp:(NSDate *)timestamp
                             content:(NSString *)body messageType:(NSString *)type{
    if ([type isEqualToString:@"image"]) {
        NSString *base64str = [body substringFromIndex:9];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
        //存到本地
        [data writeToFile:[self pathForData:jid timestamp:timestamp] atomically:YES];
        
    } else if ([type isEqualToString:@"audio"]) {
        NSArray *array = [body componentsSeparatedByString:@"}"];
        NSString *base64str = array[1];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
        //存到本地
        [data writeToFile:[self pathForData:jid timestamp:timestamp] atomically:YES];
    }
}

- (NSString *)pathForData:(NSString *)jid timestamp:(NSDate *)timestamp {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [fileManager applicationCachesDirectory];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%f",jid,[timestamp timeIntervalSince1970]]];
    return filePath;
}
//AudioBase64{%ld}
- (NSString *)getTimeString:(NSString *)content{
    
    NSRange start = [content rangeOfString:@"{"];
    NSRange end = [content rangeOfString:@"}"];
    NSString *sub = [content substringWithRange:NSMakeRange(start.location + 1, end.location-start.location-1)];
    return sub;
}


#pragma mark -DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text{
    if (text && text.length > 0) {
        [ChatSendHelper sendTextMessageWithString:text toUsername:self.chatJIDStr];
        self.chatToolBar.inputTextView.text = @"";
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView{
    if ([self canRecord]) {
        DXRecordView *tmpView = (DXRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%f%d",(double)time,x];
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 DLog(@"failure to start recording");
             }
         }];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView{
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            //发送录音
            NSData *data = [NSData dataWithContentsOfFile:recordPath];
            [ChatSendHelper sendVoiceMessageWithAudio:data time:aDuration toUsername:self.chatJID];
            
        }else {
            weakSelf.chatToolBar.recordButton.enabled = YES;

//            weakSelf.chatToolBar.recordButton.enabled = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                weakSelf.chatToolBar.recordButton.enabled = YES;
//            });
        }
    }];
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    DLog(@"照片");
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    [self keyBoardHidden];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    DLog(@"照相");
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
    [self keyBoardHidden];
}

- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    DLog(@"定位");
    WEAKSELF
    LocationViewController *controller = [[LocationViewController alloc]init];
    controller.locationBlock = ^(double lat ,double lon , NSString *address){
        DLog(@"lat = %f\n lon = %f\n address = %@",lat,lon,address);
        [ChatSendHelper sendLocationMessageWithLatitude:lat longitude:lon adress:address toUsername:weakSelf.chatJID];
    
    };
    
    [self.navigationController pushViewController:controller animated:NO];
    // 隐藏键盘
    [self keyBoardHidden];
}

- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
}

- (void)moreViewVideoCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    //发送照片
    [ChatSendHelper sendImageMessageWithImage:image toUsername:self.chatJID];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Methd
- (void)scrollViewToBottom:(BOOL)animated{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    return bCanRecord;
}

// 点击背景隐藏
-(void)keyBoardHidden{
    [self.chatToolBar endEditing:YES];
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture{
    [self.chatToolBar endEditing:YES];
}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
