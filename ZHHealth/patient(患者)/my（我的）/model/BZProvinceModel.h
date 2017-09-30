//
//  BZProvinceModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/24.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZProvinceModel : NSObject

@property (nonatomic, copy) NSString *ID; //省份id

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *name; //省份名称

@property (nonatomic, copy) NSString *wm;

@end
