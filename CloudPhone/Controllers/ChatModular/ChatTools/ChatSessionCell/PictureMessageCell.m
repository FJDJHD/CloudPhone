//
//  PictureMessageCell.m
//  CloudPhone
//
//  Created by wangcong on 16/1/13.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "PictureMessageCell.h"
#import "MWPhotoBrowser.h"
#import "MessageViewController.h"

@interface PictureMessageCell() <MWPhotoBrowserDelegate>

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) UIViewController *tempController;

@end

@implementation PictureMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

- (void)cellForDataWithModel:(CellFrameModel *)model indexPath:(NSIndexPath *)indexPath controller:(UIViewController *)controller {
    
    [super cellForDataWithModel:model indexPath:indexPath controller:controller];
    
    self.tempController = controller;
  
    //赋值
    [self.buddleBtn setImage:self.messageModel.image forState:UIControlStateNormal];
    self.buddleBtn.imageView.layer.cornerRadius = 7.0;
    self.buddleBtn.imageView.layer.masksToBounds = YES;
}


//点击图片放大
- (void)buddleBtnClick:(UIButton *)sender {
    
    BuddleButton *tempButton = (BuddleButton *)sender;

    
    [self browserClickImage:tempButton.model.imagePath];
}

//放大图片
- (void)browserClickImage:(NSString *)path {
    
    _photos = [[NSMutableArray alloc]initWithCapacity:0];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSArray *arr = [NSArray arrayWithObject:image];
    [self showPhotoBrowser:arr index:0];
}

-(void)showPhotoBrowser:(NSArray*)imageArray index:(NSInteger)currentIndex{
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [MWPhoto photoWithImage:object];
            } else if ([object isKindOfClass:[NSURL class]]) {
                photo = [MWPhoto photoWithURL:object];
            } else if ([object isKindOfClass:[NSString class]]) {
                photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:object]];
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = NO;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    [photoBrowser setCurrentPhotoIndex:currentIndex];
    
    MessageViewController *tempControl = (MessageViewController *)self.tempController;
    tempControl.scrollType = ScrollStillType;
    [self.tempController.navigationController pushViewController:photoBrowser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count) {
        return self.photos[index];
    }
    return nil;
}


@end
