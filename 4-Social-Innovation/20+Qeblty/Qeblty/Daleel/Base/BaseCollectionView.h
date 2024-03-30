//
//  BaseCollectionView.h
//  Gamfun
//
//  Created by mac on 2022/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) RACSubject *didClickCellSubject;

- (void)initialize;

- (void)creatNodataViewWithImageName:(NSString *_Nullable)imageName title:(NSString *)title withBtn:(NSString *_Nullable)btnStr;
@property (nonatomic, copy) void (^moreBtnBlock) (void);

/// 滑动距离回调
@property (nonatomic,copy) void(^scrollOffsetBlock)(CGPoint offset);

@end

NS_ASSUME_NONNULL_END
