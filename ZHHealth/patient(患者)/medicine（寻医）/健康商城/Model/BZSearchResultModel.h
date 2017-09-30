//
//  BZSearchResultModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/2.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZSearchResultModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *salesNum;

@property (nonatomic, copy) NSString *productUnit;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *standard;

@property (nonatomic, copy) NSString *repertoryNum;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *explains;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *classifyName;

@property (nonatomic, copy) NSString *pfunction;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *pclassifyId;

@property (nonatomic, copy) NSString *productPic;

@property (nonatomic, copy) NSString *status;

@end
