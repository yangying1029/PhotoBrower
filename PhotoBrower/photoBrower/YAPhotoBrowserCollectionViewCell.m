//
//  PhotoBrowserCollectionViewCell.m
//  PhotoImageBrowserView
//
//  Created by 辰远 on 2018/9/4.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import "YAPhotoBrowserCollectionViewCell.h"

@implementation YAPhotoBrowserCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片底部的scrollView
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //单击手势
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fingerTapOnce:)];
        [_scrollView addGestureRecognizer:tapOnce];
        //双击手势
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fingerTapTwice:)];
        tapTwice.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:tapTwice];
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fingerLongPress:)];
        [_scrollView addGestureRecognizer:longPress];
        //优先tapTwice 如果没有检测到tapTwice 才让tapOnce生效
        [tapOnce requireGestureRecognizerToFail:tapTwice];
        [self.contentView addSubview:_scrollView];
        
        //图片展示
        _imageView = [[UIImageView alloc]initWithFrame:_scrollView.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"");
}

#pragma mark - 单击图片
- (void)fingerTapOnce:(UITapGestureRecognizer *)tapOnce
{
    if (_scrollView.zoomScale >= _scrollView.maximumZoomScale || _scrollView.zoomScale <= _scrollView.minimumZoomScale) {
        _scrollView.zoomScale = _scrollView.minimumZoomScale;
         if (_tapClickBlock) _tapClickBlock();
    }else {
        if (_tapClickBlock) _tapClickBlock();
    }
}

#pragma mark 双击图片
- (void)fingerTapTwice:(UITapGestureRecognizer *)tapTwice
{
    CGPoint touchPoint = [tapTwice locationInView:_scrollView];
    
    if (_scrollView.zoomScale == _scrollView.maximumZoomScale) {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    }else{
        [_scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 0.7, 0.7) animated:YES];
    }
}

#pragma mark 长按图片
- (void)fingerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (_longPressBlock) _longPressBlock();
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
@end
