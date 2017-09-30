//
//  BZMedicalRecordController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMedicalRecordController.h"
#import "HLTMRecordModel.h"
#import "HLTMRecordCell.h"
#import "HLTNewCordController.h"
#import "HLTSeeCardController.h"

@interface BZMedicalRecordController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation BZMedicalRecordController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [self requestCordData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    self.title = @"电子病历";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    [self setNavigationBarProperty];
    //添加tableview
    [self addTableview];
    if (_isPatient == YES) {
        //添加新病例按钮
        [self addNewRecord];
    }
}

#pragma mark - 请求数据
-(void)requestCordData
{
    if ([LoginResponseAccount isLogin]) {
        LoginResponseAccount * accound = [LoginResponseAccount decode];
        NSMutableDictionary * args = [NSMutableDictionary dictionary];
        args[@"id"] = accound.Id;
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/medicalApiController/getHistoryList" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.dataArray = [HLTMRecordModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [_tableview reloadData];
            }
        }];
    }else{
        NSMutableDictionary * args = [NSMutableDictionary dictionary];
        args[@"id"] = _huanzheModel.ID;
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/medicalApiController/getHistoryList" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.dataArray = [HLTMRecordModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [_tableview reloadData];
            }
        }];
    }
    
}

#pragma mark - 添加tableview
-(void)addTableview
{
    if (_isPatient == YES) {
       _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+10, kMainWidth, kMainHeight-KTopLayoutGuideHeight-10-AUTO_MATE_HEIGHT(55)) style:UITableViewStylePlain];
    }else{
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+10, kMainWidth, kMainHeight-KTopLayoutGuideHeight-10) style:UITableViewStylePlain];
    }
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.rowHeight = AUTO_MATE_HEIGHT(120);
    _tableview.backgroundColor = kBackgroundColor;
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = @"cordCell";
    HLTMRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HLTMRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.cordModel = _dataArray[indexPath.row];
    cell.backgroundColor = kBackgroundColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    HLTSeeCardController * seeVC = [[HLTSeeCardController alloc] init];
    if (!_isPatient) {
      seeVC.cordModel = _dataArray[indexPath.row];   
    }
    seeVC.number = indexPath.row;
    [self.navigationController pushViewController:seeVC animated:YES];
    
}


#pragma mark - 添加病历按钮
-(void)addNewRecord {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainHeight - AUTO_MATE_HEIGHT(55), kMainWidth, AUTO_MATE_HEIGHT(55))];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    CGFloat height = AUTO_MATE_HEIGHT(40);
    CGFloat xPoint = AUTO_MATE_WIDTH(35);
    CGFloat yPoint = (bgView.height_wcr - height) / 2.0 + 5;
    CGFloat width = kMainWidth - xPoint * 2;
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [addButton setBackgroundColor:[UIColor colorWithRGB:202 G:202 B:202]];
    [addButton setTitle:@" 新建病历" forState:0];
    [addButton setImage:[UIImage imageFileNamed:@"iconfont-tianjia" andType:YES] forState:0];
    addButton.titleLabel.font = [UIFont systemFontOfSize:KFont - 4];
    [addButton setTitleColor:kBlackColor forState:0];
    
    [addButton addTarget:self action:@selector(addCordAction:)];
    [bgView addSubview:addButton];
    
}

#pragma mark - 添加新的病历
-(void)addCordAction:(UIButton*)button {
    
    HLTNewCordController * newCord = [[HLTNewCordController alloc] init];
    newCord.isNewTurn = YES;
    newCord.isSeeTurn = NO;
    [self.navigationController pushViewController:newCord animated:YES];
}



@end
