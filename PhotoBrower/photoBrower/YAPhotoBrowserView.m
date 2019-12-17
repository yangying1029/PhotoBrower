//
//  PhotoBrowserView.m
//  PhotoImageBrowserView
//
//  Created by 辰远 on 2018/9/4.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import "YAPhotoBrowserView.h"
#import "YAPhotoBrowserCollectionViewCell.h"
#import "NSString+Check.h"
#import "UIView+FrameExtend.h"
@interface YAPhotoBrowserView ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 用于浏览的view
@property (nonatomic,strong) UICollectionView *collectionView;
// 用于显示的indexLabel
@property (nonatomic,strong) UILabel *indexLabel;
// 数据源
@property (nonatomic,strong) NSMutableArray *dataSource;
// 源坐标数组
@property (nonatomic,strong) NSArray *originFrameArray;
// 最后一次h拖动的cell
@property (nonatomic,weak) YAPhotoBrowserCollectionViewCell *lastDrggCell;

@end

@implementation YAPhotoBrowserView
- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)imageUrlArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        _currentIndex = 0;
        _dataSource = imageUrlArray.mutableCopy;
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        _currentIndex = 0;
        _dataSource = imageArray.mutableCopy;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[YAPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YAPhotoBrowserCollectionViewCell class])];
    [self addSubview:_collectionView];
    
    CGFloat y = self.frame.size.height - 20 - 10;
     if (@available(iOS 11.0, *)) {
         y = self.frame.size.height - 20 - 10 - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
     }
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 100) / 2, y, 100, 20)];
    _indexLabel.font = [UIFont systemFontOfSize:18];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    [self addSubview:_indexLabel];
}

- (void)selectImageViewToVisbleWIthOriginFrameArray:(NSArray *)originFrameArray {
    _originFrameArray = originFrameArray;
    __weak  typeof(self) weakSelf  = self;
    if (_currentIndex > self.dataSource.count - 1 || _currentIndex < 0) return ;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.collectionView layoutIfNeeded];
    YAPhotoBrowserCollectionViewCell *cell = (YAPhotoBrowserCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    cell.imageView.frame = [_originFrameArray[_currentIndex] CGRectValue];
//     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [weakSelf.targetVC prefersStatusBarHidden];
    
    __weak YAPhotoBrowserCollectionViewCell *weakCell = cell;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        cell.imageView.frame = [self setEnlargeImageViewFrameWithCell:cell];
    } completion:^(BOOL finished) {
       
    }];
    
//    [cell.imageView sd_setImageWithURL:[NSString isNull:_dataSource[_currentIndex]] ? nil : [NSURL URLWithString:_dataSource[_currentIndex]] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [UIView animateWithDuration:0.3 animations:^{
//            weakCell.imageView.frame = [weakSelf setEnlargeImageViewFrameWithCell:weakCell];
//        } completion:^(BOOL finished) {
//
//        }];;
//    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        cell.imageView.frame = [self setEnlargeImageViewFrameWithCell:cell];
//    } completion:^(BOOL finished) {
//
//    }];
    
    _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",_currentIndex + 1,_dataSource.count];
}


/**
 设置放大后imageView的尺寸

 */
- (CGRect)setEnlargeImageViewFrameWithCell:(YAPhotoBrowserCollectionViewCell *)cell {
    if (!cell.imageView.image) {
        cell.imageView.image = [UIImage imageNamed:@""];
    }
    CGFloat imgH = kScreenWidth / (cell.imageView.image.size.width/cell.imageView.image.size.height);
    CGRect imageViewFrame = CGRectMake(0, 0, kScreenWidth, imgH);
    
    //超出屏幕高度
    if (imgH >= kScreenHeight) {  //有一两个像素偏差
        cell.scrollView.contentSize = CGSizeMake(0, imgH);
    }else {//没超出屏幕
         cell.scrollView.contentSize = CGSizeMake(0, kScreenHeight);
        imageViewFrame = CGRectMake((self.width - imageViewFrame.size.width) / 2, (self.height - imageViewFrame.size.height) / 2, kScreenWidth, imgH);
    }
    return imageViewFrame;
}

- (void)refreshOriginFrameArray:(NSArray *)originFrameArray {
    _originFrameArray = originFrameArray;
}

#pragma mark --  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak  typeof(self) weakSelf  = self;
    YAPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YAPhotoBrowserCollectionViewCell class]) forIndexPath:indexPath];
    __weak YAPhotoBrowserCollectionViewCell *weakCell = cell;
    cell.imageView.image = self.dataSource[indexPath.row];
    cell.imageView.frame = [self setEnlargeImageViewFrameWithCell:cell];
//    [cell.imageView sd_setImageWithURL:[NSString isNull:_dataSource[indexPath.row]] ? nil : [NSURL URLWithString:_dataSource[indexPath.row]] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        weakCell.imageView.frame = [weakSelf setEnlargeImageViewFrameWithCell:weakCell];
//    }];
    
    // 单击图片
    cell.tapClickBlock = ^{
        [weakSelf.targetVC prefersStatusBarHidden];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        weakSelf.indexLabel.hidden = YES;
        if (weakSelf.currentIndex > self.dataSource.count) {// 大于显示的最大图片数
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                weakSelf.alpha = 0;
                weakSelf.transform = CGAffineTransformMakeScale(3, 3);
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock();
                }
            }];
        }else {// 在范围内
            if (weakSelf.currentIndex > weakSelf.dataSource.count - 1 || weakSelf.currentIndex < 0) return ;
            [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                weakSelf.collectionView.backgroundColor = [UIColor clearColor];
                weakCell.imageView.frame = [weakSelf.originFrameArray[weakSelf.currentIndex] CGRectValue];
            } completion:^(BOOL finished) {
                 [weakSelf removeFromSuperview];
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock ();
                }
            }];
        }
    };
    
    cell.longPressBlock = ^{
        [weakSelf showImageBrowserEditList];
    };
    return cell;
}

#pragma mark 长按弹出菜单
- (void)showImageBrowserEditList
{
    return ;
    // 判断数据源是否为空
//    if ([NSMutableArray isNull:_dataSource]) return;
//    
//    NSArray *optionArr = nil;
//    if (_isMyZone == YES) {
//        optionArr = @[@"保存照片",@"删除照片"];
//    }else{
//        optionArr = @[@"保存照片"];
//    }
    
//    [YZActionSheetView showAcionSheetWithCancelTitle:YALocalString(@"取消") otherTitles:optionArr clickBlock:^(NSInteger buttonIndex, NSString *buttonTitle) {
//
//        if (buttonIndex == 0) {
//            if (_currentIndex > _dataSource.count - 1 || _currentIndex < 0) return ;
//            YAPhotoBrowserCollectionViewCell *cell = (YAPhotoBrowserCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
//            NSData *imageData = UIImageJPEGRepresentation(cell.imageView.image, 0.1);
//            UIImage *image = [UIImage imageWithData:imageData];
//            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
//        }else if (buttonIndex == 1&&_isMyZone == YES){
//           if (_currentIndex > _dataSource.count - 1|| _currentIndex < 0) return ;
//
//            NSString *imgUrl = _dataSource[_currentIndex];
//            [YZZoneCacheOperate ya_deleteUserPhotosWithUrl:imgUrl success:^(NSString *path) {
//                if (_deleteImageBlock) _deleteImageBlock();
//                // 移除当前图片
//                [_dataSource removeObjectAtIndex:_currentIndex];
//                //如果没有图片了 直接返回
//                if ([NSMutableArray isNull:_dataSource]) {
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//                    [self removeFromSuperview];
//                    return;
//                }
//                //刷新表格
//                [_collectionView reloadData];
//
//                //刷新索引
//                _currentIndex = _collectionView.contentOffset.x/MAIN_SCREEN_WIDTH;
//                if (_dataSource.count == 1) {
//                    _currentIndex = 0;
//                    _indexLabel.hidden = YES;
//                }else{
//                    if (_currentIndex >= _dataSource.count - 1) _currentIndex = _dataSource.count - 1;
//                    _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", _currentIndex + 1,_dataSource.count];
//                }
//            } failure:^(NSString *msg) {
//                [YZDialogView ya_showDialog:msg];
//            }];
//        }
//    }];
}

#pragma mark 保存图片
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [YZDialogView ya_showDialog:YALocalString(@"保存失败")];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
        //保存最后一次拖动过的cell
        _lastDrggCell = (YAPhotoBrowserCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        NSInteger currentIndex = scrollView.contentOffset.x / self.frame.size.width;
        _currentIndex = currentIndex;
        _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",currentIndex + 1,_dataSource.count];
        //将放大过的cell复原
        YAPhotoBrowserCollectionViewCell *currentShowCell = (YAPhotoBrowserCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
        if (_lastDrggCell != currentShowCell) {
            if (_lastDrggCell.scrollView.zoomScale != _lastDrggCell.scrollView.minimumZoomScale) {
                [_lastDrggCell.scrollView setZoomScale:_lastDrggCell.scrollView.minimumZoomScale animated:NO];
            }
        }
    }
//    NSInteger visbleCount = ceil(3 * ((MAIN_SCREEN_HEIGHT - 64) / ([_originFrameArray.firstObject CGRectValue].size.height)));
//    if (visbleCount <= _originFrameArray.count) return;
//    if (_currentIndex >= _visbleLastIndex || _currentIndex <= _visbleFirstIndex) {
//        if (_refreshOriginFrameBlock) _refreshOriginFrameBlock(_currentIndex);
//    }
}

@end
