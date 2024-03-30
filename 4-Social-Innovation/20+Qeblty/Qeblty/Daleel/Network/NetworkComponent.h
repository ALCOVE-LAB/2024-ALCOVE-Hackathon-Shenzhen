//
//  NetworkComponent.h
//  Dallel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestSuccessBlock)(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject);
typedef void(^RequestFailureBlock)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error);
typedef void(^ProgressBlock)(NSProgress * _Nonnull progress);

/**
 网络请求组件
 */
@interface NetworkComponent : NSObject

/// 单例AFHTTPSessionManager对象
+ (AFHTTPSessionManager *_Nonnull)shareManager;

/// POST请求
/// @param urlString url路径
/// @param httpHeader header
/// @param httpBody 参数
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
+ (NSURLSessionDataTask *_Nullable)postWithUrl:(NSString *_Nonnull)urlString
                                    httpHeader:(NSDictionary * _Nullable)httpHeader
                                      httpBody:(NSDictionary *_Nullable)httpBody
                                      progress:(ProgressBlock _Nullable)progress
                                       success:(RequestSuccessBlock _Nullable)success
                                       failure:(RequestFailureBlock _Nullable)failure;

/// GET请求
/// @param urlString url路径
/// @param httpHeader header
/// @param httpBody 参数
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
+ (NSURLSessionDataTask *_Nullable)getWithUrl:(NSString *_Nonnull)urlString
                                   httpHeader:(NSDictionary * _Nullable)httpHeader
                                     httpBody:(NSDictionary *_Nullable)httpBody
                                     progress:(ProgressBlock _Nullable)progress
                                      success:(RequestSuccessBlock _Nullable)success
                                      failure:(RequestFailureBlock _Nullable)failure;

/// 上传文件
/// @param urlString url路径
/// @param httpHeader header
/// @param httpBody 参数
/// @param fileDataArr 文件
/// @param fileNames 文件名
/// @param mimeType 文件类型
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
+ (NSURLSessionDataTask *_Nullable)uploadWithURL:(NSString *_Nonnull)urlString
                                      httpHeader:(NSDictionary * _Nullable)httpHeader
                                        httpBody:(NSDictionary *_Nullable)httpBody
                                        fileData:(NSArray *_Nonnull)fileDataArr
                                       fileNames:(NSArray *_Nullable)fileNames
                                        mimeType:(NSString *_Nullable)mimeType
                                        progress:(ProgressBlock _Nullable)progress
                                         success:(RequestSuccessBlock _Nullable)success
                                         failure:(RequestFailureBlock _Nullable)failure;

/// 取消所有网络请求
+ (void)cancelAllRequest;

/// 取消注定url的请求
/// @param httpMethod 请求类型
/// @param urlString 完整的url
+ (void)cancelHttpRequestWithHttpMethod:(NSString *_Nonnull)httpMethod requestUrlString:(NSString *_Nonnull)urlString;

/// 取消指定url和请求参数的请求，包括网络慢时多次刷新的情况
/// @param httpMethod 请求类型
/// @param urlString 完整url
/// @param httpBody 请求参数
+ (void)cancelSameRequestWithMethod:(NSString *)httpMethod urlString:(NSString *)urlString httpBody:(NSDictionary *_Nullable)httpBody;

/// 监控网络环境变化
+ (void)setReachabilityStatusChangeBlock:(void (^_Nullable)(AFNetworkReachabilityStatus status))block;

@end

NS_ASSUME_NONNULL_END
