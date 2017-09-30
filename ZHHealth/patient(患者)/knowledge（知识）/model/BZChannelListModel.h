//
//  BZChannelListModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZChannelListModel : NSObject
@property (nonatomic)  BOOL isSeleced;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *classifyName;

+ (void)encode:(NSMutableArray *) account;
+ (NSMutableArray *)decode;

@end
