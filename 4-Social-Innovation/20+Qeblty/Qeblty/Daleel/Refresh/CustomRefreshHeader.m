//
//  CustomRefreshHeader.m
//  sealLive
//
//  Created by apple on 2021/5/26.
//

#import "CustomRefreshHeader.h"
//#import <Lottie/Lottie.h>

@interface CustomRefreshHeader ()

//@property(nonatomic,strong)LOTAnimationView *loadingView;

@end

@implementation CustomRefreshHeader

- (instancetype)init {
    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
    }
    return self;
}
- (void)prepare {
    [super prepare];
    self.mj_h = 80;
}
- (void)placeSubviews {
    [super placeSubviews];
//    [self addSubview:self.loadingView];
}

//- (LOTAnimationView *)loadingView {
//    if (_loadingView == nil) {
//        _loadingView = [LOTAnimationView animationNamed:@"refresh"];
//        _loadingView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2.0) - 40, 0, 80, 80);
//        _loadingView.loopAnimation = YES;
//        _loadingView.contentMode = UIViewContentModeScaleAspectFill;
//        _loadingView.animationSpeed = 1.0;
//        _loadingView.loopAnimation = YES;
//    }
//    return _loadingView;
//}

- (void)beginRefreshing {
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
    [impactLight impactOccurred];
    [super beginRefreshing];
}
- (void)endRefreshing {
    [super endRefreshing];
}
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
//            [self.loadingView stop];
            break;
        case MJRefreshStatePulling:
//            self.loadingView.hidden = NO;
            break;
        case MJRefreshStateRefreshing:
//            self.loadingView.animationProgress = 0;
//            [self.loadingView play];
            break;
        default:
            break;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    CGPoint point;
//    id newVelue = [change valueForKey:NSKeyValueChangeNewKey];
//    [(NSValue *)newVelue getValue:&point];
//    self.loadingView.hidden = !(self.pullingPercent);
//    CGFloat progress = point.y / ([UIScreen mainScreen].bounds.size.height / 3.0);
//    if(self.state != MJRefreshStateRefreshing) {
//        self.loadingView.animationProgress = -progress;
//    }
}

@end
