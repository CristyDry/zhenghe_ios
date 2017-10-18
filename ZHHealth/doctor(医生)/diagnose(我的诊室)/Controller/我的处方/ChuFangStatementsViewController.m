//
//  ChuFangStatementsViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/17.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "ChuFangStatementsViewController.h"
#import "RCalendarPickerView.h"
#import "RClockPickerView.h"
#import "DateHelper.h"

@interface ChuFangStatementsViewController ()
{
    __weak IBOutlet UIView *CurrentView;
    
    __weak IBOutlet UIView *StartView;
    __weak IBOutlet UILabel *StartLable;
    __weak IBOutlet UIView *EndView;
    __weak IBOutlet UILabel *EndLable;
}

@end

@implementation ChuFangStatementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"处方报表";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    
    [self setSetUIAction];
    // Do any additional setup after loading the view.
}

- (void)setSetUIAction {
    StartView.layer.cornerRadius = 5.0f;
    StartView.layer.borderWidth = 1.0f;
    StartView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    EndView.layer.cornerRadius = 5.0f;
    EndView.layer.borderWidth = 1.0f;
    EndView.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

#pragma mark Click Action
- (IBAction)SelectStartTimeAction:(UIButton *)sender {
    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    //    calendarPicker.isLunarCalendar = YES; //开启农历
    calendarPicker.thisTheme = kNavigationBarColor;
    calendarPicker.selectDate = [NSDate date]; //选择时间
    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
        StartLable.text = [NSString stringWithFormat:@"%d-%d-%d", (int)year,(int)month,(int)day];
    };
    [CurrentView addSubview:calendarPicker];
}
- (IBAction)SelectEndTime:(id)sender {
    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    //    calendarPicker.isLunarCalendar = YES; //开启农历
    calendarPicker.thisTheme = kNavigationBarColor;
    calendarPicker.selectDate = [NSDate date]; //选择时间
    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
        EndLable.text = [NSString stringWithFormat:@"%d-%d-%d", (int)year,(int)month,(int)day];
    };
    [CurrentView addSubview:calendarPicker];
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
