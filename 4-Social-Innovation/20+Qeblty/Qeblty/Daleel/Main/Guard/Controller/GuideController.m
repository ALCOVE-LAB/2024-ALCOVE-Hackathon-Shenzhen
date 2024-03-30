//
//  GuideController.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GuideController.h"
#import "GuideView.h"

@interface GuideController ()<UIScrollViewDelegate>

@property (nonatomic,strong)GuideView *guideView;

@end

@implementation GuideController

- (void)setupViews {
    
    [AccountNetworkTool checkUpdateSuccess:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
       [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){

        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi){
            //高版本 第一次安装没有网络 创建游客处理
            [kUser firstInstalledAppForInitAcount];
            [self.view addSubview:self.guideView];
            [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_offset(0);
            }];
        }
    }];
}

#pragma mark --UI处理=============================================================
- (GuideView *)guideView {
    if(!_guideView){
        _guideView = [[GuideView alloc] init];
    }
    return _guideView;
}

@end
