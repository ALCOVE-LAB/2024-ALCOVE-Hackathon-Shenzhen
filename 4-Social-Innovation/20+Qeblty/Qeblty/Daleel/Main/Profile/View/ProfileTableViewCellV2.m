//
//  ProfileTableViewCellV2.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "ProfileTableViewCellV2.h"
#import "ProfileRecentBadgesCollectionView.h"
//#import "FragmentListProgressView.h"

@interface ProfileBadgeTableViewCell ()

@property (nonatomic,strong) ProfileRecentBadgesCollectionView *recentCollectionView;

@end

@implementation ProfileBadgeTableViewCell

- (void)setupViews {
    [super setupViews];
    ProfileRecentBadgesCollectionView *recentCollectionView = [ProfileRecentBadgesCollectionView getAwardsRecentCollectionView];
    recentCollectionView.layer.cornerRadius = 16;
    recentCollectionView.layer.masksToBounds = YES;
    recentCollectionView.backgroundColor = [UIColor whiteColor];
    recentCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
    [self.contentView addSubview:recentCollectionView];
    _recentCollectionView = recentCollectionView;
    @weakify(self);
    [recentCollectionView.didClickCellSubject subscribeNext:^(NSIndexPath *x) {
        @strongify(self);
        // 点击勋章
        AwardsRecentCollectionViewCell *cell = (AwardsRecentCollectionViewCell *)[self.recentCollectionView cellForItemAtIndexPath:x];
        // 计算点击位置
        CGRect rect = [self convertRect:cell.frame toView:[UIViewController getCurrentViewController].view];
        CGPoint clickPoint;
        if (kIsAR) {
            clickPoint = CGPointMake(kScreenWidth - CGRectGetMidX(rect), CGRectGetMidY(rect));
        }else {
            clickPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        }
        ExecBlock(self.badgeClick,x,clickPoint,self.recentCollectionView.dataArr[x.row]);
    }];
    
    [recentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.height.mas_equalTo(160);
        make.top.equalTo(self.contentView.mas_top).offset(0);
    }];
}

- (void)setRecentBadgesData:(NSArray<BadgesDetailModel *> *)data {
    _recentCollectionView.dataArr = (NSMutableArray *)data;
    [_recentCollectionView reloadData];
    [[_recentCollectionView viewWithTag:20230311] removeFromSuperview];
    if(data.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *nodataView = [self creatNoDataView];
            [self.recentCollectionView addSubview:nodataView];
            [nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.mas_leading).offset(0);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(self.contentView.width, self.contentView.height));
            }];
        });
    }
}

- (UIView *)creatNoDataView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    view.tag = 20230311;
    [view drawCornerRadius:16 withSize:_recentCollectionView.size cornerType:UIRectCornerAllCorners];
    
    UIImageView *imgV= [UIImageView imgViewWithImg:@"award_profile_empty_holder" superView:view];
    
    UILabel *label = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#999999"] font:11 text:kLocalize(@"profile_badge_havent_badges") superView:view];
    
    UIButton *btn = [UIButton buttonWithSuperView:view];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#FDF9F1"]];
    [btn setTitle:kLocalize(@"profile_badge_go_get_one") forState:UIControlStateNormal];
    [btn setTitleFont:[UIFont systemFontOfSize:10] titleColor:[UIColor colorWithHexString:@"#D9A53E"]];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#D9A53E"].CGColor;
    btn.layer.masksToBounds = YES;
    [btn addTapAction:^{
        [[UIViewController getCurrentViewController] popAnimated];
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kIsAR ? 105 : 84, 20));
        make.centerX.equalTo(view);
        make.bottom.equalTo(view.mas_bottom).offset(-18);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imgV.mas_bottom).offset(2);
    }];
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 96));
    }];
    return view;
}

@end


