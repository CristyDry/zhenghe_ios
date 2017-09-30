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
#import "RecordeCell.h"

@interface BZBloodPressureController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)  NSMutableDictionary *allDict;
@property (nonatomic,strong)  NSMutableArray *keyArray;

@end

@implementation BZBloodPressureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    self.navigationItem.title = @"血压";
    [self initTableView];
    
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
            [monthData.dataSource addObject:booldPressureModel];
            [_keyArray addObject:yearAndMonth];
        }
    }
    [self.tableView reloadData];
}

- (void)initTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 54) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

//    return _keyArray.count;
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSString *key = [_keyArray objectAtIndex:section];
//    BZBloodRrcoedMonModel *monthData = [_allDict objectForKey:key];
//    return monthData.dataSource.count;
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    
    
    static NSString *reuseID = @"recodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordeCell" owner:self options:nil] lastObject];
    }
//    NSString *key = [_keyArray objectAtIndex:indexPath.section];
//    BZBloodRrcoedMonModel *monthData = [_allDict objectForKey:key];
//    BZBooldPressureModel *presureInfo = [monthData.dataSource objectAtIndex:indexPath.row];
//    // 给cell内部子控件赋值
//    UILabel *nameLabel = [cell.contentView viewWithTag:2];
//    nameLabel.text = @"123";
    // 返回cell
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end


