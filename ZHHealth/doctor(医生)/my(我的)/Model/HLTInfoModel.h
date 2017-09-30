//
//  HLTInfoModel.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTInfoModel : NSObject

@property (nonatomic, strong) NSString *Id;//医生id
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *status;//状态
@property (nonatomic, strong) NSString *date;//日期
@property (nonatomic, strong) NSString *url;//webview url

@end
