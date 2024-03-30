//
//  RemindTimeSetTabView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindTimeSetTabView.h"
#import "RemindTimeSetCell.h"
#import "PrayerModel.h"
#import "PrayerViewModel.h"
#import "ToastTool.h"
@interface RemindTimeSetTabView ()

@property (nonatomic,strong)RemindTimeSetModel *remindTimeSetModel;
/// 标记选中的cell
@property (nonatomic,assign)NSInteger rowNum;

@property (nonatomic,strong)PrayerModel *prayerModel;
@property (nonatomic,strong)PrayerViewModel *prayerViewModel;
@property (nonatomic,assign)NSInteger selectRow;
@end

@implementation RemindTimeSetTabView

- (instancetype)initRemindTabViewWithViewModel:(PrayerViewModel *)prayerViewModel andWithFrame:(CGRect )frame andWithPrayerModel:(PrayerModel *)prayerModel andWithStyle:(UITableViewStyle )style {
    if (self = [super initWithFrame:frame style:style]) {
        self.prayerModel = prayerModel;
        self.prayerViewModel = prayerViewModel;
        [self dl_initialize];
        [self dl_bindViewModel];
    }
    return self;
}

- (void)dl_bindViewModel {
    @weakify(self);
    [[self.prayerViewModel.prayerTimeSetBeforeOrDelaySubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString  *_Nullable setStr) {
        @strongify(self);
        [ToastTool showToast:setStr];
        self.rowNum = self.selectRow;
        [self reloadData];
        if (self.remindTimeSetTabBlock) {
            self.remindTimeSetTabBlock(self.remindTimeSetModel.timeArr[self.selectRow]);
        }
    }];
}

- (void)dl_initialize {
    [super initialize];
    self.rowNum = 3;
}

- (RemindTimeSetModel *)remindTimeSetModel{
    if(!_remindTimeSetModel){
        _remindTimeSetModel = [[RemindTimeSetModel alloc] init];
    }
    return _remindTimeSetModel;
}

#pragma mark --代理处理区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.remindTimeSetModel.timeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 76.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 78.f)];
    headView.backgroundColor = UIColor.clearColor;
    UILabel *titleLB = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x999999) text:kLocalize(@"remind_time_select_tip")];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.numberOfLines = 0;
    [headView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-18);
        make.bottom.top.mas_equalTo(0);
    }];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RemindTimeSetCell *cell = [RemindTimeSetCell initCellWithTableView:tableView];
    if(self.rowNum >= 0 && indexPath.row == self.rowNum){
        self.remindTimeSetModel.isSelect = YES;
    }else{
        self.remindTimeSetModel.isSelect = NO;
    }
    [cell dl_getModel:self.remindTimeSetModel andWithTimeStr:self.remindTimeSetModel.timeArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *remindTimeStr = self.remindTimeSetModel.timeArr[indexPath.row];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.prayerModel.prayType forKey:@"prayerType"];
    [params setValue:remindTimeStr forKey:@"reminderTime"];
    [self.prayerViewModel.prayerTimeSetBeforeOrDelayCommand execute:params];
    self.selectRow = indexPath.row;
}

- (void)setRemindModel:(RemindModel *)remindModel {
    _remindModel = remindModel;
    for (int i = 0; i < self.remindTimeSetModel.timeArr.count; i++) {
        NSString *showStr = self.remindTimeSetModel.timeArr[i];
        if ([showStr isEqualToString:remindModel.remindTimeValue]) {
            self.rowNum = i;
        }
    }
}
@end
