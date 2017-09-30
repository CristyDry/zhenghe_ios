//
//  ReadMailTool.h
//  Model
//
//  Created by ZhouZhenFu on 15/4/30.
//  Copyright (c) 2015年 优一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mail_Model : NSObject

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,copy) NSString *name;

@end

/*********************ReadMailTool*******************/

@interface ReadMailTool : NSObject

@property (nonatomic,strong) NSMutableArray * allPersonArray ;

@property (nonatomic,strong) NSMutableArray *nameArray;

@property (nonatomic,strong) NSMutableArray *groupNameArray;

+(id)DefauleReadMailTool;

-(void)loadMail;

@end
