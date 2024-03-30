//
//  RemindTimeSetView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindTimeSetView.h"
#import "RemindTimeSetTabView.h"
#import "PrayerModel.h"
#import "PrayerViewModel.h"
@interface RemindTimeSetView ()

@property (nonatomic,strong)UIView *tabBgView;
@property (nonatomic,strong)RemindTimeSetTabView *remindTimeSetTabView;
@property (nonatomic,strong)UIView *maskView;
/// 放弃按钮
@property (nonatomic,strong)UIButton *cancleBtn;

@property (nonatomic,strong)RemindModel *remindModel;
@property (nonatomic,strong)PrayerViewModel *prayerViewModel;
@property (nonatomic,strong)PrayerModel *prayerModel;
@end

@implementation RemindTimeSetView

- (void)dl_initialize {
    // 监听手势
    @weakify(self);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        if (self.remindTimeSetBlock) {
            self.remindTimeSetBlock(@"");
        }
    }];
    [self.maskView addGestureRecognizer:tapGesture];
}

- (instancetype)initRemindTimeSetViewWithViewModel:(PrayerViewModel *)prayerViewModel andWithFrame:(CGRect )frame andWithPrayerModel:(PrayerModel *)prayerModel {
    if (self == [super initWithFrame:frame]) {
        self.prayerViewModel = prayerViewModel;
        self.prayerModel = prayerModel;
        self.remindModel = prayerViewModel.firstRingModel;
        [self dl_setupViews];
        [self dl_initialize];
    }
    return self;
}

- (void)dl_setupViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.maskView];
    [self addSubview:self.tabBgView];
    [self addSubview:self.cancleBtn];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.bottom.mas_equalTo(-102);
        make.height.mas_equalTo(483);
    }];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.tabBgView);
        make.top.equalTo(self.tabBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(59);
    }];
}

- (UIView *)maskView {
    if(!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = RGB_ALPHA(0x000000, 0.6);
    }
    return _maskView;
}

- (UIView *)tabBgView {
    if(!_tabBgView){
        _tabBgView = [[UIView alloc] init];
        _tabBgView.backgroundColor = RGB(0xffffff);
        _tabBgView.layer.cornerRadius = 16.f;
        _tabBgView.layer.masksToBounds = YES;
        
        [_tabBgView addSubview:self.remindTimeSetTabView];
        [self.remindTimeSetTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tabBgView;
}

- (RemindTimeSetTabView *)remindTimeSetTabView{
    if(!_remindTimeSetTabView){
        _remindTimeSetTabView = [[RemindTimeSetTabView alloc] initRemindTabViewWithViewModel:self.prayerViewModel andWithFrame:self.tabBgView.bounds andWithPrayerModel:self.prayerModel andWithStyle:UITableViewStyleGrouped];
        _remindTimeSetTabView.scrollEnabled = NO;
        _remindTimeSetTabView.showsVerticalScrollIndicator = NO;
        _remindTimeSetTabView.showsHorizontalScrollIndicator = NO;
        _remindTimeSetTabView.remindModel = self.remindModel;
        @weakify(self);
        _remindTimeSetTabView.remindTimeSetTabBlock = ^(NSString * _Nonnull showStr) {
            @strongify(self);
            if (self.remindTimeSetBlock) {
                self.remindTimeSetBlock(showStr);
            }
        };
    }
    return _remindTimeSetTabView;
}

- (UIButton *)cancleBtn {
    if(!_cancleBtn){
        _cancleBtn = [UIButton buttonWithTitleFont:kFontSemibold(18) titleColor:RGB(0x3898E1) title:kLocalize(@"cancel")];
        _cancleBtn.backgroundColor = RGB(0xffffff);
        _cancleBtn.layer.cornerRadius = 16.f;
        _cancleBtn.layer.masksToBounds = YES;
        @weakify(self);
        [_cancleBtn addTapAction:^{
            @strongify(self);
            if (self.remindTimeSetBlock) {
                self.remindTimeSetBlock(@"");
            }
        }];
    }
    return _cancleBtn;
}

@end
