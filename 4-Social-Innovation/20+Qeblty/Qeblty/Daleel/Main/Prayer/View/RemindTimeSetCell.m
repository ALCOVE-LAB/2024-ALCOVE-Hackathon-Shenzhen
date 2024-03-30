//
//  RemindTimeSetCell.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindTimeSetCell.h"
#import "PrayerModel.h"

@interface RemindTimeSetCell ()

@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,strong)UIImageView *choiceImg;
@property (nonatomic,strong)UILabel *centerTitleLB;
@property (nonatomic,strong)UIView *lineV;
@end

@implementation RemindTimeSetCell

- (void)dl_getModel:(RemindTimeSetModel *)remindTimeSetModel andWithTimeStr:(NSString *)timeStr {
    NSString *useTimeStr;
    if (timeStr.integerValue > 0) {
        useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind"),timeStr.integerValue];
        if (timeStr.integerValue > 11) {
            useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind_more"),timeStr.integerValue];
        }
    } else if (timeStr.integerValue == 0) {
        useTimeStr = kLocalize(@"remind_on_time");
    } else {
        useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind"),labs(timeStr.integerValue)];
        if (labs(timeStr.integerValue) > 11) {
            useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind_more"),labs(timeStr.integerValue)];
        }
    }
    
    self.centerTitleLB.text = useTimeStr;
    self.choiceImg.hidden = self.selectView.hidden = !remindTimeSetModel.isSelect;
}

- (void)setupViews {
    
    [self.contentView addSubview:self.selectView];
    [self.contentView addSubview:self.choiceImg];
    [self.contentView addSubview:self.centerTitleLB];
    [self.contentView addSubview:self.lineV];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.choiceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    [self.centerTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (UIView *)selectView {
    if(!_selectView){
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = RGB(0xFDF9F1);
    }
    return _selectView;
}

- (UIImageView *)choiceImg{
    if(!_choiceImg){
        _choiceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayer_remind_choice"]];
    }
    return _choiceImg;
}

- (UILabel *)centerTitleLB {
    if(!_centerTitleLB){
        _centerTitleLB = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x1b1b1b) text:[NSString stringWithFormat:kLocalize(@"minutes_ahead_remind"),@"5"]];
        _centerTitleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _centerTitleLB;
}

- (UIView *)lineV {
    if(!_lineV){
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = RGB(0xeeeeee);
    }
    return _lineV;
}

@end
