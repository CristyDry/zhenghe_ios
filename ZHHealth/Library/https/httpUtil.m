//
//  httpUtil.m
//  LunDeng
//
//  Created by zhenfu zhou on 14/11/17.
//  Copyright (c) 2014年 majun. All rights reserved.
//

#import "httpUtil.h"
#import "AFNetworking.h"
#import "HUD.h"

@implementation httpUtil

+ (void)doPostRequest:(NSString *)url args:(NSDictionary *)args targetVC:(UIViewController *__weak)targetVC response:(void (^)(ResponseModel *))responseBlock
{
    MBProgressHUD *hud =  [HUD showUIBlockingIndicator:targetVC.view];
    [httpUtil loadDataPostWithURLString:url args:args response:^(ResponseModel *responseMd) {
        
        [hud hide:YES afterDelay:0.5];
        
        switch (responseMd.backCode) {
            case kError_Code:
            {
//                [Tools showMsgAtTop:responseMd.msg];
            }
                break;
            case kFailure_Code:
            {
//                [HUD showAlertMsg:responseMd.msg];
            }
                break;
            default:
                break;
        }
        responseBlock(responseMd);
        
    }];

}

+ (void)doFirstPostRequest:(NSString *)url args:(NSDictionary *)args targetVC:(UIViewController *__weak)targetVC response:(void (^)(ResponseModel *))responseBlock
{
     MBProgressHUD *hud = [HUD showUIBlockingIndicator:targetVC.view];
    
    [httpUtil loadDataPostWithURLString:url args:args response:^(ResponseModel *responseMd) {
        
        [hud hide:YES];
        responseBlock(responseMd);
        switch (responseMd.backCode) {
            case kError_Code:
            {
                [Tools showMsgAtTop:responseMd.msg];
            }
                break;
            case kFailure_Code:
            {
                [HUD showAlertMsg:responseMd.msg];
            }
                break;
            default:
                break;
        }
    }];
}

+ (void)loadDataPostWithURLString:(NSString *)url args:(NSDictionary *)args response:(void (^)(ResponseModel *))responseBlock
{
//    if (![Tools getNetworkStatus]) {
//        
//        ResponseModel *respnseModel = [ResponseModel responseModelFailureStaue];
//        responseBlock(respnseModel);
//        return;
//    }
//    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    session.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    //如果报接受类型不一致请替换一致text/html或别的
    NSString  * path =[NSString stringWithFormat:@"%@%@",serverce_address,url];
    //打印url
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", path];
    
    if (args) {
        [urlStr appendString:@"?"];
        NSMutableArray *pairs = [NSMutableArray array];
        [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [pairs addObject:pair];
        }];
        [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        CLog(@"请求url:-->>%@",urlStr);
    }
    
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session POST:path parameters:args success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        CLog(@"返回Json-->>%@",[Tools SerializationJson:responseObject]);
        @try {
            responseBlock([[ResponseModel alloc]initWithDic:responseObject]);
        }
        @catch (NSException *exception) {
            CLog(@"NSException:-->%@:\r reason%@ \r  userinfo:%@",exception.name,exception.reason,exception.userInfo);
            //            [HUD showAlertMsg:@"数据解析出错!"];
            //            NSError * error=[NSError errorWithDomain:@"数据解析出错!" code:0 userInfo:nil];
            
            ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
            model.msg =@"数据解析出错!";
            
            responseBlock(model);
        }
        @finally {
            
        };
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        CLog(@"error ----> %@",error);
        ResponseModel *respnseModel = [ResponseModel responseModelFailureStaue];
        responseBlock(respnseModel);
        return;
    }];
}

+ (void)doUpImageRequest:(NSString *)url Image:(UIImage *)image name:(NSString *)name args:(NSDictionary *)args response:(void (^)(ResponseModel *))responseBlock
{
    NSData *imageData = nil;
    NSString *type = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = nil;
    
    if (UIImagePNGRepresentation(image) == nil) {
        
        imageData = UIImageJPEGRepresentation(image, 1);
        type = @"image/jpeg";
        fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
    } else {
        
        imageData = UIImagePNGRepresentation(image);
        type = @"image/png";
        fileName = [NSString stringWithFormat:@"%@.png", str];
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    session.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型

    NSString  * path =[NSString stringWithFormat:@"%@%@",serverce_address,url];
    //打印url
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", path];
    
    if (args) {
        [urlStr appendString:@"?"];
        NSMutableArray *pairs = [NSMutableArray array];
        [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [pairs addObject:pair];
        }];
        [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        CLog(@"请求url:-->>%@",urlStr);
    }
    
    [session POST:path parameters:args constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageData) {
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:type];
            
 
        }
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        CLog(@"返回Json-->>%@",responseObject);
        @try {
            responseBlock([[ResponseModel alloc]initWithDic:responseObject]);
        }
        @catch (NSException *exception) {
            CLog(@"NSException:-->%@:\r reason%@ \r  userinfo:%@",exception.name,exception.reason,exception.userInfo);
            //            [HUD showAlertMsg:@"数据解析出错!"];
            //            NSError * error=[NSError errorWithDomain:@"数据解析出错!" code:0 userInfo:nil];
            
            ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
            model.msg =@"数据解析出错!";
            
            responseBlock(model);
        }
        @finally {
            
        };

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        CLog(@"error ----> %@",error);
        ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
        model.msg =@"网络异常!";
        responseBlock(model);
    }];
}

+ (void)doUpImageRequest:(NSString *)url images:(NSArray<UIImage *> *)images name:(NSString *)name args:(NSDictionary *)args response:(void (^)(ResponseModel *))responseBlock
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  session.requestSerializer = [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    session.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSString  * path =[NSString stringWithFormat:@"%@%@",serverce_address,url];
    //打印url
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", path];
    
    if (args) {
        [urlStr appendString:@"?"];
        NSMutableArray *pairs = [NSMutableArray array];
        [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [pairs addObject:pair];
        }];
        [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        CLog(@"请求url:-->>%@",urlStr);
    }
    
    [session POST:path parameters:args constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //要提交的图片信息
        for (int i = 0; i < images.count; i++) {
            
            NSData *imageData = nil;
            NSString *type = nil;
            
            NSString *str = [Tools getDateTimeNow:DateTypeYAll];
            NSString *fileName = nil;
            UIImage *image = [images objectAtIndex:i];
            if (UIImagePNGRepresentation(image) == nil) {
                
                imageData = UIImageJPEGRepresentation(image, 1);
                type = @"image/jpeg";
                fileName = [NSString stringWithFormat:@"%@_%d.jpg",str,i];
                
            } else {
                
                imageData = UIImagePNGRepresentation(image);
                type = @"image/png";
                fileName = [NSString stringWithFormat:@"%@_%d.png",str,i];
            }
            
            //            NSString *imageName = [NSString stringWithFormat:@"%@%d",name,i + 1];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:type];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        CLog(@"返回Json-->>%@",[Tools SerializationJson:responseObject]);
        @try {
            responseBlock([[ResponseModel alloc]initWithDic:responseObject]);
        }
        @catch (NSException *exception) {
            CLog(@"NSException:-->%@:\r reason%@ \r  userinfo:%@",exception.name,exception.reason,exception.userInfo);
            //            [HUD showAlertMsg:@"数据解析出错!"];
            //            NSError * error=[NSError errorWithDomain:@"数据解析出错!" code:0 userInfo:nil];
            
            ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
            model.msg =@"数据解析出错!";
            
            responseBlock(model);
        }
        @finally {
            
        };
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        CLog(@"error ----> %@",error);
        ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
        model.msg =@"网络异常!";
        responseBlock(model);
    }];
}
/**
 *	@zhouzf	通用请求接口
 *	@param 	url 请求的地址 不用服务器地址,统一拼接
 *	@param 	args    请求参数
 */
+ (void)doRequest:(NSString *)url  args:(NSDictionary *)args
          success:(void (^)(NSDictionary *response))successBlock
          failure:(void (^)(NSError *_error))failureBlock{

}


@end
