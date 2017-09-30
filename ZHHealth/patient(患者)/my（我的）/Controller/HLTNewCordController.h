//
//  HLTNewCordController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTMRecordModel.h"
@interface HLTNewCordController : UIViewController

@property (nonatomic, strong) HLTMRecordModel *cordModel;
@property (nonatomic, strong) HLTMRecordModel *afterCordModel;//修改后
@property (nonatomic) BOOL isNewTurn;//从新建转来
@property (nonatomic) BOOL isSeeTurn;//从浏览转来

@end
