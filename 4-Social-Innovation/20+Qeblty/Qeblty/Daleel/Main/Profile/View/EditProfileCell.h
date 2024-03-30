//
//  EditProfileCell.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileCell : BaseTableViewCell

@property (nonatomic,assign)BOOL isHiddenLineV;
@property (nonatomic,strong)UILabel *leftLB;
@property (nonatomic,strong)UILabel *discrbLB;
@property (nonatomic,strong)UIImageView *rightArrowImg;
@property (nonatomic,strong)UIView *lineV;

@end

NS_ASSUME_NONNULL_END
