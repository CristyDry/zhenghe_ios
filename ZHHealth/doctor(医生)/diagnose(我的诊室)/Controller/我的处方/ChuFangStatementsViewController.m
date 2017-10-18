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
    NSString *startTimeStr;
    NSString *endTimeStr;
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
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    startTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"statrtTimeStr"];
    endTimeStr= [[NSUserDefaults standardUserDefaults] objectForKey:@"endTimeStr"];
    // 拿出上次选择的时间
    if (startTimeStr.length > 0) {
        StartLable.text = startTimeStr;
    } else {
        startTimeStr = [NSString stringWithFormat:@"%@",[formater stringFromDate:[NSDate date]]];
        StartLable.text = startTimeStr;
    }
    
    if (endTimeStr.length > 0) {
        StartLable.text = endTimeStr;
    } else {
        endTimeStr = [NSString stringWithFormat:@"%@",[formater stringFromDate:[NSDate date]]];
        StartLable.text = endTimeStr;
    }

    StartLable.text = startTimeStr;
    EndLable.text = endTimeStr;
    [self requestChuFangStatementData];
}

#pragma mark 请求处方统计数据
- (void)requestChuFangStatementData {
    // 处方药品统计
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    args[@"id"] = account.Id;
    args[@"startDate"] = startTimeStr;
    args[@"endDate"] = endTimeStr;
    
    [httpUtil doPostRequest:@"api/ZhengheRx/report" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
        }
    }];

}

#pragma mark Click Action
- (IBAction)SelectStartTimeAction:(UIButton *)sender {
    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    //    calendarPicker.isLunarCalendar = YES; //开启农历
    calendarPicker.thisTheme = kNavigationBarColor;
    calendarPicker.selectDate = [NSDate date]; //选择时间
    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
        StartLable.text = [NSString stringWithFormat:@"%d-%d-%d", (int)year,(int)month,(int)day];
        startTimeStr = StartLable.text;
        // 保存选择的数据
        [[NSUserDefaults standardUserDefaults] setObject:StartLable.text forKey:@"statrtTimeStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self requestChuFangStatementData];
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
        startTimeStr = EndLable.text;
        // 保存选择的数据
        [[NSUserDefaults standardUserDefaults] setObject:EndLable.text forKey:@"endTimeStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self requestChuFangStatementData];
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
