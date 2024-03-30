//
//  RemindPrayerController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindPrayerController.h"
#import "RemindPopMoreView.h"
#import "PrayerModel.h"
#import "RemindView.h"
#import "PrayerViewModel.h"
#import "AVAudioManager.h"
@interface RemindPrayerController ()

@property (nonatomic,strong)RemindPopMoreView *remindPopMoreView;
@property (nonatomic,strong)RemindView *remindView;
/// 用于传递到remind视图中最上面的选项
@property (nonatomic,strong)PrayerModel *prayerModel;
/// 传递ViewModel
@property (nonatomic,strong)PrayerViewModel *prayerViewModel;

@property (nonatomic,strong)NSArray *modelArr;

@property (nonatomic,strong) UIButton *titleBtn;
@end

@implementation RemindPrayerController

- (instancetype)initWithPrayerModel:(PrayerModel *)prayerModel andWithViewModel:(PrayerViewModel *)viewModel andWithModelArr:(NSArray<PrayerModel *> *)modelArr {
    if (self = [self init]) {
        self.prayerViewModel = viewModel;
        self.prayerModel = prayerModel;
        self.modelArr = modelArr;
        [self dl_setupViews];
    }
    return self;
}

/// 离开界面的时候  播放的音乐停止
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[AVAudioManager sharedInstance] dl_soundStop];
}

#pragma mark -- UI处理
- (void)dl_setupViews {
    @weakify(self);
    self.titleBtn = [self addTitleButtonWithTitle:@"Asr" tapAction:^{
        @strongify(self);
        [self dl_creatRemindMorePopViewWithButton:self.titleBtn];
    }];
    [self.titleBtn setTitleFont:kFontSemibold(18) titleColor:[UIColor blackColor]];
    [self.titleBtn setImage:kImageName(@"prayer_remind_DropDown") forState:UIControlStateNormal];
    [self.titleBtn setImage:kImageName(@"prayer_remind_DropUp") forState:UIControlStateSelected];
    [self.titleBtn setTitle:[NSString stringWithFormat:@"%@   ", self.prayerModel.prayType] forState:UIControlStateNormal];
    self.titleBtn.backgroundColor = [UIColor clearColor];
    [self.titleBtn sizeToFit];
    [self.titleBtn setImagePositionWithType:ImagePositionTypeRight spacing:0];
    
    
    [self.view addSubview:self.remindView];
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
}

- (RemindPopMoreView *)remindPopMoreView {
    if(!_remindPopMoreView){
        _remindPopMoreView = [[RemindPopMoreView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _remindPopMoreView;
}

- (RemindView *)remindView{
    if(!_remindView){
        _remindView = [[RemindView alloc] initRemindViewWithModel:self.prayerModel andWithViewModel:self.prayerViewModel];
        @weakify(self);
        _remindView.remindViewBlock = ^(RemindModel * _Nonnull remindModel) {
            @strongify(self);
            remindModel.prayType = self.prayerModel.prayType;
            if (self.remindPrayerVCBlock) {
                self.remindPrayerVCBlock(remindModel);
            }
        };
    }
    return _remindView;
}

- (void)dl_creatRemindMorePopViewWithButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        RemindPopMoreView *remindPopMoreView = [[RemindPopMoreView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        remindPopMoreView.prayerModel = self.prayerModel;
        @weakify(self);
        remindPopMoreView.remindPopMoreBlock = ^(NSString * _Nonnull topStr) {
            @strongify(self);
            for (int i = 0; i < self.modelArr.count; i++) {
                PrayerModel *model = self.modelArr[i];
                if ([model.prayType isEqualToString:topStr]) {
                    self.prayerModel = model;
                    self.remindView.prayerModel = model;
                }
            }
            sender.selected = NO;
            // 设置导航栏title
            [sender setTitle:[NSString stringWithFormat:@"%@   ",topStr] forState:UIControlStateNormal];
            [sender sizeToFit];
            [sender setImagePositionWithType:ImagePositionTypeRight spacing:0];
            
            [self.remindPopMoreView removeFromSuperview];
            self.remindPopMoreView = nil;
            /// 更换上面的title 请求接口
            [self.remindView dl_getCommondWithType:topStr];
        };
        [self.view addSubview:remindPopMoreView];
        self.remindPopMoreView = remindPopMoreView;
    }else{
        [self.remindPopMoreView removeFromSuperview];
        self.remindPopMoreView = nil;
    }
}


- (NSArray *)modelArr {
    if(!_modelArr){
        _modelArr = [NSArray array];
    }
    return _modelArr;
}
@end
