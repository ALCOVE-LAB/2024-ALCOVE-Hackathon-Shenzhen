//
//  RemindCell.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindCell.h"
#import "PrayerModel.h"
#import "DownloadSoundManager.h"

@interface RemindCell ()
/// cell的美化背景
@property (nonatomic,strong)UIView *cellBgView;
/// cell选中时候的蒙版
@property (nonatomic,strong)UIView *cellSelectView;
/// 选中时候的对号
@property (nonatomic,strong)UIImageView *choiceImg;
/// 铃声的label
@property (nonatomic,strong)UILabel *soundLB;
/// 右面的箭头  只在第一租展示
@property (nonatomic,strong)UIImageView *rightArrow;
/// 分割线
@property (nonatomic,strong)UIView *lineV;

@property (nonatomic,strong)UIImageView *lockImg;

@end

@implementation RemindCell

-(void)setRemindModel:(RemindModel *)remindModel{
    _remindModel = remindModel;
    if (remindModel) {
        [self dl_cellRadius:self.cellBgView andWithRadiusTeger:remindModel.isRadiusTeger];
        self.choiceImg.hidden = self.cellSelectView.hidden = !remindModel.checkFlag.boolValue;
        self.rightArrow.hidden = !remindModel.isShowArrow;
        if (remindModel.unlockingFlag.boolValue) {
            self.lockImg.hidden = YES;
            if (self.remindModel.url && [self.remindModel.url containsString:@"http"]) {
                // 下载铃声  解锁成功之后下载铃声
                NSString *musicTemptr = [[remindModel.url componentsSeparatedByString:@"/"] lastObject];
                NSString *soundStr = [[musicTemptr componentsSeparatedByString:@"."] firstObject];
                NSString *musictr = [NSString stringWithFormat:@"%@.m4a",soundStr];
                if (![[DownloadSoundManager sharedInstance] judgeFileExist:musictr]) {
                    [[DownloadSoundManager sharedInstance] dl_beginDownLoadSoundsResourceWithUrl:self.remindModel.url andWithProgress:^(NSProgress * _Nonnull downloadProgress) {} andWithCallBack:^(NSString * _Nullable path, BOOL success) {}];
                } 
            }
        }else{
            self.lockImg.hidden = NO;
            if (remindModel.allowUnlock.boolValue) {
                [self.lockImg setImage:[UIImage imageNamed:@"prayer_remind_unlock"]];
            }else{
                [self.lockImg setImage:[UIImage imageNamed:@"prayer_remind_lock"]];
            }
        }
        if (!self.rightArrow.hidden) {
            self.lockImg.hidden = YES;
            self.soundLB.text = remindModel.remindTimeName;
        }else {
            self.soundLB.text = remindModel.name;
        }
    }
    
}

- (void)setupViews {
    
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
    }];
}

#pragma mark --UI标记

- (UIView *)cellBgView {
    if(!_cellBgView){
        _cellBgView = [[UIView alloc] init];
        _cellBgView.backgroundColor = UIColor.whiteColor;
        
        [_cellBgView addSubview:self.cellSelectView];
        [_cellBgView addSubview:self.choiceImg];
        [_cellBgView addSubview:self.soundLB];
        [_cellBgView addSubview:self.rightArrow];
        [_cellBgView addSubview:self.lockImg];
        [_cellBgView addSubview:self.lineV];
        
        [self.cellSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.choiceImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(19);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        [self.soundLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(57);
            make.centerY.mas_equalTo(0);
        }];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.trailing.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(5, 11));
        }];
        [self.lockImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(15, 20));
        }];
        [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(57);
            make.trailing.mas_equalTo(-20);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _cellBgView;
}

- (UIView *)cellSelectView {
    if(!_cellSelectView){
        _cellSelectView = [[UIView alloc] init];
        _cellSelectView.backgroundColor = [UIColor colorWithHexString:@"#FDF9F1"];
    }
    return _cellSelectView;
}

- (UIImageView *)choiceImg{
    if(!_choiceImg){
        _choiceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayer_remind_choice"]];
        _choiceImg.hidden = YES;
    }
    return _choiceImg;
}

- (UILabel *)soundLB {
    if(!_soundLB){
        _soundLB = [UILabel labelWithTextFont:kFont(16) textColor:[UIColor colorWithHexString:@"#1b1b1b"] text:@"None"];
    }
    return _soundLB;
}

- (UIImageView *)rightArrow {
    if(!_rightArrow){
        _rightArrow = [UIImageView imgViewWithImg:@"prayer_remindArrow" superView:self.contentView];
        if ([LanguageTool isArabic]) {
            _rightArrow.transform = CGAffineTransformRotate(_rightArrow.transform, M_PI);
        }
    }
    return _rightArrow;
}

- (UIView *)lineV{
    if(!_lineV){
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _lineV;
}

- (UIImageView *)lockImg {
    if(!_lockImg){
        _lockImg = [UIImageView imgViewWithImg:@"prayer_remind_lock" superView:self.cellBgView];
    }
    return _lockImg;
}

#pragma mark --切部分圆角方法
- (void)dl_cellRadius:(UIView *)radiusView andWithRadiusTeger:(NSInteger )radiusTeger{
    CGRect rect = CGRectMake(0, 0, kScreenWidth - 34, 56.f);
    UIBezierPath *maskPath = [self dl_getRadiusTeger:radiusTeger andWithRect:rect];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = rect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    radiusView.layer.mask = maskLayer;
}

#pragma mark --UIBezierPath 方法抽取
- (UIBezierPath *)dl_getRadiusTeger:(NSInteger )radiusTeger andWithRect:(CGRect )rect{
    if(radiusTeger == 0){
        self.lineV.hidden = NO;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12.f, 12.f)];
        return maskPath;
    }else if (radiusTeger == 1){
        self.lineV.hidden = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12.f, 12.f)];
        return maskPath;
    }else if (radiusTeger == 2){
        self.lineV.hidden = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight  cornerRadii:CGSizeMake(12.f, 12.f)];
        return maskPath;
    }else{
        self.lineV.hidden = NO;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(0.f, 0.f)];
        return maskPath;
    }
}
@end
