//
//  DailNumberCell.m
//  CloudPhone
//
//  Created by wangcong on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "DailNumberCell.h"

@implementation DailNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *dailImg = [UIImage imageNamed:@"点点看_10.png"];
        
        CGRect dailImageFrame = CGRectMake(15, (60 -dailImg.size.height)/2.0 , dailImg.size.width, dailImg.size.height);
        _dailImageView = [[UIImageView alloc]initWithImage:dailImg];
        _dailImageView.frame = dailImageFrame;
        [self addSubview:_dailImageView];
        
//        //主标题
//        CGRect titleLableFrame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10,CGRectGetMinY(_iconImageView.frame)+ 5, lableWidth, 20);
//        _titleLable = [[UILabel alloc]initWithFrame:titleLableFrame];
//        _titleLable.text = @"福鼎市你分开多福鼎市你分开多福鼎市你分开多";
//        _titleLable.font = [UIFont systemFontOfSize:14.0];
//        _titleLable.textColor = appDeepLableColor;
//        [self addSubview:_titleLable];
        
    }
    return self;
}

@end
