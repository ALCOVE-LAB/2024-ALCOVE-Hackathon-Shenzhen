//
//  BaseTableViewCell.h
//  Gamfun
//
//  Created by mac on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

/// 创建Cell时候设置的cellIdentifier
+ (NSString *)cellIdentifier;

/// 计算cell高度 子类去实现
+ (CGFloat)rowHeightForObject:(id)object;

/// 通过代码初始化cell
+ (instancetype)initCellWithTableView:(UITableView *)tableView;

/// 根据数据更新cell的UI
- (void)updateWithCellData:(id)aData;

- (void)initialize;
- (void)setupViews;

@end

NS_ASSUME_NONNULL_END
