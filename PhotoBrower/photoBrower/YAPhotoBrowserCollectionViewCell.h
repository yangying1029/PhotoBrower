//
//  PhotoBrowserCollectionViewCell.h
//  PhotoImageBrowserView
//
//  Created by 辰远 on 2018/9/4.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAPhotoBrowserCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
// 源坐标
@property (nonatomic,assign) CGRect originFrame;

@property (nonatomic,copy) void (^tapClickBlock) (void);
@property (nonatomic,copy) void (^longPressBlock) (void);



@end
