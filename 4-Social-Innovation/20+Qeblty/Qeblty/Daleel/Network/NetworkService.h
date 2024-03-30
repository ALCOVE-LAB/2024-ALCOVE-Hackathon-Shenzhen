//
//  NetworkService.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>
#import "NetworkComponent.h"

/* HTTP请求类别 */
typedef NS_ENUM(NSInteger, HttpMethod) {
    HttpMethodGET,
    HttpMethodHEAD,
    HttpMethodPOST,
    HttpMethodPUT,
    HttpMethodPATCH,
    HttpMethodDELETE
};

NS_ASSUME_NONNULL_BEGIN

extern BOOL AppHasNetwork;
extern NSString *kHttpErrorReason;

typedef void(^SuccessBlock)(id  _Nullable responseObject);
typedef void(^FailureBlock)(NSError *_Nonnull error);
typedef void(^ProgresBlock)(NSProgress * _Nonnull progress);

/**
 common基础业务层面的网络管理
 */
@interface NetworkService : NSObject

/// 网络请求
/// @param urlString url
/// @param httpMethod 请求方式
/// @param parameters 参数
/// @param needEncryption 值为YES 加密请求
/// @param needExtraProcess 值为YES,原始返回response
/// @param success 成功
/// @param failure 失败
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
      needExtraProcess:(BOOL)needExtraProcess
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

/// 不加密网络请求,返回数据为已处理的数据 dic 或 array ,needExtraProcess 默认NO
/// @param urlString utl
/// @param httpMethod 请求方式
/// @param parameters 参数
/// @param success 成功
/// @param failure 失败
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

/// 网络请求,是否加密
/// @param urlString utl
/// @param httpMethod 请求方式
/// @param parameters 参数
/// @param needEncryption 值为YES 加密请求
/// @param success 成功
/// @param failure 失败
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

/// post网络请求,是否加密
/// @param urlString utl
/// @param parameters 参数
/// @param needEncryption 值为YES 加密请求
/// @param success 成功
/// @param failure 失败
+ (void)postWithUrl:(NSString *)urlString
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

/// post网络请求,是否加密
/// @param urlString utl
/// @param parameters 参数
/// @param needEncryption 值为YES 加密请求
/// @param needExtraProcess 值为YES，多业务逻辑处理
/// @param success 成功
/// @param failure 失败
+ (void)postWithUrl:(NSString *)urlString
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
      needExtraProcess:(BOOL)needExtraProcess
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;


/// 上传文件
/// @param urlString utl
/// @param parameters 参数
/// @param fileDataArr 文件数据数组
/// @param fileNames 文件名数组
/// @param mimeType 文件类型
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
+ (void)uploadWithURL:(NSString *)urlString
           parameters:(id _Nullable)parameters
             fileData:(NSArray *)fileDataArr
            fileNames:(NSArray *_Nullable)fileNames
             mimeType:(NSString *_Nullable)mimeType
             progress:(ProgresBlock)progress
              success:(SuccessBlock)success
              failure:(FailureBlock)failure;

/// 取消所有的网络请求
+ (void)cancelAllRequest;

/// 取消指定的url请求
+ (void)cancelHttpRequestWithHttpMethod:(HttpMethod)httpMethod requestUrlString:(NSString *)urlString;

/** 监控网络环境变化 */
+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;

@end

NS_ASSUME_NONNULL_END
