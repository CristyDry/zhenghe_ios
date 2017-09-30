//
//  BZClassifyAccount.h
//  ZHHealth
//
//  Created by pbz on 15/11/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZClassifyAccount : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, copy) NSString *classifyName;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, assign) BOOL isNewRecord;

@end
