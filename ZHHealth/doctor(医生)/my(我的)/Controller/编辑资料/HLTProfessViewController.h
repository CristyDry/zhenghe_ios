//
//  HLTProfessViewController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTEditModel.h"
#import <BaseViewControler.h>

@protocol HLTProfessViewControllerDelegate <NSObject>

-(void)changeProfess:(HLTEditModel *)afterModel;

@end

@interface HLTProfessViewController : BaseViewControler

@property (nonatomic, strong) HLTEditModel *editmodel;

@property (nonatomic, weak) id<HLTProfessViewControllerDelegate> delegate;

@end
