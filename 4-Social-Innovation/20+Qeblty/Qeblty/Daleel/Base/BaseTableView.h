//
//  BaseTableView.h
//  Gamfun
//
//  Created by mac on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
/// 点击cell
@property (nonatomic, strong) RACSubject *didClickCellSubject;
@property (nonatomic, copy) void (^nodataTapBlock) (void);
/// 滑动距离回调
@property (nonatomic,copy) void(^scrollOffsetBlock)(CGPoint offset);

- (void)initialize;

- (void)creatNodataViewWithImageName:(NSString *_Nullable)imageName title:(NSString *)title;

- (void)removeCoverView;
@end

NS_ASSUME_NONNULL_END
