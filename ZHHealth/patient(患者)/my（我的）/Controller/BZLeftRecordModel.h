//
//  BZLeftRecordModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZLeftRecordModel : NSObject

@property (nonatomic, copy) NSString *updateDate; // 更新时间

@property (nonatomic, copy) NSString *content;    // 日志内容

@property (nonatomic, copy) NSString *ID;         // 日志id

@property (nonatomic, copy) NSString *title;      // 日志标题

@property (nonatomic, copy) NSString *createDate; // 创建时间

@property (nonatomic, copy) NSString *patientId;  // 患者id

@property (nonatomic, strong) NSArray<NSString *> *image;     // 图片

@property (nonatomic, assign) BOOL isNewRecord;


@end
