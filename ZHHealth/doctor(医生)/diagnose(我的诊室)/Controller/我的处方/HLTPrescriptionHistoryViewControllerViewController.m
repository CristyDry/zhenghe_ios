//
//  HLTPrescriptionHistoryViewControllerViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/10.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "HLTPrescriptionHistoryViewControllerViewController.h"

@interface HLTPrescriptionHistoryViewControllerViewController ()

@end

@implementation HLTPrescriptionHistoryViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处方记录";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
