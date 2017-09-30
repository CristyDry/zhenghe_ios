//
//  WeixinPayModel.h
//  ZHHealth
//
//  Created by Apple on 2017/9/29.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeixinPayModel : NSObject

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *nonceStr;

@property (nonatomic, copy) NSString *packageValue;

@property (nonatomic, copy) NSString *partnerId;

@property (nonatomic, copy) NSString *prepayId;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *timeStamp;
@end
