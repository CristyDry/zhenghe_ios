//
//  httpUtil.h
//  LunDeng
//
//  Created by zhenfu zhou on 14/11/17.
//  Copyright (c) 2014年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpUserDataCallBack)(ResponseModel *responseMd,BOOL flag);

@interface httpUtil : NSObject

//@property (nonatomic,assign)BOOL isTips;//是否显示提示器

/**
 *	@brief	通用请求接口
 *	@param 	url 请求的地址 不用服务器地址,统一拼接
 *	@param 	args    请求参数
 */
//+ (void)doRequest:(NSString *)url  args:(NSDictionary *)args
//      success:(void (^)(NSDictionary *response))successBlock
//      failure:(void (^)(NSError *_error))failureBlock;

+ (void)doPostRequest:(NSString *)url  args:(NSDictionary *)args
             targetVC:(UIViewController *)targetVC
             response:(void (^)(ResponseModel *responseMd))responseBlock;

+ (void)doFirstPostRequest:(NSString *)url  args:(NSDictionary *)args
                  targetVC:(UIViewController *)targetVC
                  response:(void (^)(ResponseModel *responseMd))responseBlock;



//不带提示的请求
+ (void)loadDataPostWithURLString:(NSString *)url args:(NSDictionary *)args
                         response:(void (^)(ResponseModel *responseMd))responseBlock;

/**
 *  上传图片
 *
 *  @param url           url 请求的地址 不用服务器地址,统一拼接
 *  @param image         图片
 *  @param name          图片对应的关键字
 *  @param args          args    请求参数
 *  @param responseBlock
 */
+ (void)doUpImageRequest:(NSString *)url Image:(UIImage *)image
                    name:(NSString *)name args:(NSDictionary *)args
                response:(void (^)(ResponseModel *responseMd))responseBlock;

+ (void)doUpImageRequest:(NSString *)url images:(NSArray<UIImage *> *)images
                    name:(NSString *)name args:(NSDictionary *)args
                response:(void (^)(ResponseModel *responseMd))responseBlock;


@end
