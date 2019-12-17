//
//  ViewController.m
//  PhotoBrower
//
#define KSmallPhotoWidth ([UIScreen mainScreen].bounds.size.width - 65 * 2 - 10) / 3.0

#define KSmallPhotoHeight 65

#import "ViewController.h"
#import "YAPhotoBrowserView.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat statusBarHeight;
@property (nonatomic,strong) NSMutableArray *imageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i <= 4; i ++) {
        if (!self.imageArray) {
            self.imageArray = [NSMutableArray array];
        }
        
        [self.imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"0%d",i]]];
    }
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    if(@available(iOS 13.0, *)){
        _statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    }else {
        _statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    [self.view addSubview:_collectionView];
}


- (NSArray *)calculateImageOriginFrame {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSArray *sortedArray = [self.collectionView.visibleCells sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UICollectionViewCell *cell1  = (UICollectionViewCell *)obj1;
        UICollectionViewCell *cell2  = (UICollectionViewCell *)obj2;
        if ([self.collectionView indexPathForCell:cell1].row > [self.collectionView indexPathForCell:cell2].row) {
            return NSOrderedDescending;
        }else {
            return NSOrderedAscending;
        }
    }];
    
    [sortedArray enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect cellFrame = [cell.superview convertRect:cell.frame toView:nil];
        
        if(@available(iOS 13.0, *)){
            if ([UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.isStatusBarHidden) {
                cellFrame.origin.y = cellFrame.origin.y + self->_statusBarHeight;
            }
        }else {
            if ([UIApplication sharedApplication].isStatusBarHidden) {
                cellFrame.origin.y = cellFrame.origin.y + self->_statusBarHeight;
            }
        }
        
        [mutArray addObject:@(cellFrame)];
    }];
    return mutArray;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:imageView];
    imageView.image = self.imageArray[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YAPhotoBrowserView *photoBrowserView = [[YAPhotoBrowserView alloc] initWithFrame:[UIScreen mainScreen].bounds imageArray:self.imageArray];
    photoBrowserView.currentIndex = indexPath.row;
    photoBrowserView.targetVC = self;
    
    [photoBrowserView selectImageViewToVisbleWIthOriginFrameArray:[self calculateImageOriginFrame]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:photoBrowserView];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(KSmallPhotoWidth, KSmallPhotoHeight);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
@end
