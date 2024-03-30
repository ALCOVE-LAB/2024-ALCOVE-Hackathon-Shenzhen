//
//  AccountSecurityTableView.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "AccountSecurityTableView.h"
#import "AccountTableViewCell.h"

@implementation AccountSecurityTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell = [AccountTableViewCell initCellWithTableView:tableView];
    NSDictionary *dic = self.dataArr[indexPath.section][indexPath.row];
    NSString *imageStr = [dic objectForKey:@"image"];
    NSString *title = [dic objectForKey:@"title"];
    BOOL isBind = [[dic objectForKey:@"isBind"] intValue];
    cell.imageV.hidden = (imageStr.length <= 0 || !isBind);
    cell.imageV.image = kImageName(imageStr);
    cell.titleLabel.text = title;
//    if (indexPath.section == 0) {
//        cell.bindLabel.hidden = isBind;
//    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    
    UILabel *label = [UILabel labelWithTextFont:kFontSemibold(14) textColor:RGB(0x666666)];
//    label.text = section == 0 ? kLocalize(@"account") : kLocalize(@"security");
    label.text = kLocalize(@"security");
    [v addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.leading.mas_equalTo(17);
    }];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}

@end
