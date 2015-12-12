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

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,DXChatBarMoreViewDelegate, DXMessageToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) CellFrameModel *cellModel;

@property (nonatomic, strong) MessageModel *messageModel;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];

    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.title = self.chatUser ? self.chatUser : @"会话";
    
    _cellModel = [[CellFrameModel alloc]init];
    _messageModel = [[MessageModel alloc]init];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatToolBar];
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    [self.fetchedResultsController performFetch:NULL];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self scrollViewToBottom:NO];
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
    }
    return _tableView;
}

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
    request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.chatJID.bare];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // 如果存进去了，就把字符串转化成简洁的节点后保存
    if ([message.message saveAttachmentJID:self.chatJID.bare timestamp:message.timestamp]) {
        message.messageStr = [message.message compactXMLString];
        [[self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
    }
    NSString *path = [message.message pathForAttachment:self.chatJID.bare timestamp:message.timestamp];
    if ([message.body isEqualToString:@"image"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        _messageModel.image = image;
        _messageModel.messageType = kImageMessage; //图片类型
        
    } else if ([message.body hasPrefix:@"audio"]) {
        NSArray *arr = [message.body componentsSeparatedByString:@"audio"];
        if (arr.count > 0) {
            _messageModel.voiceFilepath = arr[1];
        }
        _messageModel.messageType = kVoiceMessage; //语音类型
    
    } else {
       _messageModel.messageType = kTextMessage; //文字类型
    }
    NSLog(@"message = %@",message);
    _messageModel.text = message.body;
    _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
    _cellModel.message = _messageModel;
    cell.cellFrame = _cellModel;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([message.body hasPrefix:@"audio"]) {
        NSArray *arr = [message.body componentsSeparatedByString:@"audio"];
        if (arr.count > 0) {
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:arr[1] completion:^(NSError *error) {
                if (!error) {
                    DLog(@"播放语音");
                } else {
                    DLog(@"播放error ＝ %@",error);
                }}];
        }
    } else {
        return;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    _messageModel.text = message.body;
    _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
    
    _cellModel.message = _messageModel;
    return _cellModel.cellHeight;
        
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self keyBoardHidden];
}


#pragma mark - NSFetchedResultsControllerDelegate
//结果调度器有一个代理方法，一旦上下文改变触发，也就是刚加了好友，或删除好友时会触发
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    DLog(@"上下文改变");
    [self.tableView reloadData];
    [self scrollViewToBottom:NO];
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
        DLog(@"%@",text);
        [ChatSendHelper sendTextMessageWithString:text toUsername:self.chatUser];
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
            
            [ChatSendHelper sendVoiceMessageWithAudio:data filePath:recordPath toUsername:self.chatJID];
            
        }else {
            [CustomMBHud customHudWindow:@"录音时间太短"];
            weakSelf.chatToolBar.recordButton.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.chatToolBar.recordButton.enabled = YES;
            });
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
    [self keyBoardHidden];
    DLog(@"照相");

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

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
