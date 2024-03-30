//
//  BadgesChildViewController.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BadgesChildViewController.h"
#import "AwardsNetworkTool.h"
#import "BadgesModel.h"
#import "CustomCollectionViewLayout.h"
#import "BadgesCollectionViewCell.h"
#import "CacheManager.h"

@interface BadgesChildViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CustomCollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation BadgesChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/// 初始化
- (void)initialize {
    self.view.backgroundColor = kClearColor;
    [self.collectionView registerClass:[BadgesCollectionViewCell class] forCellWithReuseIdentifier:[BadgesCollectionViewCell cellIdentifier]];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellIdentifier"];
    self.navigationBarBackgroundAlpha = 0;
    self.collectionView.scrollsToTop = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:kWearBadgeSuccess object:nil];
}
/// setupview
- (void)setupViews {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
    }];
}
/// 网络请求
- (void)requestData {
    // 取缓存显示
    NSArray *array =  [CacheManager getCacheWithKey:kBadgeListCacheKey];
    if (array.count == 0) {
        [ProgressHUD showHudInView:self.parentViewController.view];
    } else {
        self.dataList = [NSMutableArray arrayWithArray:array];
        [self.collectionView reloadData];
    }
    [AwardsNetworkTool getAwardsListWithUid:kUser.userInfo.userId success:^(id  _Nullable responseObject) {
        NSMutableArray <BadgesTypeListModel *> *awardsListArr = [BadgesTypeListModel mj_objectArrayWithKeyValuesArray:responseObject];
        [CacheManager setCacheObject:awardsListArr forKey:kBadgeListCacheKey];
        self.dataList = awardsListArr;
        [self.collectionView reloadData];
        [ProgressHUD hideHUD:self.parentViewController.view];
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUD:self.parentViewController.view];
        kToast(error.userInfo[kHttpErrorReason]);
    }];
}
#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BadgesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BadgesCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    BadgesTypeListModel *model = self.dataList[indexPath.section];
    [cell updateWithCellData:model.list[indexPath.row]];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataList.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    BadgesTypeListModel *model = self.dataList[section];
    return model.list.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        for (UIView *subView in headerView.subviews) {
            [subView removeFromSuperview];
        }
        BadgesTypeListModel *model = self.dataList[indexPath.section];
        UIView *view = [UIView new];
        view.backgroundColor = kWhiteColor;
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 16;
        view.frame = CGRectMake(0, 14, kScreenWidth - 34, 40);
        view.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        [headerView addSubview:view];
        
        UILabel *titleLabel = [UILabel labelWithTextFont:kFontSemibold(13) textColor:[UIColor colorWithHexString:@"#666666"] text:model.awardActivityCode];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(18);
            make.top.mas_equalTo(26);
            make.width.mas_equalTo(kScreenWidth - 18);
            make.height.mas_equalTo(15);
        }];
        reusableview = headerView;
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 40);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}
#pragma mark - AwardsCollectionViewLayoutDelegate
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [UIColor colorWithHexString:@"#FFFFFF"];
}

- (float)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cornerRadiusForSection:(NSInteger)section {
    return 16;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CustomCollectionViewLayout *layout = [[CustomCollectionViewLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.itemSize = CGSizeMake((kScreenWidth-100)/3, 140);
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 20, 15);
        UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView = collectionview;
        _collectionView.backgroundColor = kClearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        layout.customCollectionViewLayoutDelegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;

    }
    return _collectionView;
}
@end
