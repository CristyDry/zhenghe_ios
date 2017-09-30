//
//  HLTNewListController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTMRecordModel.h"

@interface HLTNewListController : UIViewController

@property (nonatomic, strong) HLTMRecordModel *cordModel;
@property (nonatomic, strong) cdList *cdlistModel;
@property (nonatomic) BOOL isCreateList;
@property (nonatomic) BOOL isEditList;

@end
