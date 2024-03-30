//
//  CompassViewController.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "CompassViewController.h"
#import "CompassView.h"

@interface CompassViewController ()

@property (nonatomic,strong) UILabel *compassDegreeLabel; // 指南针指向

@end

@implementation CompassViewController

- (void)setupViews {
    [super setupViews];
    
    self.navBackTitle = kLocalize(@"qibla");
    /// 指南针颜色配置
    NSDictionary *colorDic = @{@"longScaleColor":[UIColor colorWithHexString:@"#1B1B1B"],@"midScaleColor":[UIColor colorWithHexString:@"#1B1B1B"],@"shortScaleColor":[UIColor colorWithHexString:@"#8A8A8A"],@"degreeTextColor":[UIColor colorWithHexString:@"#1B1B1B"],@"directionTextColor":[UIColor colorWithHexString:@"#1B1B1B"]};
    CompassView *compassView = [[CompassView alloc] initWithFrame:CGRectMake(0, 0, 400, 400) configColor:colorDic];
    compassView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:compassView];
    @weakify(self);
    compassView.compassBlock = ^(float angle) {
        @strongify(self)
        self.compassDegreeLabel.text = [NSString stringWithFormat:@"%.0f°",angle];
    };
    
    // 指南针方向度数
    UILabel *compassDegreeLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:60 text:@"" superView:self.view];
    _compassDegreeLabel = compassDegreeLabel;
    
    // 国家
    UILabel *locationCityLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] font:16 text:[kUserDefaults valueForKey:kLocationCity] superView:self.view];
    
    [locationCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(compassDegreeLabel);
        make.top.equalTo(compassDegreeLabel.mas_bottom).offset(14);
    }];
    
    [compassDegreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(compassView.mas_bottom).offset(50);
    }];
    
    [compassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(400, 400));
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY).offset(-50);
    }];
}

@end
