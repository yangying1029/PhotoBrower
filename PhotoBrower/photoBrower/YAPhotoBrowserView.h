//
//  PhotoBrowserView.h
//  PhotoImageBrowserView
//
//  Created by 辰远 on 2018/9/4.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import <UIKit/UIKit.h>

@interface YAPhotoBrowserView : UIView
// 当前的图片下标
@property (nonatomic,assign) NSInteger  currentIndex;

//@property (nonatomic,assign) NSInteger  visbleFirstIndex;

//@property (nonatomic,assign) NSInteger  visbleLastIndex;

@property (nonatomic, copy) void (^refreshOriginFrameBlock) (NSInteger currentIndex);

@property (nonatomic, copy) void (^deleteImageBlock) (void);

@property (nonatomic,copy) void (^dismissBlock) (void);

@property (nonatomic,weak) UIViewController *targetVC;

- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)imageUrlArray;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

- (void)selectImageViewToVisbleWIthOriginFrameArray:(NSArray *)originFrameArray;

- (void)refreshOriginFrameArray:(NSArray *)originFrameArray;
@end
