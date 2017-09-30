//
//  SearchRecordManager.h
//  CollegeBeeRemember
//
//  Created by ZhouZhenFu on 15/3/29.
//  Copyright (c) 2015年 ZhouZhenFu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchRecordManager : NSObject


@property (nonatomic,strong) NSMutableArray *recordArray;
@property (nonatomic,copy)  NSString *local;// 保存路径
- (void)addNewSearchWord:(NSString *)searchWork;

- (void)saveRecord;

//保存搜索纪录
//+(void)writeSerchRecordArray:(NSMutableArray *)recordArray;

//读取搜索纪录
//+(NSMutableArray *)readSearchRecord;

//清除搜索纪录
-(void)cleanSearchRecord;

@end
