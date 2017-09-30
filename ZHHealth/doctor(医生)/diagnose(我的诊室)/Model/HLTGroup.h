//
//  HLTGroup.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HLTGroup : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, copy) NSString *count;

@property (nonatomic) BOOL selected;

@end

