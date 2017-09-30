//
//  BZRequestAndNotifyModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZRequestAndNotifyModel : NSObject

/** 医生名字*/
@property (nonatomic, copy) NSString *doctor;
/** 是否已同意*/
@property (nonatomic, copy) NSString *status;
/** 内容*/
@property (nonatomic, copy) NSString *content;
/** 医生头像*/
@property (nonatomic, copy) NSString *avatar;

@end
