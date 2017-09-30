//
//  BZWeightController.m
//  ZHHealth
//
//  Created by pbz on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZWeightController.h"
#import "BZWeightModel.h"
#import "BZWeightMonModel.h"
#import "BZAddWeightViewController.h"
#import "BZRecordWeightController.h"

@interface BZWeightController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)  NSMutableDictionary *allDict;
@property (nonatomic,strong)  NSMutableArray *keyArray;

@end

@implementation BZWeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.navigationItem.title = @"体重指数";
    [self setCustomUI];
    [self requestRecordData];
}

- (void)viewWillAppear:(BOOL)animated{
    // pop回来后再次刷新数据
    [self requestRecordData];
}

// 请求记录数据
- (void)requestRecordData{
    // 取出患者ID
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/medicalApiController/getWeightList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            // 心率
            weakSelf.weightModelA = [BZWeightModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self setData];
            [self.tableView reloadData];
        }
    }];
}

- (void)setData{
    _allDict = [[NSMutableDictionary alloc]init];
    _keyArray = [[NSMutableArray alloc]init];
    
    // 取出数据
    for (BZWeightModel *weightModel in _weightModelA) {
        // 分割时间
        TimeModel *timeModel = [Tools splitTimeWithString:weightModel.updateDate];
        NSString *yearAndMonth = [NSString stringWithFormat:@"%@年%@月",timeModel.year,timeModel.month];
        
        BZWeightMonModel *monthData = [_allDict objectForKey:yearAndMonth];
        if (nil == monthData) {
            monthData = [[BZWeightMonModel alloc]initWithYear:timeModel.year month:timeModel.month];
            [_keyArray addObject:yearAndMonth];
            [_allDict setObject:monthData forKey:yearAndMonth];
        }
        [monthData.dataSource addObject:weightModel];
    }
    [self.tableView reloadData];
}
- (void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)setCustomUI{
    
    [self initTableView];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 80, kMainHeight - 80, 50, 50)];
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addHeartRateRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}
// 添加体重记录
- (void)addHeartRateRecord{
    BZAddWeightViewController *addWeightVC = [[BZAddWeightViewController alloc] init];
    [self.navigationController pushViewController:addWeightVC animated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keyArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = [_keyArray objectAtIndex:section];
    BZWeightMonModel *monthData = [_allDict objectForKey:key];
    return monthData.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    static NSString *reuseID = @"record";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil] lastObject];
    }
    // 取出模型
    NSString *key = [_keyArray objectAtIndex:indexPath.section];
    BZWeightMonModel *monthData = [_allDict objectForKey:key];
    BZWeightModel *weightModel = monthData.dataSource[indexPath.row];
    
    UIImageView *picture = [cell.contentView viewWithTag:1];
    picture.image = [UIImage imageNamed:@"体重显示"];
    UILabel *nameLabel = [cell.contentView viewWithTag:2];
    nameLabel.text = @"BMI";
    // 更新时间
    UILabel *updateDate = [cell.contentView viewWithTag:3];
    TimeModel *timeModel = [Tools splitTimeWithString:weightModel.updateDate];
    NSString *time = [NSString stringWithFormat:@"%@-%@  %@:%@",timeModel.month,timeModel.day,timeModel.hours,timeModel.minutes];
    updateDate.text = time;
    // 体重
    UILabel *weight = [cell.contentView viewWithTag:4];
        weight.text = weightModel.exponent;

    // 过重 正常 过轻
    UILabel *unitLabel = [cell.contentView viewWithTag:5];
    CGFloat isexponent = [weightModel.exponent floatValue];
    NSLog(@"isexponent%f",isexponent);
    if (isexponent < 18.5f) {
        unitLabel.text = @"过轻";
        weight.textColor = [UIColor blueColor];
    }else if ( 18.5<= isexponent && isexponent< 24.99){
        unitLabel.text = @"正常";
        weight.textColor = [UIColor greenColor];
    }else if ( 25.0<= isexponent && isexponent< 28.0){
        unitLabel.text = @"过重";
        weight.textColor = [UIColor redColor];
    }else if ( 28.0<= isexponent && isexponent< 32.0){
        unitLabel.text = @"肥胖";
        weight.textColor = [UIColor redColor];
    }else if (isexponent >= 30.0){
        unitLabel.text = @"非常肥胖";
        weight.textColor = [UIColor redColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// 设置组头名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _keyArray[section];
    
}
// 组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取出模型
    NSString *key = [_keyArray objectAtIndex:indexPath.section];
    BZWeightMonModel *monthData = [_allDict objectForKey:key];
    BZWeightModel *weightModel = monthData.dataSource[indexPath.row];
    
    BZRecordWeightController *recordWeightVC = [[BZRecordWeightController alloc] init];
    recordWeightVC.stature = weightModel.stature;
    recordWeightVC.weightID = weightModel.ID;
    recordWeightVC.weight = weightModel.weight;
    [self.navigationController pushViewController:recordWeightVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
