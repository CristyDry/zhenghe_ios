//
//  WcrSystemInfoViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrSystemInfoViewController.h"
#import "HLTLabel.h"
#import "HLTInfoModel.h"
#import "HLTInfoCell.h"
#import "HLTInfoDetailController.h"
@interface WcrSystemInfoViewController ()
@end

@implementation WcrSystemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    self.title = @"系统通知";
    
}


@end
