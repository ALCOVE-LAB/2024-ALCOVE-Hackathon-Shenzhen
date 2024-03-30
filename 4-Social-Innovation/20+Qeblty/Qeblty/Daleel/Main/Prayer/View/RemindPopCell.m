//
//  RemindPopCell.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindPopCell.h"
#import "PrayerModel.h"

@interface RemindPopCell ()

@property (nonatomic,strong)UIView  *selectView;
@property (nonatomic,strong)UILabel  *titleLB;
@property (nonatomic,strong)UIImageView  *choiceImg;
@property (nonatomic,strong)UIView  *lineV;

@end

@implementation RemindPopCell

#pragma mark --UI处理
/*******************************************UI处理***********************************************/
- (void)setupViews{
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.f);
    }];
}

- (UIView *)selectView{
    if(!_selectView){
        _selectView = [UIView viewWithSuperView:self.contentView];
        _selectView.backgroundColor = [UIColor colorWithHexString:@"#FDF9F1"];
        _selectView.hidden = YES;
    }
    return _selectView;
}

- (UILabel *)titleLB{
    if(!_titleLB){
        _titleLB = [UILabel labelWithTextFont:kFont(16) textColor:[UIColor colorWithHexString:@"#1b1b1b"] text:@"Asr"];
        _titleLB.backgroundColor = UIColor.clearColor;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        [_titleLB addSubview:self.choiceImg];
        [self.choiceImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.trailing.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
    }
    return _titleLB;
}

- (UIImageView *)choiceImg{
    if(!_choiceImg){
        _choiceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayer_remind_choice"]];
        _choiceImg.hidden = YES;
    }
    return _choiceImg;
}

- (UIView *)lineV{
    if(!_lineV){
        _lineV = [UIView viewWithSuperView:self.contentView];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _lineV;
}
/***********************************************************************************************/

#pragma mark --数据处理区域
/*****************************************数据区域************************************************/
- (void)dl_getModel:(RemindMorePopModel  *)remindMorePopModel andWithIndex:(NSInteger )index{
    NSString *lbStr = remindMorePopModel.detailDataArr[index];
    self.titleLB.text = kLocalize(lbStr.lowercaseString);
    self.choiceImg.hidden = self.selectView.hidden = !remindMorePopModel.isSelect;
}
/************************************************************************************************/
@end
