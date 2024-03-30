//
//  PhoneCountryTableView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PhoneCountryTableView.h"
#import "PhoneCountryCodeGroupModel.h"

@interface PhoneCountryCodeTableViewCell ()

@property(nonatomic,strong)UIImageView *flagImageV;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *codeLabel;

@end

@implementation PhoneCountryCodeTableViewCell

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.contentView addSubview:self.flagImageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.codeLabel];
    
    UIView *sepLine = [UIView viewWithSuperView:self.contentView];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.leading.equalTo(self.contentView.mas_leading).offset(51);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-37);
    }];
    
    [self.flagImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.width.height.mas_equalTo(24);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flagImageV);
        make.leading.mas_equalTo(self.flagImageV.mas_trailing).offset(8);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-37);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)updateWithCellData:(id)aData {
    PhoneCountryCodeModel *model = (PhoneCountryCodeModel *)aData;
     [self.flagImageV loadImgUrl:model.countryFlags];
    if(kIsAR){
        self.nameLabel.text = model.nameAr;
    }else{
        self.nameLabel.text = model.nameEn;
    }
    self.codeLabel.text = [NSString stringWithFormat:@"+%@",model.countryCode];
}

#pragma mark - lazyLoad
- (UIImageView *)flagImageV {
    if (!_flagImageV) {
        _flagImageV = [[UIImageView alloc] init];
        _flagImageV.image = [UIImage imageNamed:@"common_close"];
        _flagImageV.layer.cornerRadius = 12;
        _flagImageV.layer.masksToBounds = YES;
    }
    return _flagImageV;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTextFont:kFontMedium(14) textColor:[UIColor colorWithHexString:@"#1B1B1B"]];
    }
    return _nameLabel;
}
- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [UILabel labelWithTextFont:kFontMedium(14) textColor:[UIColor colorWithHexString:@"#666666"]];
    }
    return _codeLabel;
}
@end



@implementation PhoneCountryTableView

- (void)initialize {
    [super initialize];
    self.sectionIndexColor = [UIColor colorWithHexString:@"#666666"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhoneCountryCodeTableViewCell *cell = [PhoneCountryCodeTableViewCell initCellWithTableView:tableView];
    PhoneCountryCodeGroupModel *groupModel = self.dataArr[indexPath.section];
    PhoneCountryCodeModel *countryCodeModel = groupModel.countrys[indexPath.row];
    [cell updateWithCellData:countryCodeModel];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PhoneCountryCodeGroupModel *groupModel = self.dataArr[section];
    return groupModel.countrys.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
        view.backgroundColor = kPublicBgColor;
        PhoneCountryCodeGroupModel *groupModel = self.dataArr[section];
        UILabel *label = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#666666"] font:12 text:groupModel.countrysIndex superView:view];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.leading.equalTo(view.mas_leading).offset(20);
        }];
        return view;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *tempIndexArr = [NSMutableArray arrayWithCapacity:0];
    for (PhoneCountryCodeGroupModel *model in self.dataArr) {
        [tempIndexArr addObject:model.countrysIndex];
    }
    return tempIndexArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

@end
