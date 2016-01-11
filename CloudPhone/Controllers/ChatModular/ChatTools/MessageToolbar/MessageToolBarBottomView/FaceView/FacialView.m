/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "FacialView.h"
#import "Emoji.h"

#define EXPRESSION_SCROLL_VIEW_TAG 100

@interface FacialView ()<UIScrollViewDelegate> {
    
    //    UIScrollView *_bottomScrollView;
    UIPageControl *_pageCtrl;
    UIScrollView  *_pageScroll;
}

@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faces = [Emoji allEmoji];
    }
    return self;
}


//给faces设置位置
-(void)loadFacialView {
    
    NSInteger pageCount = 7;
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.tag = EXPRESSION_SCROLL_VIEW_TAG;
    _pageScroll = scrollView;
    _pageScroll.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*pageCount, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor =  [UIColor colorWithRed:240/255.0 green:242/255.0 blue:247/255.0 alpha:1];
    
    int row = 4;
    int column = 7;
    int number = 0;
    for (int p=0; p<pageCount; p++)
    {
        NSInteger page_X = p*scrollView.frame.size.width;
        for (int j=0; j<row; j++)
        {
            NSInteger row_y = 5+40*j;
            for (int i=0; i<column; i++)
            {
                NSInteger column_x = 20+40*i;
                if (number > 170)
                {
                    break;
                }
                
                if (j!=row-1 || i!=column-1)
                {
                    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(page_X+column_x, row_y, 40.0f, 30.0f)];
                    btn.tag = number;
                    btn.backgroundColor = [UIColor clearColor];
                    btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
                    [btn setTitle:[Emoji getExpressionById:number] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(putExpress:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    number++;
                }
            }
        }
        
        UIButton* delBtn = [[UIButton alloc] initWithFrame:CGRectMake(page_X+260.0f, 127.0f, 40.0f, 30.0f)];
        delBtn.backgroundColor = [UIColor clearColor];
        [delBtn setImage:[UIImage imageNamed:@"emoji_delete_pressed"] forState:UIControlStateHighlighted];
        [delBtn setImage:[UIImage imageNamed:@"emoji_delete"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(backspaceText:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:delBtn];
    }
    
    [self addSubview:scrollView];
    
    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(100.0f, self.frame.size.height-40.0f, 120.0f, 20.0f)];
    pageView.currentPageIndicatorTintColor = [UIColor blackColor];
    pageView.pageIndicatorTintColor = [UIColor grayColor];
    pageView.numberOfPages = pageCount;
    pageView.currentPage = 0;
    [pageView addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    _pageCtrl = pageView;
    [self addSubview:pageView];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.frame.size.width-65.0f, self.frame.size.height-35.0f, 60.0f, 30.0f);
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"common_resizable_blue_N"] stretchableImageWithLeftCapWidth:6 topCapHeight:15] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"common_resizable_blue_H"] stretchableImageWithLeftCapWidth:6 topCapHeight:15] forState:UIControlStateHighlighted];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(emojiSendBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backspaceText:(id)sender {
    if (_delegate) {
        [_delegate deleteSelected:nil];
    }
}

- (void)putExpress:(UIButton *)button {
    NSString *str = [Emoji getExpressionById:button.tag];
    if (_delegate) {
        [_delegate selectedFacialView:str];
    }
    
}


- (void)emojiSendBtn:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == EXPRESSION_SCROLL_VIEW_TAG)
    {
        //更新UIPageControl的当前页
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.frame;
        [_pageCtrl setCurrentPage:offset.x / bounds.size.width];
    }
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _pageScroll.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_pageScroll scrollRectToVisible:rect animated:YES];
}

//-(void)loadFacialView
//{
//    NSInteger totalCount = _faces.count;
//    NSInteger faceCount = 20; //一页20个表情
//
//	int maxRow = 4; //4行
//    int maxCol = 7; //一行7个
//    CGFloat itemWidth = self.frame.size.width / maxCol;
//    CGFloat itemHeight = self.frame.size.height / maxRow;
//
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setTitle:NSLocalizedString(@"发送", @"Send") forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [sendButton setFrame:CGRectMake((maxCol - 1) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight- 10)];
//    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
//    [sendButton setBackgroundColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0]];
//    [self addSubview:sendButton];
//
//    NSInteger pageCount = 0;
//    if (totalCount/faceCount == 0) {
//        pageCount = totalCount/faceCount;
//    } else {
//        pageCount = totalCount/faceCount + 1;
//    }
//
//    //表情滑动
//    _bottomScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0,self.frame.size.width, self.frame.size.height - itemHeight)];
//    _bottomScrollView.clipsToBounds = NO;
//    _bottomScrollView.pagingEnabled = YES;
//    _bottomScrollView.delegate = self;
//    _bottomScrollView.showsHorizontalScrollIndicator = NO;
//    _bottomScrollView.showsVerticalScrollIndicator = NO;
//    [_bottomScrollView setContentSize:CGSizeMake(pageCount * self.frame.size.width, self.frame.size.height - itemHeight)];
//    [self addSubview:_bottomScrollView];
//
//    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [deleteButton setBackgroundColor:[UIColor clearColor]];
//    [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 2) * itemHeight, itemWidth, itemHeight)];
//    [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
//    deleteButton.tag = 10000;
//    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomScrollView addSubview:deleteButton];
//
//    for (int row = 0; row < maxRow; row++) {
//        for (int col = 0; col < maxCol; col++) {
//            int index = row * maxCol + col;
//            if (index < 20) {//[_faces count]
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                [button setBackgroundColor:[UIColor clearColor]];
//                [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
//                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
//                [button setTitle: [_faces objectAtIndex:(row * maxCol + col)] forState:UIControlStateNormal];
//                button.tag = row * maxCol + col;
//                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
//                [_bottomScrollView addSubview:button];
//            }
//            else{
//                break;
//            }
//        }
//    }
//}
//
//
//-(void)selected:(UIButton*)bt
//{
//    if (bt.tag == 10000 && _delegate) {
//        [_delegate deleteSelected:nil];
//    }else{
//        NSString *str = [_faces objectAtIndex:bt.tag];
//        if (_delegate) {
//            [_delegate selectedFacialView:str];
//        }
//    }
//}
//
//- (void)sendAction:(id)sender
//{
//    if (_delegate) {
//        [_delegate sendFace];
//    }
//}

@end
