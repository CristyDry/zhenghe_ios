//
//  HLTSearch.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTSearch : NSObject

//患者id
@property (nonatomic, copy) NSString *ID;
//分组id
@property (nonatomic, copy) NSString *groupId;
//组名
@property (nonatomic, copy) NSString *groupName;
//患者姓名
@property (nonatomic, copy) NSString *patient;
//地区
@property (nonatomic, copy) NSString *address;
//性别
@property (nonatomic, copy) NSString *gender;
//患者年龄
@property (nonatomic, copy) NSString *age;
//患者头像
@property (nonatomic, copy) NSString *avatar;





@end
