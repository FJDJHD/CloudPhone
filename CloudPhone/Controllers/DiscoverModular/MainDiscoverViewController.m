//
//  MainDiscoverViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MainDiscoverViewController.h"
#import "Global.h"
@interface MainDiscoverViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *appBar;
@property (nonatomic, strong) UIScrollView *adScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *imagesArray;
@end

@implementation MainDiscoverViewController
- (NSArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSArray array];
        _imagesArray = @[@"find_adv01",@"find_adv02",@"find_adv03"];
    }
    return _imagesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupAppBar];
    [self setupadScrollView];
    [self setupPageControl];
    [self setAllButtons];
}

- (void)setupAppBar{
    UIScrollView *appBar= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
    appBar.tag = 1002;
    appBar.contentSize = CGSizeMake(0, MainHeight * 1.5);
    self.appBar  = appBar;
    [self.view addSubview:appBar];
}

- (void)setupImageView{
    CGFloat imageW = self.adScrollView.frame.size.width;
    CGFloat imageH = 140;
    // 添加图片
    for (int i = 0; i < self.imagesArray.count; i++) {
        CGFloat imageX = i * imageW;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 0.0, imageW, imageH)];
        [imageView setImage:[UIImage imageNamed:self.imagesArray[i]]];
        [self.adScrollView addSubview:imageView];
    }
}

- (void)setupadScrollView {
    CGFloat adScrollViewX = 0;
    CGFloat adScrollViewY = STATUS_NAV_BAR_HEIGHT;
    CGFloat adScrollViewH = 140;
    CGFloat adScrollViewW = self.view.frame.size.width;
    UIScrollView *adScrollView = [[UIScrollView alloc] init];
    adScrollView.frame =  CGRectMake(adScrollViewX, adScrollViewY, adScrollViewW, adScrollViewH);
    adScrollView.showsHorizontalScrollIndicator = NO;
    adScrollView.contentSize = CGSizeMake(self.imagesArray.count * adScrollViewW, 0);
    adScrollView.pagingEnabled = YES;
    self.adScrollView = adScrollView;
    adScrollView.tag = 1001;
    self.adScrollView.delegate = self;
    [self setupImageView];
    [self.appBar addSubview:adScrollView];
    [self addTimer];
}

- (void)setupPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self.appBar addSubview:pageControl];
    pageControl.numberOfPages = self.imagesArray.count;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    CGFloat pageControlY = self.adScrollView.frame.size.height + self.adScrollView.frame.origin.y - 20;
    pageControl.center = CGPointMake(self.view.frame.size.width / 2, pageControlY);
    self.pageControl = pageControl;
}

//scrollView滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}
// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.tag == 1001) {
         [self removeTimer];
    }
   
}
//拖拽结束调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
      [self addTimer];
}

- (void)nextImage{
    int page = (int)self.pageControl.currentPage;
    if (page == self.imagesArray.count - 1) {
        page = 0;
    }
    else{
        page++;
    }
    CGFloat x = page * self.adScrollView.frame.size.width;
    self.adScrollView.contentOffset = CGPointMake(x, 0);
}
//开启定时器
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
//关闭定时器
- (void)removeTimer{
    [self.timer invalidate];
}

- (void)setAllButtons{
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"find_miaomiao",@"find_tips",@"find_takeout",@"find_bank",@"find_flight",@"find_film",@"find_add"];
    NSArray *nameArray = [NSArray array];
    nameArray = @[@"瞄瞄购",@"小费",@"外卖",@"银行",@"航班",@"电影",@" "];
    
    for (int i = 0; i < imageArray.count; i++) {
        int col = i % 3;
        int row = i / 3;
        CGFloat  btWidth = (MainWidth - 25 * 2 - 15 * 2) / 3.0;
        CGFloat  btHeight = btWidth;
        CGFloat  btX = 25 + col * (btWidth +15);
        CGFloat  btY = CGRectGetMaxY(self.adScrollView.frame) + 15 + row * (btWidth + 20 + 10);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btX, btY, btWidth, btHeight);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] withTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.appBar addSubview:button];
   }
}

- (void)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            //静音
            DLog(@"0");
        }
            break;
            
        case 1:{
            //免提
            DLog(@"1");
        }
            break;
            
        case 2:{
            //录音
            DLog(@"2");
        }
            break;
            
        case 3:{
            //回拨
            DLog(@"3");
        }
            break;
            
        case 4:{
            //挂断
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case 5:{
            //键盘
            DLog(@"5");
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
