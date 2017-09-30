//
//  ResponseModel.m
//  CollegeBeeRemember
//
//  Created by zhenfu zhou on 15/4/3.
//  Copyright (c) 2015年 ZhouZhenFu. All rights reserved.
//

#import "ResponseModel.h"


@implementation ResponseModel

-(id)initWithDic:(NSDictionary *)dic
{
    
    self = [super init];
    if(self){
        
        if(dic){
            self.msg =[dic objectForKey:@"resultMessage"];
            self.resultCode =[dic objectForKey:@"resultCode"];
            self.response =[dic objectForKey:@"resultData"];
        
            if ([self.resultCode intValue] == 0) {
                
                self.backCode = kSuccess_Code;
                _isResultOk = YES;
            }
            else{
                self.backCode = kError_Code;
            }
            
        }else{
            self.msg = @"内容为空";
            self.resultCode = @"100000";
            self.response =nil;
            self.backCode = kFailure_Code;
        }
    }
    return self;
    
}


+ (ResponseModel *)responseModelFailureStaue
{
    ResponseModel *model = [[ResponseModel alloc]init];
    model.response = nil;
    model.backCode = kFailure_Code;
    model.msg = @"网络异常，连接超时！";
//    if ([Tools getNetworkStatus]) {
//        ;
//    }
//    else{
//        model.msg = @"请检查您的网络连接！";
    
    return model;
}


@end
