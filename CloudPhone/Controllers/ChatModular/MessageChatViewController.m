//
//  MessageChatViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MessageChatViewController.h"
#import "XMPPMessage+Tools.h"
#import "YTKeyBoardView.h"
#import "MessageCell.h"
#import "UIImage+ResizeImage.h"

@interface MessageChatViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSFetchedResultsControllerDelegate,YTKeyBoardDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) YTKeyBoardView *keyBoard;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CellFrameModel *cellModel;

@property (nonatomic, strong) MessageModel *messageModel;




@end

@implementation MessageChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.chatUser ? self.chatUser : @"会话";
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _cellModel = [[CellFrameModel alloc]init];
    _messageModel = [[MessageModel alloc]init];
    
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //导航栏右按钮
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(0, 0, 44, 44);
    testButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testButton setTitle:@"图片" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:testButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.view addSubview:self.tableView];
    
    self.keyBoard = [[YTKeyBoardView alloc]
                     initDelegate:self
                     superView:self.view];
    
    
    [self.fetchedResultsController performFetch:NULL];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fetchedResultsController.fetchedObjects.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 300;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITabvleViewDatasource

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
    // 取出当前行的消息
//    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    //判断是发出消息还是接受消息
//    NSString *outgoMessage = (message.outgoing.intValue == 1) ? @"Send" : @"Recive";
    
    
        XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
        // 如果存进去了，就把字符串转化成简洁的节点后保存
        if ([message.message saveAttachmentJID:self.chatJID.bare timestamp:message.timestamp]) {
            message.messageStr = [message.message compactXMLString];
            
            [[self appDelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
        }
        NSString *path = [message.message pathForAttachment:self.chatJID.bare timestamp:message.timestamp];
        if ([message.body isEqualToString:@"image"]) {
//            UIImage *image = [UIImage imageWithContentsOfFile:path];
//            NSTextAttachment *attach = [[NSTextAttachment alloc]init];
//            attach.image = [image scaleImageWithWidth:100];
//            NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
            
//            _messageModel.attachStr = attachStr;
        }
    
    
        _messageModel.text = message.body;
        _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
        
        _cellModel.message = _messageModel;
        cell.cellFrame = _cellModel;
    

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (_dataArray.count > 0) {
//        CellFrameModel *model = _dataArray[indexPath.row];
//        
//        return model.cellHeight;
//    }
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    _messageModel.text = message.body;
    _messageModel.type = (message.outgoing.intValue == 1) ? kMessageModelTypeOther : kMessageModelTypeMe;
    
    _cellModel.message = _messageModel;
    if ([message.body isEqualToString:@"image"]) {
        return 220;
    } else {
        return _cellModel.cellHeight ? _cellModel.cellHeight : 44.0;

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.view endEditing:YES];
}

- (void)testButtonClick {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    [self keyBoardView:_keyBoard sendResous:image];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatJID];
    [message addBody:name];
    //转化base64编码
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    
    //设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
    
    //包含子节点
    [message addChild:attachment];
    [[self appDelegate].xmppStream sendElement:message];
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

//结果调度器有一个代理方法，一旦上下文改变触发，也就是刚加了好友，或删除好友时会触发
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"上下文改变");
    [self.tableView reloadData];
    
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fetchedResultsController.fetchedObjects.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark - key board delegate
- (void)keyBoardView:(YTKeyBoardView *)keyBoard sendResous:(id)resous{
    if (!resous) return;
    NSString *string = @"";
    NSArray *array = [self.chatUser componentsSeparatedByString:XMPPSevser];
    if ([resous isKindOfClass:[NSString class]]) {
        string = resous;
        //发送xmpp信息
        [self xmppSendMessage:string];
        //保存到自己服务器数据库
       
        [[AirCloudNetAPIManager sharedManager] saveSendMessageOfParams:@{@"mobile" : array[0],@"content" : string} WithBlock:^(id data, NSError *error) {
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    DLog(@"****");
                } else {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                }
            }
        }];

        
    }else if ([resous isKindOfClass:[UIImage class]]){
        
        NSData *data= UIImageJPEGRepresentation(resous, 0.5);
        
        [self sendMessageWithData:data bodyName:@"image"];
        [[AirCloudNetAPIManager sharedManager] saveSendPhotoOfImage:resous params:@{@"mobile" : array[0]} WithBlock:^(id data, NSError *error) {
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    DLog(@"****");
                } else {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                }
            }
        }];
        
//        [[AirCloudNetAPIManager sharedManager] saveSendPhotoOfImage:resous WithBlock:^(id data, NSError *error) {
//            if (!error) {
//                NSDictionary *dic = (NSDictionary *)data;
//                if ([[dic objectForKey:@"status"] integerValue] == 1) {
//                    DLog(@"上传图片成功");
//                  
//                } else {
//                    DLog(@"上传图片失败");
//                }
//            }
//        }];
        
//        UIImage *image = resous;
//        CGRect rect = CGRectZero;
//        rect.size = image.size;
//        UIView *view = [[UIView alloc]initWithFrame:rect];
//        rect.origin.x = (self.view.bounds.size.width - rect.size.width)*0.5f;
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
//        imageView.image = image;
//        [view addSubview:imageView];
//        self.tableView.tableFooterView = view;
//        string = [NSString stringWithFormat:@"image:size->%@ ⬇️ 有图片展示",NSStringFromCGSize(image.size)];
    }else{
        return;
    }
}

- (void)keyBoardView:(YTKeyBoardView *)keyBoard ChangeDuration:(CGFloat)durtaion{
    if (self.fetchedResultsController.fetchedObjects.count == 0) return;
    [UIView animateWithDuration:durtaion animations:^{
        self.tableView.frame = [self tableViewFrame];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fetchedResultsController.fetchedObjects.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)keyBoardView:(YTKeyBoardView *)keyBoard audioRuning:(UILongPressGestureRecognizer *)longPress{
    DLog(@"录音 -> 在此处理");
    if (longPress.state == UIGestureRecognizerStateEnded) {
        [self keyBoardView:keyBoard sendResous:@"录音"];
    }
}

- (void)keyBoardView:(YTKeyBoardView *)keyBoard otherType:(YTMoreViewTypeAction)type{
    DLog(@"相机 相册 -> 在此处理");
    NSString * m;
    if (type == YTMoreViewTypeActionCamera) {
        m = @"相机";
    }else{
        //相册
        m = @"相册";
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];

    }
}

- (void)xmppSendMessage:(NSString *)string {
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:string];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = self.chatUser;
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    [[[self appDelegate] xmppStream] sendElement:message];
    
}

- (CGRect)tableViewFrame{
    CGRect frame = self.view.bounds;
    if (!self.navigationController) {
        frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    frame.size.height = self.keyBoard.frame.origin.y-frame.origin.y;
    return frame;
}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    [self.keyBoard cleanDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
