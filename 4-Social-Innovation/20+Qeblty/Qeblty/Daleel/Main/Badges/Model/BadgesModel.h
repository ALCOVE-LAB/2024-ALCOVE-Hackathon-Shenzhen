//
//  AwardsListModel.h
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BadgesDetailModel : BaseModel
/// 勋章获取状态 0未获取
@property (nonatomic,assign) BOOL achieveStatus;
/// 勋章介绍
@property (nonatomic,copy) NSString *awardDescribe;
/// 勋章id
@property (nonatomic,copy) NSString *awardId;
/// 勋章name
@property (nonatomic,copy) NSString *awardName;
/// 徽章长标题字段名称
@property (nonatomic,copy) NSString *awardDetailedName;
/// 勋章获取规则
@property (nonatomic,copy) NSString *awardRuleDescribe;
/// 勋章规则id
@property (nonatomic,assign) NSInteger awardRuleId;
/// 勋章获取规则name
@property (nonatomic,copy) NSString *awardRuleName;
/// 勋章未获得图片
@property (nonatomic,copy) NSString *awardUnAchievedUrl;
/// 勋章图片
@property (nonatomic,copy) NSString *awardUrl;
/// 勋章获取次数
@property (nonatomic,assign) NSInteger obtainTimes;
/// 勋章类型名称
@property (nonatomic,copy) NSString *awardActivityCode;
/// 勋章进度
@property (nonatomic,copy) NSString *progress;
/// 是否佩戴
@property (nonatomic, assign) BOOL wearingFlag;

/**U3D所需模型,贴图,法线等相关参数 , pt转px位置相关**/
/// 基础
@property (nonatomic, assign) NSInteger albedoMapId;
/// 自发光
@property (nonatomic, assign) NSInteger emissionMapId;
/// 金属
@property (nonatomic, assign) NSInteger metallicMapId;
/// 法线
@property (nonatomic, assign) NSInteger normalMapId;
/// 部件id
@property (nonatomic, assign) NSInteger partId;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, assign) NSInteger xPos;

@property (nonatomic, assign) NSInteger yPos;

@property (nonatomic, strong) NSString *getAwardDate;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, strong) NSString *shareTitle;

@property (nonatomic, strong) NSString *wearTitle;

@property (nonatomic, assign) NSInteger endyPos;

@property (nonatomic, strong) NSString *lastTimeLanguage;

@property (nonatomic, strong) NSString *achieveStatusMessage;

@property (nonatomic, assign) NSInteger modelIdTemp;

@property (nonatomic, assign) BOOL isTestServer;

@property (nonatomic, assign) BOOL arabicLanguage;

@end

/// 某一个类型的勋章Model
@interface BadgesTypeListModel : BaseModel
/// 勋章类型名称
@property (nonatomic,copy) NSString *awardActivityCode;
///  勋章列表
@property (nonatomic,strong) NSArray <BadgesDetailModel *> *list;

@end

/**
 勋章获取时间列表
 */
@interface BadgesGettenRecordDetail : BaseModel
@property (nonatomic,copy) NSString *actionRecord;
@property (nonatomic,copy) NSString *awardActivityCode;
@property (nonatomic,assign) NSInteger obtainPoints;
@property (nonatomic,copy) NSString *startTime;
@end

NS_ASSUME_NONNULL_END
