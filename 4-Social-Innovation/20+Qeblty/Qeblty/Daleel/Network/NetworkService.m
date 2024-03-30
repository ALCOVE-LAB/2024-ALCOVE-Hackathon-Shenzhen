//
//  NetworkService.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "NetworkService.h"
#import "AESTool.h"

BOOL AppHasNetwork = YES;
NSString *kHttpErrorReason = @"httpError";

@implementation NetworkService

/// 不加密网络请求,返回数据为已处理的数据 dic 或 array ,needExtraProcess 默认NO 默认不加密
/// @param urlString utl
/// @param httpMethod 请求方式
/// @param parameters 参数
/// @param success 成功
/// @param failure 失败
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
               success:(nonnull SuccessBlock)success
               failure:(nonnull FailureBlock)failure {
    [self requestWithUrl:urlString httpMethod:httpMethod parameters:parameters needEncryption:NO needExtraProcess:NO success:success failure:failure];
}

/// 网络请求,返回数据为已处理的数据 dic 或 array
/// @param urlString utl
/// @param httpMethod 请求方式
/// @param parameters 参数
/// @param success 成功
/// @param failure 失败
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
               success:(SuccessBlock)success
               failure:(FailureBlock)failure {
    [self requestWithUrl:urlString httpMethod:httpMethod parameters:parameters needEncryption:needEncryption needExtraProcess:NO success:success failure:failure];
}

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
               failure:(FailureBlock)failure {
    [self requestWithUrl:urlString httpMethod:HttpMethodPOST parameters:parameters needEncryption:needEncryption needExtraProcess:NO success:success failure:failure];
}

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
            failure:(FailureBlock)failure {
    [self requestWithUrl:urlString httpMethod:HttpMethodPOST parameters:parameters needEncryption:needEncryption needExtraProcess:needExtraProcess success:success failure:failure];
}

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
               success:(nonnull SuccessBlock)success
               failure:(nonnull FailureBlock)failure {
    NSDictionary *httpHeader = [self builderHttpHeader];
    NSDictionary *httpBody = [self parametersConfig:parameters needEncryption:needEncryption];
    [self requestLogPrint:urlString httpHeader:httpHeader parameters:parameters];
    [self httpRequestWithUrl:urlString httpMethod:httpMethod httpHeader:httpHeader httpBody:httpBody progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [self responseConfiguration:responseObject encrypt:needEncryption];
        [self responseLogPrint:task.response.URL.absoluteString responseData:responseObject];
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self requestFailureWithMsg:nil code:-1 block:failure];
            return;
        }
        if (needExtraProcess) {
            if (success) {
                success(responseObject);
            }
        }else {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if (dic[@"code"] == nil) {
                if (success) {
                    success(dic[@"result"]);
                }
                return;
            }
            int code = [dic[@"code"] intValue];
            if (code == 200) {
                if (success) {
                    success(dic[@"result"]);
                }
            } else {
                [self requestFailureWithMsg:dic[@"message"] code:code block:failure];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorLogPrint:error];
        NSError *bitchError = [self errorInfoHandle:error];
        if (bitchError.code == 401) {
            /// 判断是否登录,token过期刷新token
            [kUser refreshTokenSuccess:nil failure:nil];
//            if (failure) {
//                failure(bitchError);
//            }
        }else {
            if (failure) {
                failure(bitchError);
            }
        }
    }];
}

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
             progress:(nonnull ProgresBlock)progress
              success:(nonnull SuccessBlock)success
              failure:(nonnull FailureBlock)failure {
    NSDictionary *httpHeader = [self builderHttpHeader];
    NSDictionary *httpBody = [self parametersConfig:parameters needEncryption:NO];
    [self requestLogPrint:urlString httpHeader:httpHeader parameters:parameters];
    [NetworkComponent uploadWithURL:urlString
                         httpHeader:httpHeader
                           httpBody:httpBody
                           fileData:fileDataArr
                          fileNames:fileNames
                           mimeType:mimeType
                           progress:progress
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                responseObject = [self responseConfiguration:responseObject encrypt:NO];
                                [self responseLogPrint:task.response.URL.absoluteString responseData:responseObject];
                                
                                if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                    [self requestFailureWithMsg:nil code:-1 block:failure];
                                    return;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                int code = [dic[@"code"] intValue];
                                if (code == 200) {
                                    if (success) {
                                        success(dic[@"result"]);
                                    }
                                }else {
                                    [self requestFailureWithMsg:dic[@"message"] code:code block:failure];
                                }
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self errorLogPrint:error];
                                
                                NSError *bitchError = [self errorInfoHandle:error];
                                if (error.code == 401) {
                                    [kUser refreshTokenSuccess:nil failure:nil];
//                                    if (failure) {
//                                        failure(bitchError);
//                                    }
                                }else {
                                    if (failure) {
                                        failure(bitchError);
                                    }
                                }
                            }];
}

+ (void)httpRequestWithUrl:(NSString *)urlString
                httpMethod:(HttpMethod)httpMethod
                httpHeader:(NSDictionary *)httpHeader
                  httpBody:(NSDictionary *)httpBody
                  progress:(void (^)(NSProgress *))progress
                   success:(RequestSuccessBlock)success
                   failure:(RequestFailureBlock)failure {
    switch(httpMethod){
        case HttpMethodGET:
            [NetworkComponent getWithUrl:urlString httpHeader:httpHeader httpBody:httpBody progress:progress success:success failure:failure];
            break;
        case HttpMethodPOST:
            [NetworkComponent postWithUrl:urlString httpHeader:httpHeader httpBody:httpBody progress:progress success:success failure:failure];
            break;
        case HttpMethodPUT:
            break;
        case HttpMethodDELETE:
            break;
        case HttpMethodHEAD:
            break;
        case HttpMethodPATCH:
            break;
        default:
            break;
    }
}

/// 取消所有的网络请求
+ (void)cancelAllRequest {
    [NetworkComponent cancelAllRequest];
}

/// 取消指定的url请求
+ (void)cancelHttpRequestWithHttpMethod:(HttpMethod)httpMethod requestUrlString:(NSString *)urlString {
    NSString *requestType = [NSString string];
    switch (httpMethod) {
        case HttpMethodGET:
            requestType = @"GET";
            break;
        case HttpMethodHEAD:
            requestType = @"HEAD";
            break;
        case HttpMethodPOST:
            requestType = @"POST";
            break;
        case HttpMethodPUT:
            requestType = @"PUT";
            break;
        case HttpMethodPATCH:
            requestType = @"PATCH";
            break;
        case HttpMethodDELETE:
            requestType = @"DELETE";
            break;
    }
    [NetworkComponent cancelHttpRequestWithHttpMethod:requestType requestUrlString:urlString];
}

/** 监控网络环境变化 */
+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block {
    [NetworkComponent setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *notifyMessage = nil;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                notifyMessage = kLocalize(@"Network connection failed, please try again later");
                AppHasNetwork = NO;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                notifyMessage = kLocalize(@"Network is not available, please check the network!");
                AppHasNetwork = NO;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                AppHasNetwork = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                AppHasNetwork = YES;
                break;
        }
        
        if (block) {
            block(status);
        }
    }];
}

#pragma mark - 请求头、请求体的参数处理、加密及签名
/// 生成HttpHeader参数
+ (NSDictionary *)builderHttpHeader {
    NSMutableDictionary *sysInfoDic = [[NSMutableDictionary alloc] init];
    if (kUser.userInfo.token.length > 10) {
        sysInfoDic[@"Authorization"] = kUser.userInfo.token;
    }
    [sysInfoDic setObject:[DeviceTool appVersion] forKey:@"version"];
    [sysInfoDic setObject:@"IOS" forKey:@"platform"];
    [sysInfoDic setObject:[LanguageTool currentLanguageName] forKey:@"Accept-Language"];
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT / 3600;
    [sysInfoDic setObject:[NSString stringWithFormat:@"%ld", offset] forKey:@"timeZone"];
    return sysInfoDic;
}

/// 生成HttpBody参数
+ (NSDictionary *)parametersConfig:(NSDictionary *)parameters needEncryption:(BOOL)encryption {
    if (encryption) {
        NSString *paramJson = [NSString convertToJsonStr:parameters];
        NSString *encrypStr = [AESTool aesEncrypt:paramJson];
        if (encrypStr) {
            return @{@"data":encrypStr};
        }else {
            return parameters;
        }
    }else {
        return parameters;
    }
}

/// 返回值解密
+ (id)responseConfiguration:(id)responseObject encrypt:(BOOL)encrypt {
    if (!responseObject) return nil;
        
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return responseObject;
    }else {
        if (encrypt) {
            NSDictionary *respons = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            return [AESTool aesDecrypt:respons[@"data"]];
        }else {
            return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
    }
}

#pragma mark - 打印url、请求及响应参数、error
+ (void)requestLogPrint:(NSString *)urlString httpHeader:(NSDictionary *)httpHeader parameters:(NSDictionary *)parameters {
    DLog(@"\ncurrent Thread: %@  \nRequest URL: %@  \nHttp Header: %@  \nparameters: %@", [NSThread currentThread], urlString, httpHeader, parameters);
}

+ (void)responseLogPrint:(NSString *)urlString responseData:(NSDictionary *)responseData {
    DLog(@"\ncurrent Thread: %@  \nResponse URL: %@  \nResponse Data: %@", [NSThread currentThread], urlString, responseData);
}

+ (void)errorLogPrint:(NSError *)error {
    DLog(@"\ncurrent Thread: %@  \nURL: %@  \nerror code: %zd  \ndescription: %@", [NSThread currentThread], error.userInfo[NSURLErrorFailingURLErrorKey], error.code, error.localizedDescription);
}

/// 请求失败的信息转换为提示error
+ (void)requestFailureWithMsg:(NSString *)msg code:(NSInteger)code block:(void (^)(NSError *error))failure {
    if ([msg isKindOfClass:[NSNull class]]) {
        msg = nil;
    }
    if (code == 401) {
        [kUser refreshTokenSuccess:nil failure:nil];
        NSError *error = [NSError errorWithDomain:@"gamfun" code:code userInfo:@{kHttpErrorReason : msg ?: kLocalize(@"Network connection failed, please check your network or try again later")}];
//        if (failure) {
//            failure(error);
//        }
    }else {
        NSError *error = [NSError errorWithDomain:@"gamfun" code:code userInfo:@{kHttpErrorReason : msg ?: kLocalize(@"Network connection failed, please check your network or try again later")}];
        if (failure) {
            failure(error);
        }
    }
}

#pragma mark - 错误处理
+ (NSError *)errorInfoHandle:(NSError *)error {
    NSDictionary *userInfo = nil;
    NSInteger code = error.code;
    
    if (error.code == -1012 || error.code == 3840) {
        userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
    }
    if (error.code == -1011) { //codeNumber == 500  404(找不到地址) 405(方法错误)  401(未授权)
        NSHTTPURLResponse * response = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        NSInteger codeNumber = response.statusCode;
        if (codeNumber == 404){
            userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
        }else if (codeNumber == 405){
            userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
        }else if (codeNumber == 401){
            userInfo = @{kHttpErrorReason : kLocalize(@"Authorization failed")};
            [kUser refreshTokenSuccess:nil failure:nil];
        }else{
            userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
        }
        code = codeNumber;
    }
    if (error.code == -1009) {
        userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
    }
    if (error.code == -1004) {
        userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
    }
    if (error.code == -1001) {
        userInfo = @{kHttpErrorReason : kLocalize(@"Network connection failed, please check your network or try again later")};
    }
    if (userInfo == nil) {
        userInfo = @{kHttpErrorReason : error.localizedDescription};
    }
    
    NSError *bitchError = [NSError errorWithDomain:@"gamfun" code:code userInfo:userInfo];
    return bitchError;
}

@end
