//
//  PrayerSettingController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerSettingController.h"
#import "PrayerSetTabView.h"

@interface PrayerSettingController ()

@property (nonatomic,strong)PrayerSetTabView *prayerSetTabView;

@end

@implementation PrayerSettingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.prayerSetTabView dl_getData];
}

- (void)initialize {
    self.title = kLocalize(@"prayer_setting");
    [self.view addSubview:self.prayerSetTabView];
}
#pragma mark --UI处理=============================================================

- (PrayerSetTabView *)prayerSetTabView {
    if(!_prayerSetTabView){
        _prayerSetTabView = [[PrayerSetTabView alloc] initWithFrame:CGRectMake(0, kHeight_NavBar, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _prayerSetTabView.showsVerticalScrollIndicator = NO;
        _prayerSetTabView.showsHorizontalScrollIndicator = NO;
    }
    return _prayerSetTabView;
}

@end
