//
//  DeleteInfoView.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "DeleteInfoView.h"

@implementation DeleteInfoView

- (void)setupViews {
    self.backgroundColor = kWhiteColor;
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.layer.cornerRadius = 25;
    imageV.clipsToBounds = YES;
    [imageV loadImgUrl:kUserModel.headUrl placeholderImg:@"avatar_default"];
    [self addSubview:imageV];
    
    UILabel *nameLabel = [UILabel labelWithTextFont:kFontMedium(20) textColor:RGB(0x1B1B1B) text:kUserModel.nickName];
    [self addSubview:nameLabel];
    
    UILabel *idLabel = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x666666) text:[NSString stringWithFormat:@"ID:%@",kUserModel.userId]];
    [self addSubview:idLabel];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(50);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(imageV.mas_trailing).offset(14);
        make.top.equalTo(imageV);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nameLabel);
        make.bottom.equalTo(imageV);
    }];
}

@end
