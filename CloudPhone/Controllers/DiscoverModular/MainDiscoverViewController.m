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
@property (nonatomic, strong) UIScrollView *scrollView;
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
    [self setupScrollView];
    [self setupPageControl];
    [self setupAppBar];
}

- (void)setupScrollView {
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = STATUS_NAV_BAR_HEIGHT;
    CGFloat scrollViewH = 140;
    CGFloat scrollViewW = MainWidth;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.imagesArray.count * scrollViewW, -1);
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    [self setupImageView];
    [self.view addSubview:scrollView];
    [self addTimer];
}

- (void)setupPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:pageControl];
    pageControl.numberOfPages = self.imagesArray.count;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    CGFloat pageControlY = self.scrollView.frame.size.height + self.scrollView.frame.origin.y - 20;
    pageControl.center = CGPointMake(self.view.frame.size.width / 2, pageControlY);
    self.pageControl = pageControl;
}

- (void)setupImageView{
    CGFloat imageW = MainWidth;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    // 添加图片
    for (int i = 0; i < self.imagesArray.count; i++) {
        CGFloat imageX = i * imageW;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [imageView setImage:[UIImage imageNamed:self.imagesArray[i]]];
        [self.scrollView addSubview:imageView];
    }
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
    [self removeTimer];
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
    CGFloat x = page * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}
//开启定时器
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
//关闭定时器
- (void)removeTimer{
    [self.timer invalidate];
}

- (void)setupAppBar{
    
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"find_miaomiao",@"find_tips",@"find_takeout",@"find_bank",@"find_flight",@"find_film",@"find_add"];
    NSArray *nameArray = [NSArray array];
    nameArray = @[@"瞄瞄购",@"小费",@"外卖",@"银行",@"航班",@"电影",@" "];
    
    UIScrollView *appBar= [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), MainWidth, 300)];
    appBar.contentSize = CGSizeMake(0, 500);
    [self.view addSubview:appBar];

    
    for (int i = 0; i < imageArray.count; i++) {
        int col = i % 3;
        int row = i / 3;
        CGFloat  btWidth = (MainWidth - 25 * 2 - 15 * 2) / 3.0;
        CGFloat  btHeight = btWidth;
        CGFloat  btX = 25 + col * (btWidth +15);
        CGFloat  btY = 15 + row * (btWidth + 20 + 10);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btX, btY, btWidth, btHeight);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] withTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [appBar addSubview:button];
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
