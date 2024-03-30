//
//  EditProfileTableView.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "EditProfileTableView.h"
#import "EditProfileCell.h"

@implementation EditProfileTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditProfileCell *cell = [EditProfileCell initCellWithTableView:tableView];
    cell.isHiddenLineV = indexPath.row == self.dataArr.count - 1;
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.leftLB.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    cell.discrbLB.text = [NSString stringWithFormat:@"%@",dic[@"detail"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}

@end
