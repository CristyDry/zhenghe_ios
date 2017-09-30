//
//  HLTChatViewController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/23.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "HLTDiagnose.h"
#import "HLTSearch.h"
#import "RCDChatViewController.h"

@interface HLTChatViewController : RCDChatViewController

@property (nonatomic, strong) HLTSearch *searchModel;
@property (nonatomic, strong) huanzhe *huanzheModel;



@end
