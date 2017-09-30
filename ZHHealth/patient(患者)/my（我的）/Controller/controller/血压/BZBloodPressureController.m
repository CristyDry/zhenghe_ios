//
//  BZBloodPressureController.m
//  ZHHealth
//
//  Created by pbz on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZBloodPressureController.h"
#import "BZBloodRrcoedMonModel.h"
#import "BZBooldPressureModel.h"
#import "BZRecordBloodController.h"
#import "BZAddBloodRecordController.h"

@interface BZBloodPressureController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)  NSMutableDictionary *allDict;
@property (nonatomic,strong)  NSMutableArray *keyArray;
@property (nonatomic,strong)  NSArray *booldPressureModelA;

@end

@implementation BZBloodPressureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.navigationItem.title = @"血压记录";

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
    [httpUtil doPostRequest:@"api/medicalApiController/getBloodPressureList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.booldPressureModelA = [BZBooldPressureModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 分组数据
            [self setData];
            [self.tableView reloadData];
        }
    }];
}

- (void)setCustomUI{

    [self initTableView];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 80, kMainHeight - 80, 50, 50)];
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBloodRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}
// 添加血压记录
- (void)addBloodRecord{
    BZAddBloodRecordController *addBloodRecordVC = [[BZAddBloodRecordController alloc] init];
    // 传递一个病人ID
    LoginResponseAccount *account = [LoginResponseAccount decode];
    addBloodRecordVC.patientId = account.Id;
    [self.navigationController pushViewController:addBloodRecordVC animated:YES];
}

// 分组数据
- (void) setData{
    _allDict = [[NSMutableDictionary alloc]init];
    _keyArray = [[NSMutableArray alloc]init];
    
    // 取出数据
    for (BZBooldPressureModel *booldPressureModel in _booldPressureModelA) {
        // 分割时间
        TimeModel *timeModel = [Tools splitTimeWithString:booldPressureModel.updateDate];
        NSString *yearAndMonth = [NSString stringWithFormat:@"%@年%@月",timeModel.year,timeModel.month];
        
        BZBloodRrcoedMonModel *monthData = [_allDict objectForKey:yearAndMonth];
        if (nil == monthData) {
            monthData = [[BZBloodRrcoedMonModel alloc]initWithYear:timeModel.year month:timeModel.month];
            [_keyArray addObject:yearAndMonth];
            [_allDict setObject:monthData forKey:yearAndMonth];
        }
        [monthData.dataSource addObject:booldPressureModel];
    }
    [self.tableView reloadData];
}
- (void)initTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keyArray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    NSString *key = [_keyArray objectAtIndex:section];
    BZBloodRrcoedMonModel *monthData = [_allDict objectForKey:key];
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
    BZBloodRrcoedMonModel *monthData = [_allDict objectForKey:key];
    BZBooldPressureModel *booldPressureModel = monthData.dataSource[indexPath.row];
    // picture
    UIImageView *picture = [cell.contentView viewWithTag:1];
    picture.image = [UIImage imageNamed:@"血压显示"];
    // 静息/运动前/运动后 心率
    UILabel *nameLabel = [cell.contentView viewWithTag:2];
    nameLabel.text = @"血压";
    // 更新时间
    UILabel *updateDate = [cell.contentView viewWithTag:3];
    TimeModel *timeModel = [Tools splitTimeWithString:booldPressureModel.updateDate];
    NSString *time = [NSString stringWithFormat:@"%@-%@  %@:%@",timeModel.month,timeModel.day,timeModel.hours,timeModel.minutes];
    updateDate.text = time;
    // 心率
    UILabel *dbp = [cell.contentView viewWithTag:4];
    dbp.text = [NSString stringWithFormat:@"%@/%@",booldPressureModel.sbp,booldPressureModel.dbp];
    // 单位
    UILabel *unitLabel = [cell.contentView viewWithTag:5];
    unitLabel.text = @"mmhg";
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
    BZBloodRrcoedMonModel *monthData = [_allDict objectForKey:key];
    BZBooldPressureModel *booldPressureModel = monthData.dataSource[indexPath.row];
    
    BZRecordBloodController *recordBloodVC = [[BZRecordBloodController alloc] init];
    recordBloodVC.sbp = booldPressureModel.sbp;
    recordBloodVC.dpb = booldPressureModel.dbp;
    recordBloodVC.patientId = booldPressureModel.patientId;
    recordBloodVC.bpId = booldPressureModel.ID;
    [self.navigationController pushViewController:recordBloodVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end


