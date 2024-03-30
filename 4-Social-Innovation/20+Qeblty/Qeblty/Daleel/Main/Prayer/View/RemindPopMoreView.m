//
//  RemindPopMoreView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindPopMoreView.h"
#import "BaseTableView.h"
#import "RemindPopCell.h"
#import "PrayerModel.h"

@interface RemindPopMoreView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView  *maskView;
@property (nonatomic,strong)UIView  *tabBgView;
@property (nonatomic,strong)BaseTableView  *detailTabView;

@property (nonatomic,strong)RemindMorePopModel  *remindMorePopModel;
@property (nonatomic,assign)NSInteger  rowNum;
@end

@implementation RemindPopMoreView

#pragma mark --UI处理
/*******************************************UI处理***********************************************/

- (void)initialize {
    // 监听手势
    @weakify(self);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        NSString *topStr = self.prayerModel.prayType;
        if(self.remindPopMoreBlock){
            self.remindPopMoreBlock(topStr);
        }
    }];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)setPrayerModel:(PrayerModel *)prayerModel {
    _prayerModel = prayerModel;
    
    for (int i = 0; i < self.remindMorePopModel.detailDataArr.count; i++) {
        NSString *str = self.remindMorePopModel.detailDataArr[i];
        if([self.prayerModel.prayType isEqualToString:str]){
            self.rowNum = i;
        }
    }
     DLog(@"%ld",self.rowNum);
}

- (void)setupViews {
    
    self.rowNum = -1;
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.top.mas_equalTo(17 + kHeight_NavBar);
        make.height.mas_equalTo(354.f);
    }];
}

- (UIView *)maskView{
    if(!_maskView){
        _maskView = [UIView viewWithSuperView:self];
        _maskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    }
    return _maskView;
}

- (UIView *)tabBgView{
    if(!_tabBgView){
        _tabBgView = [UIView viewWithSuperView:self];
        _tabBgView.backgroundColor = [UIColor whiteColor];
        _tabBgView.layer.cornerRadius = 16.f;
        _tabBgView.layer.masksToBounds = YES;
        
        [_tabBgView addSubview:self.detailTabView];
        [self.detailTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tabBgView;
}

- (BaseTableView *)detailTabView{
    if(!_detailTabView){
        _detailTabView = [[BaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _detailTabView.backgroundColor = [UIColor clearColor];
        _detailTabView.dataSource = self;
        _detailTabView.delegate = self;
        _detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTabView.separatorColor = [UIColor clearColor];
        _detailTabView.sectionHeaderHeight = 0.01;
        _detailTabView.sectionFooterHeight = 0.01;
        _detailTabView.showsVerticalScrollIndicator = NO;
        _detailTabView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _detailTabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _detailTabView;
}

/***********************************************************************************************/

#pragma mark --数据处理区域
/*****************************************数据区域************************************************/
- (RemindMorePopModel *)remindMorePopModel{
    if(!_remindMorePopModel){
        _remindMorePopModel = [[RemindMorePopModel alloc] init];
    }
    return _remindMorePopModel;
}

/************************************************************************************************/

#pragma mark --代理处理区域
/******************************************代理处理**********************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.remindMorePopModel.detailDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemindPopCell *cell = [RemindPopCell initCellWithTableView:tableView];
    if(self.rowNum >= 0 && indexPath.row == self.rowNum){
        self.remindMorePopModel.isSelect = YES;
    }else{
        self.remindMorePopModel.isSelect = NO;
    }
    [cell dl_getModel:self.remindMorePopModel andWithIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.rowNum = indexPath.row;
    [self.detailTabView reloadData];
    NSString *topStr = self.remindMorePopModel.detailDataArr[indexPath.row];
    if(self.remindPopMoreBlock){
        self.remindPopMoreBlock(topStr);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]){
        return NO;
    }
    return YES;
}

/***********************************************************************************************/

@end
