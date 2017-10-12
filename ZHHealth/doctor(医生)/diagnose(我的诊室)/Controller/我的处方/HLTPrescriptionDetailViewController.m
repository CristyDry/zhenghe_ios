//
//  HLTPrescriptionDetailViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/13.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "HLTPrescriptionDetailViewController.h"

@interface HLTPrescriptionDetailViewController ()
{
    // 处方患者信息
    __weak IBOutlet UITextField *ChuFangLable;
    __weak IBOutlet UILabel *ChuFangName;
    __weak IBOutlet UILabel *ChuFangTelLable;
    __weak IBOutlet UILabel *ChuFangAgeLable;
    __weak IBOutlet UILabel *ChuFangOtherLable;
    
    __weak IBOutlet UIButton *SexManBtn;
    __weak IBOutlet UIButton *SexWomanBtn;
    
    __weak IBOutlet UITableView *ChuFangTableView;
    
}
@end

@implementation HLTPrescriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
