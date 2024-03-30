//
//  PhoneLoginCountryCodeListPopupView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PhoneLoginCountryCodeListPopupView.h"
#import "PhoneCountryTableView.h"

@interface PhoneLoginCountryCodeListPopupView ()

@property (nonatomic,strong) PhoneCountryTableView *tableview;

@end

@implementation PhoneLoginCountryCodeListPopupView

- (void)setupPopupContentView {
    [super setupPopupContentView];
    self.onBlankClose = YES;
    self.backgroundEffect = PopupViewBgEffectStyle_cleanDark;
    
    UIView *bgView  = [UIView viewWithSuperView:self.popupContentView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView drawCornerRadius:16 withSize:CGSizeMake(self.popupContentView.width, kScreenHeight - (98 + kHeight_NavBar)) cornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:18 text:kLocalize(@"select_country_and_region") superView:bgView];
    
    UIImageView *closeImgv = [UIImageView imgViewWithImg:@"common_close" superView:self.popupContentView];
    @weakify(self);
    [closeImgv addTapAction:^{
        @strongify(self);
        [self close];
    }];
    
    PhoneCountryTableView *tableview = [[PhoneCountryTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [bgView addSubview:tableview];
    _tableview = tableview;
    [tableview.didClickCellSubject subscribeNext:^(NSIndexPath *x) {
        @strongify(self)
        PhoneCountryCodeGroupModel *groupModel = self.tableview.dataArr[x.section];
        PhoneCountryCodeModel *codeModel = groupModel.countrys[x.row];
        ExecBlock(self.selectCountryCode,codeModel);
        [self close];
    }];
    
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.leading.equalTo(bgView.mas_leading).offset(0);
        make.trailing.equalTo(bgView.mas_trailing).offset(0);
        make.bottom.equalTo(bgView.mas_bottom).offset(0);
    }];
    
    [closeImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.top.equalTo(bgView.mas_top).offset(17);
        make.trailing.equalTo(bgView.mas_trailing).offset(-17);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView.mas_top).offset(24);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popupContentView.mas_top).offset(98 + kHeight_NavBar);
        make.width.equalTo(@kScreenWidth);
        make.leading.equalTo(self.popupContentView.mas_leading).offset(0);
        make.bottom.equalTo(self.popupContentView.mas_bottom).offset(0);
    }];
}

- (void)setCountryCodeListData:(NSArray <PhoneCountryCodeGroupModel *>*)data {
    if(data.count <= 0) {return;}
    _tableview.dataArr = (NSMutableArray *)data;
    [_tableview reloadData];
}
@end
