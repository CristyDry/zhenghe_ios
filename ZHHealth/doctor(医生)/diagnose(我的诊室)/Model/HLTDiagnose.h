//
//  HLTDiagnose.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class huanzhe;
@interface HLTDiagnose : NSObject
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *grouping;

@property (nonatomic, strong) NSArray<huanzhe *> *name;

@property (nonatomic,assign) BOOL show;

@end
@interface huanzhe : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *patient;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, copy) NSString *groupId;


@end
