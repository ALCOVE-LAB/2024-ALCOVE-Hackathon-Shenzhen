//
//  NetworkComponent.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "NetworkComponent.h"

static NSTimeInterval kTimeOutInterval = 60.0f;
static AFHTTPSessionManager *_manager;

@implementation NetworkComponent

/// 单例AFHTTPSessionManager对象
+ (AFHTTPSessionManager *_Nonnull)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager =  [self managerWithBaseURL:nil sessionConfiguration:NO];
    });
    
    return _manager;
}

#pragma mark - 网络请求类
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
                                       failure:(RequestFailureBlock _Nullable)failure {
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
    NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:httpBody headers:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:failure];
    return dataTask;
}

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
                                      failure:(RequestFailureBlock _Nullable)failure {
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
    NSURLSessionDataTask *dataTask = [manager GET:urlString parameters:httpBody headers:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:failure];
    return dataTask;
}

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
                                         failure:(RequestFailureBlock _Nullable)failure {
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
    NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:httpBody headers:nil constructingBodyWithBlock:^(id <AFMultipartFormData>  _Nonnull formData) {
        [fileDataArr enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imageKey;
            NSString *fileName;
            if ([fileNames isKindOfClass:[NSArray class]] && fileNames.count > idx) {
                imageKey = fileNames[idx];
            }else {
                imageKey = [NSString stringWithFormat:@"file_%02ld",(long)idx + 1];
            }
            if (mimeType.intValue == 1) {
                fileName = [NSString stringWithFormat:@"%@.txt",imageKey];
            }else {
                fileName = [NSString stringWithFormat:@"%@.jpg",imageKey];
            }
            [formData appendPartWithFileData:obj name:imageKey fileName:fileName mimeType:@"text/plain"];
        }];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
//        id dict = [self responseConfiguration:responseObject];
        if (success) {
            success(task, responseObject);
        }
    } failure:failure];
    return dataTask;
}

#pragma mark - private
+ (AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL sessionConfiguration:(BOOL)isconfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = nil;
    NSURL *url;
    if (baseURL) {
        url = [NSURL URLWithString:baseURL];
    }
    
    if (isconfiguration) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    } else {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.operationQueue.maxConcurrentOperationCount = 4;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = response;
    /// 此方法用来删除value值为null的键值对
    response.removesKeysWithNullValues = YES;
    
    return manager;
}

/// https 证书需要服务端生成,转成cer格式
- (AFSecurityPolicy *)customSecurityPolicy {
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    /// allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO , 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    /**
     validatesDomainName 是否需要验证域名，默认为YES;
     假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
     置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
     如置为NO，建议自己添加对应域名的校验逻辑。
     */
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    return securityPolicy;
}

/// 配置httpHeader参数
+ (void)configRequestHttpHeader:(NSDictionary *)httpHeader {
    if ([httpHeader isKindOfClass:[NSDictionary class]]) {
        [httpHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [[self shareManager].requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
}


#pragma mark - 取消请求相关
/// 取消所有网络请求
+ (void)cancelAllRequest {
    [[self shareManager].operationQueue cancelAllOperations];
}

/// 取消注定url的请求
/// @param httpMethod 请求类型
/// @param urlString 完整的url
+ (void)cancelHttpRequestWithHttpMethod:(NSString *_Nonnull)httpMethod requestUrlString:(NSString *_Nonnull)urlString {
    [self cancelSameRequestWithMethod:httpMethod urlString:urlString httpBody:nil];
}

/// 取消指定url和请求参数的请求，包括网络慢时多次刷新的情况
/// @param httpMethod 请求类型
/// @param urlString 完整url
/// @param httpBody 请求参数
+ (void)cancelSameRequestWithMethod:(NSString *)httpMethod urlString:(NSString *)urlString httpBody:(NSDictionary *_Nullable)httpBody {
    //根据请求的类型、url以及请求参数创建一个NSURLRequest--通过该url和请求参数去匹配请求队列中的请求,如果有的话，就取消该请求
    NSURLRequest *designatedRequest = [[self shareManager].requestSerializer requestWithMethod:httpMethod URLString:urlString parameters:httpBody error:nil];
    for (NSOperation *operation in [self shareManager].operationQueue.operations) {
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            NSURLRequest *currentRequest = [(NSURLSessionTask *)operation currentRequest];
            //判断请求的类型和url匹配
            if ([httpMethod isEqualToString:currentRequest.HTTPMethod] && [designatedRequest.URL.path isEqualToString:currentRequest.URL.path]) {
                //判断请求的参数存在且请求体匹配
                if (httpBody && [designatedRequest.HTTPBody isEqualToData:currentRequest.HTTPBody]) {
                    [operation cancel];
                }else {
                    [operation cancel];
                }
            }
        }
    }
}

#pragma mark - 网络检测相关
/// 监控网络环境变化
+ (void)setReachabilityStatusChangeBlock:(void (^_Nullable)(AFNetworkReachabilityStatus status))block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:block];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
