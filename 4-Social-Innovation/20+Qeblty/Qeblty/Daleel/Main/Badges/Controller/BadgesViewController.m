//
//  BadgesViewController.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BadgesViewController.h"
#import "BadgesTopView.h"
#import "AwardsNetworkTool.h"
#import "BadgesModel.h"
#import "BadgesView.h"
#import "BadgesChildViewController.h"
#import "CacheManager.h"

@interface BadgesViewController ()

/// 顶部view
@property (nonatomic, strong) BadgesTopView *topView;
/// 总数
@property (nonatomic, strong) UIButton *totalButton;

@property (nonatomic, strong) BadgesView *badgesView;

@end

@implementation BadgesViewController
- (void)initialize {
    self.navigationBarBackgroundAlpha = 0;
    self.view.backgroundColor = kWhiteColor;
    self.title = kLocalize(@"badges_title");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:kWearBadgeSuccess object:nil];
}
- (void)setupViews {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.badgesView];
    @weakify(self);
    [self replaceNavBackActionWithAction:^{
        @strongify(self);
        [self popAction];
    }];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
    }];
    [self.badgesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    BadgesChildViewController *vc = [[BadgesChildViewController alloc] init];
    [self addChildViewController:vc];
    [self.badgesView addSubview:vc.view];
    
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.leading.trailing.bottom.equalTo(self.badgesView);
    }];
}
#pragma mark - 绑定新号
- (void)bindSignal {
    @weakify(self);
    // 佩戴
    self.topView.WearBadgeBlock = ^(BadgesDetailModel * _Nonnull model) {
        @strongify(self);
        [self wearBadgeWithAwardModel:model];
    };
}
/// 网络请求
- (void)requestData {
    // 取缓存显示
    NSArray *array = [CacheManager getCacheWithKey:kNewBadgesCacheKey];
    if (array.count == 0) {
        [ProgressHUD showHudInView:self.view];
    } else {
        self.topView.dataList = [NSMutableArray arrayWithArray:array];
        [self.totalButton setTitle:[NSString stringWithFormat:kLocalize(@"total"),[NSString stringWithFormat:@"%ld",array.count]] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.totalButton];
    }
    
    [AwardsNetworkTool getRecentAwardsListWithUid:kUser.userInfo.userId success:^(id  _Nullable responseObject) {
        NSMutableArray <BadgesDetailModel *> *awardsListArr = [BadgesDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
        BOOL flag = YES;
        if (awardsListArr.count == 3) {
            BOOL isHave = NO;
            //返回3个勋章时判断这3个勋章是否是已获得, 全未获得显示空白状态
            for (BadgesDetailModel *model in awardsListArr) {
                if (model.achieveStatus == 1) {
                    isHave = YES;
                    break;
                }
            }
            flag = isHave;
        }
        if (flag) {
            self.topView.dataList = awardsListArr;
            [CacheManager setCacheObject:[NSArray arrayWithArray:awardsListArr] forKey:kNewBadgesCacheKey];
            [self.totalButton setTitle:[NSString stringWithFormat:kLocalize(@"total"),[NSString stringWithFormat:@"%ld",awardsListArr.count]] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.totalButton];
        }else {
            self.topView.dataList = [NSMutableArray array];
            [self.totalButton setTitle:[NSString stringWithFormat:kLocalize(@"total"),@"0"] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.totalButton];
        }
        [ProgressHUD hideHUD:self.view];
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUD:self.view];
        kToast(error.userInfo[kHttpErrorReason]);
    }];
}
/// 佩戴
- (void)wearBadgeWithAwardModel:(BadgesDetailModel *)model {
    [ProgressHUD showHudInView:self.view];
    [AwardsNetworkTool wearAwardWithAwardId:model.awardId awardUrl:model.awardUrl success:^(id  _Nullable responseObject) {
        [ProgressHUD hideHUDForView:self.view];
        kToast(kLocalize(@"wear_medal_succeed"));
        kUserModel.awardUrl = model.awardUrl;
        model.wearingFlag = !model.wearingFlag;
        [[NSNotificationCenter defaultCenter] postNotificationName:kWearBadgeSuccess object:model];
        [[AccountManager sharedInstance] updateAndSaveUserinfo:kUserModel];
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUDForView:self.view];
        kToast(kLocalize(@"wear_medal_failed"));
    }];
}
- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    NSLog(@"didMove--%@--%@",parent,self);  //parent为nil，self有值
    if (!parent) {  //侧滑完成，做些其他事情
        NSLog(@"侧滑返回");
        
    }
}
#pragma mark - lazy load
- (BadgesTopView *)topView {
    if (!_topView) {
        _topView = [[BadgesTopView alloc] init];
    }
    return _topView;
}
- (UIButton *)totalButton {
    if (!_totalButton) {
        _totalButton = [UIButton buttonWithTitleFont:kFontMedium(13) titleColor:RGB(0x666666)];
        _totalButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [_totalButton setImage:kImageName(@"badges_total_icon") forState:UIControlStateNormal];
    }
    return _totalButton;
}
- (BadgesView *)badgesView {
    if (!_badgesView) {
        _badgesView = [[BadgesView alloc] init];
    }
    return _badgesView;
}
@end
