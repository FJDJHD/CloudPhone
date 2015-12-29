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

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,DXChatBarMoreViewDelegate, DXMessageToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DXMessageToolBar *chatToolBar;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSMutableArray *dataMessageArray; // 暂时没用这个

//@property (nonatomic, strong) CellFrameModel *cellModel;
//
//@property (nonatomic, strong) MessageModel *messageModel;

//@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];

    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //标题
    self.title = _chatName;

    
//    _cellModel = [[CellFrameModel alloc]init];
//    _messageModel = [[MessageModel alloc]init];
    
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
    
//    return self.fetchedResultsController.fetchedObjects.count;
    return _dataMessageArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    // 如果存进去了，就把字符串转化成简洁的节点后保存
//    if ([message.message saveAttachmentJID:self.chatJID.bare timestamp:message.timestamp]) {
//        message.messageStr = [message.message compactXMLString];
//        [[self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
//    }
//    _messageModel.voiceFilepath = nil;
//    _messageModel.imagePath = nil;
//    NSString *path = [message.message pathForAttachment:self.chatJID.bare timestamp:message.timestamp];
//    
//    if ([message.body isEqualToString:@"image"]) {
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        _messageModel.image = image;
//        _messageModel.imagePath = path;
//        _messageModel.messageType = kImageMessage; //图片类型
//        
//    } else if ([message.body hasPrefix:@"audio"]) {
//        
//        NSString *timeStr = [message.body substringFromIndex:5];
//        _messageModel.voiceTime = timeStr;
//        _messageModel.voiceFilepath = path; //音频路径
//        _messageModel.messageType = kVoiceMessage; //语音类型
//    
//    } else {
//       _messageModel.messageType = kTextMessage; //文字类型
//    }
//    _messageModel.text = message.body;
//    _messageModel.otherPhoto = self.chatPhoto;
//    _messageModel.chatJID = self.chatJID;
//    _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
//    _cellModel.message = _messageModel;
//    cell.cellFrame = _cellModel;
    
    
    if (_dataMessageArray.count > 0) {
        
        CellFrameModel *model = [_dataMessageArray objectAtIndex:indexPath.row];
        
        [cell cellForDataWithModel:model indexPath:indexPath controller:self];

    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    _messageModel.text = message.body;
//    _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
//    _cellModel.message = _messageModel;

    if (_dataMessageArray.count > 0) {
        CellFrameModel *model = [_dataMessageArray objectAtIndex:indexPath.row];
        return model.cellHeight;
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
        if ([message.body isEqualToString:@"image"]) {
            lastStr = @"[图片]";
        } else if ([message.body hasPrefix:@"audio"]) {
            lastStr = @"[语音]";
        } else {
            lastStr = message.message.body;
        }
        NSString *lastTime = [NSString stringWithFormat:@"%f",[message.timestamp timeIntervalSince1970]];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *number = [defaults objectForKey:UserNumber];
        NSArray *messageArray = [NSArray arrayWithObjects:self.chatJIDStr,self.chatName,lastStr,lastTime,@"0",number,nil];
        
        NSArray *chatArray = [DBOperate queryData:T_chatMessage theColumn:@"jidStr" theColumnValue:self.chatJIDStr withAll:NO];
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
    
    if (self.fetchedResultsController.fetchedObjects > 0) {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in self.fetchedResultsController.fetchedObjects) {
            
            @autoreleasepool {
                CellFrameModel *cellmodel = [[CellFrameModel alloc]init];
                
                MessageModel *messagemodel = [[MessageModel alloc]init];
                // 如果存进去了，就把字符串转化成简洁的节点后保存
                if ([message.message saveAttachmentJID:self.chatJID.bare timestamp:message.timestamp]) {
                    message.messageStr = [message.message compactXMLString];
                    [[self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
                }
                NSString *path = [message.message pathForAttachment:self.chatJID.bare timestamp:message.timestamp];
                
                if ([message.body isEqualToString:@"image"]) {
                    UIImage *image = [UIImage imageWithContentsOfFile:path];
                    messagemodel.image = image;
                    messagemodel.imagePath = path;
                    messagemodel.messageType = kImageMessage; //图片类型
                    
                } else if ([message.body hasPrefix:@"audio"]) {
                    NSString *timeStr = [message.body substringFromIndex:5];
                    messagemodel.voiceTime = timeStr;
                    messagemodel.voiceFilepath = path;
                    messagemodel.messageType = kVoiceMessage; //语音类型
                    
                } else {
                    messagemodel.messageType = kTextMessage; //文字类型
                }
                messagemodel.text = message.body;
                messagemodel.otherPhoto = self.chatPhoto;
                messagemodel.chatJID = self.chatJID;
                messagemodel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
                
                cellmodel.message = messagemodel;
                
                [_dataMessageArray addObject:cellmodel];
            }
        }
    }
   
}

#pragma mark -DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [ChatSendHelper sendTextMessageWithString:text toUsername:self.chatJIDStr];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
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
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
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
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    //发送照片
    [ChatSendHelper sendImageMessageWithImage:image toUsername:self.chatJID];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Methd
- (void)scrollViewToBottom:(BOOL)animated
{
    
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
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
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
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
