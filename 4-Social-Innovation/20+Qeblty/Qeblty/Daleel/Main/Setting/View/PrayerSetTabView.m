//
//  PrayerSetTabView.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "PrayerSetTabView.h"
#import "PrayerSetViewCell.h"
#import "PrayerViewModel.h"
#import "LocationManager.h"
#import "RemindPrayerController.h"

@interface PrayerSetTabView ()

@property (nonatomic,strong)PrayerViewModel *prayerViewModel;

@end

@implementation PrayerSetTabView

- (void)initialize {
    [super initialize];
    
    [self dl_bindViewModel];
}

- (void)dl_bindViewModel {
    @weakify(self);
    [[self.prayerViewModel.getPrayerListSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reloadData];
    }];
}

- (void)dl_getData {
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT;
    offset = offset / 3600;
    NSString *tzStr = [NSString stringWithFormat:@"%ld", (long)offset];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *latitudeStr = [kUserDefaults valueForKey:kLocationLatitude];
    NSString *longitudeStr = [kUserDefaults valueForKey:kLocationlongitude];
    [params setValue:latitudeStr forKey:@"lat"];
    [params setValue:longitudeStr forKey:@"lon"];
    [params setValue:tzStr forKey:@"timeZone"];
    [params setValue:kUser.userInfo.userId forKey:@"userId"];
    [self.prayerViewModel.getPrayerLogListCommand execute:params];
}


#pragma mark --代理处理区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.prayerViewModel.listArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrayerSetViewCell *cell = [PrayerSetViewCell initCellWithTableView:tableView];
    cell.prayerModel = self.prayerViewModel.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RemindPrayerController *remindPrayerController = [[RemindPrayerController alloc] initWithPrayerModel:self.prayerViewModel.listArray[indexPath.row] andWithViewModel:self.prayerViewModel andWithModelArr:self.prayerViewModel.listArray];
    [[UIViewController getCurrentViewController].navigationController pushViewController:remindPrayerController animated:YES];
}

#pragma mark --数据处理区域=============================================================
- (PrayerViewModel *)prayerViewModel {
    if(!_prayerViewModel){
        _prayerViewModel = [[PrayerViewModel alloc] init];
    }
    return _prayerViewModel;
}
@end
