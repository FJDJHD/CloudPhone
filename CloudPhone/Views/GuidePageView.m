//
//  GuidePageView.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "GuidePageView.h"
#import "Global.h"

static const CGFloat kMarkBackgroundViewWidth   = 150.0f;
static const CGFloat kStartButtonHeight         = 44.0f;

static const CGFloat kIconTopMarginScale        = 0.125f;

@interface GuidePageView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *markPageControl;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation GuidePageView

- (id)initWithImages:(NSArray *)imagesArray
{
    return [self initWithFrame:[[UIScreen mainScreen] bounds] andImages:imagesArray];
}

- (id)initWithImages:(NSArray *)imagesArray andMargin:(NSInteger)margin
{
    return [self initWithFrame:[[UIScreen mainScreen] bounds] andImages:imagesArray andMargin:margin];
}

- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imagesArray
{
    return [self initWithFrame:frame andImages:imagesArray andMargin:kIconTopMarginScale*frame.size.height];
}

- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imagesArray andMargin:(NSInteger)margin
{
    self = [self initWithFrame:frame];
    
    if (self) {
        _pageCount = imagesArray.count;
        
        UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:self.frame];
        bgimageView.image = [UIImage imageNamed:@"guide_bg.png"];
        [self addSubview:bgimageView];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [scrollView setContentSize:CGSizeMake(WIDTH(scrollView)*_pageCount, HEIGHT(scrollView))];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        for (int i=0; i<imagesArray.count; i++) {
            UIImage *pageImage = [imagesArray objectAtIndex:i];
            
            if (Is3_5Inches()) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(scrollView)*i+WIDTH(scrollView)/2-pageImage.size.width/2, 30, pageImage.size.width, pageImage.size.height)];
                [imageView setImage:pageImage];
                [scrollView addSubview:imageView];
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(scrollView)*i+WIDTH(scrollView)/2-pageImage.size.width/2, margin, pageImage.size.width, pageImage.size.height)];
                [imageView setImage:pageImage];
                [scrollView addSubview:imageView];
            }
        }
        
        self.markPageControl = [[UIPageControl alloc] init];
        _markPageControl.center = CGPointMake(WIDTH(scrollView)/2, HEIGHT(scrollView)-margin-kStartButtonHeight/2);
        _markPageControl.numberOfPages = _pageCount;
        _markPageControl.currentPage = 0;
        _markPageControl.pageIndicatorTintColor = RGBA(255*0.667, 255*0.667, 255*0.667, 1);
//        _markPageControl.currentPageIndicatorTintColor = XQBColorGreen;
        [self addSubview:_markPageControl];
        
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake((WIDTH(scrollView)-kMarkBackgroundViewWidth)/2+WIDTH(scrollView)*(_pageCount-1), HEIGHT(scrollView)-margin-kStartButtonHeight, kMarkBackgroundViewWidth, kStartButtonHeight);
        [_startButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_startButton setTitle:@"立 即 体 验" forState:UIControlStateNormal];
        [_startButton setTitleColor:RGB(75, 200, 160) forState:UIControlStateNormal];
        [_startButton.layer setCornerRadius:kStartButtonHeight/6];
        [_startButton.layer setBorderWidth:0.5];
        [_startButton.layer setBorderColor:[RGB(75, 200, 160) CGColor]];
        [scrollView addSubview:_startButton];
        
        if (_pageCount > 1) {
            _markPageControl.hidden = NO;
        } else {
            _markPageControl.hidden = YES;
        }
    }
    
    return self;
}

- (void)setStartButtonHidden:(BOOL)hidden
{
    _startButton.hidden = hidden;
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (1 < _pageCount) {
        if (WIDTH(scrollView)*(_pageCount-2) + ((WIDTH(scrollView) - kMarkBackgroundViewWidth)/4) <= scrollView.contentOffset.x) {
            if (!_startButton.hidden) {
                _markPageControl.hidden = YES;
            }
        } else {
            if (!_startButton.hidden) {
                _markPageControl.hidden = NO;
            }
        }
    }
    
    if (0 < scrollView.contentOffset.x && scrollView.contentOffset.x <= WIDTH(scrollView)*(_pageCount-1)) {
        _markPageControl.currentPage = scrollView.contentOffset.x/WIDTH(scrollView);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

@end
