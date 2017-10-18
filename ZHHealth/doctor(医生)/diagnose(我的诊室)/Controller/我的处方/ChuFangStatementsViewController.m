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

@interface ChuFangStatementsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *CurrentView;
    __weak IBOutlet UITableView *ChufangStateTableView;
    __weak IBOutlet UIView *StartView;
    __weak IBOutlet UILabel *StartLable;
    __weak IBOutlet UIView *EndView;
    __weak IBOutlet UILabel *EndLable;
    NSString *startTimeStr;
    NSString *endTimeStr;
    NSMutableArray *delegateArray;
    NSArray *ChuFangStatemaentArr;
}
@property (nonatomic, strong)NSIndexPath * selectedIndex;

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
    
    ChufangStateTableView.dataSource = self;
    ChufangStateTableView.delegate = self;
    delegateArray = [[NSMutableArray alloc]init];
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
            ChuFangStatemaentArr = responseMd.response;
            delegateArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < ChuFangStatemaentArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn addTarget:self action:@selector(putawayOrderListAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = i;
                [delegateArray addObject:btn];
            }
            [ChufangStateTableView reloadData];
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
        endTimeStr = EndLable.text;
        // 保存选择的数据
        [[NSUserDefaults standardUserDefaults] setObject:EndLable.text forKey:@"endTimeStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self requestChuFangStatementData];
    };
    [CurrentView addSubview:calendarPicker];
}

#pragma mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *drugCategoryDic = ChuFangStatemaentArr[section];
    NSArray *drugStateArray = drugCategoryDic[@"child"];
    // 店
    UIButton *btn = delegateArray[section];
    if (btn.selected) {
        return 0;
    }
    return drugStateArray.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ChuFangStatemaentArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *drugCategoryDic = ChuFangStatemaentArr[section];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 40)];
    header.backgroundColor = kBackgroundColor;
    
    UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 50, 15, 50, 18)];
    countLable.font = [UIFont systemFontOfSize:14];
    countLable.textColor = [UIColor redColor];
    countLable.text = [NSString stringWithFormat:@"%@",drugCategoryDic[@"nums"]];
    [header addSubview:countLable];
    
    // 增加点击收起的按钮
    UIButton *btn = delegateArray[section];
    [header addSubview:btn];
    [btn setFrame:CGRectMake(0, 0, kMainWidth, 40)];
    [btn setImage:[UIImage imageNamed:@"listOn"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"listOFF"] forState:UIControlStateSelected];
    
    if (ChuFangStatemaentArr > 0) {
        [btn setTitle:[NSString stringWithFormat:@"%@",drugCategoryDic[@"classifyName"]] forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"普通分类" forState:UIControlStateNormal];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:UIColorFromHex(0x5C5E66) forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kMainWidth-120)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kMainWidth-60)];
    return header;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"drugStateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @try {
        UILabel *drugLable = [cell viewWithTag:777];
        UILabel *drugTitle = [cell viewWithTag:778];
        NSDictionary *drugsDic = ChuFangStatemaentArr[indexPath.section];
        NSArray *drugArr = drugsDic[@"child"];
        NSDictionary *dic = drugArr[indexPath.row];
        drugLable.text = [NSString stringWithFormat:@"%@",dic[@"productName"]];
        drugTitle.text = [NSString stringWithFormat:@"%@",dic[@"nums"]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
#pragma mark = 收起统计列表 =
-(void)putawayOrderListAction:(UIButton*)sender{
    if (!sender.selected) {
        sender.selected = YES;
    } else {
        sender.selected = NO;
    }
    
    [(UITableView*)[[sender superview] superview] reloadData];
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
