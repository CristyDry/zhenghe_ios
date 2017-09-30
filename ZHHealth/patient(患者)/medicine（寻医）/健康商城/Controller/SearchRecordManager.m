//
//  SearchRecordManager.m
//  CollegeBeeRemember
//
//  Created by ZhouZhenFu on 15/3/29.
//  Copyright (c) 2015年 ZhouZhenFu. All rights reserved.
//

#import "SearchRecordManager.h"

@implementation SearchRecordManager

- (instancetype)init
{
    if (self = [super init]) {
        
         }
    return self;
}
- (void)setLocal:(NSString *)local{

    _local = local;
    NSString *path = [self savePath];
    _recordArray = [SearchRecordManager readSearchRecordWithPath:path];

}
- (void)addNewSearchWord:(NSString *)searchWork
{
    BOOL have = NO;
    for (int i = 0; i < _recordArray.count; i++) {
        
        NSString *oldSearchWord = [_recordArray objectAtIndex:i];
        if ([searchWork isEqualToString:oldSearchWord]) {
            
            [_recordArray removeObjectAtIndex:i];
            [_recordArray insertObject:searchWork atIndex:0];
            [self saveRecord];
            have = YES;
            break;
        }
    }
    
    if (!have) {
        
        if (![searchWork isEqualToString:@""]) {
            
            [_recordArray insertObject:searchWork atIndex:0];
            [self saveRecord];
        }
    }
}
- (void)saveRecord
{
    NSString *path = [self savePath];
    [SearchRecordManager writeSerchRecordArray:_recordArray withPath:path];
}

+(void)writeSerchRecordArray:(NSMutableArray *)recordArray withPath:(NSString *)path
{
    
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    path = [NSString stringWithFormat:@"%@/xx.plist",path];
    [NSKeyedArchiver archiveRootObject:recordArray toFile:path];
//    [recordArray writeToFile:path atomically:YES];
}

+(NSMutableArray *)readSearchRecordWithPath:(NSString *)path
{
    
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    path = [NSString stringWithFormat:@"%@/xx.plist",path];
    
//    NSMutableArray * recordArray = [NSMutableArray  arrayWithContentsOfFile:path];
    NSMutableArray *recordArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (!recordArray) {
        
        recordArray = [[NSMutableArray alloc]init];
    }
    
    return recordArray;
}

-(void)cleanSearchRecord
{
    [self.recordArray removeAllObjects];

    //创建文件管理器对象方法
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSString *path = [self savePath];
    
    [fm removeItemAtPath:path error:nil];
}

- (NSString *)savePath{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [NSString stringWithFormat:@"%@/%@.data",path,_local];
    return path;
}


@end
