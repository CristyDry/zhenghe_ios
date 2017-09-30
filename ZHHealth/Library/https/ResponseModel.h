//
//  ResponseModel.h
//  CollegeBeeRemember
//
//  Created by zhenfu zhou on 15/4/3.
//  Copyright (c) 2015年 ZhouZhenFu. All rights reserved.
//

typedef NS_ENUM(int)
{
    /** 没和服务器交换的失败*/
    kFailure_Code = 10086,
    /** 返回错误*/
    kError_Code,
    /** 返回成功*/
    kSuccess_Code
}BackCode;



#import <Foundation/Foundation.h>

@interface ResponseModel : NSObject


@property(nonatomic,copy) NSString *resultCode;
@property(nonatomic,copy) NSString *msg;
@property(nonatomic,retain) id response;
/** 返回状态 */
@property(nonatomic,assign) BackCode backCode;
/** 是否成功 */
@property (nonatomic,assign,readonly) BOOL isResultOk;

-(id)initWithDic:(NSDictionary *)dic;

+ (ResponseModel *)responseModelFailureStaue;

@end
