//
//  AboutTableView.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "AboutTableView.h"
#import "AboutTableViewCell.h"

@implementation AboutTableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutTableViewCell *cell = [AboutTableViewCell initCellWithTableView:tableView];
    cell.leftLB.text = self.dataArr[indexPath.row];
    return cell;
}

@end
