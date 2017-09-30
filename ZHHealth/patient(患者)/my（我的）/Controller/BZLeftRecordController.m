//
//  BZLeftRecordController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZLeftRecordController.h"
#import "BZAddLeftRecordController.h"
#import "BZLeftRecordCell.h"
#import "BZLeftRecordModel.h"
#import "BZEditLeftRecordController.h"
@interface BZLeftRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSMutableArray *LeftRecordModelA;
@end

@implementation BZLeftRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBar];
    [self initTableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self requestLeftRecordInfos];
}
// 请求日志列表
- (void)requestLeftRecordInfos{
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/medicalApiController/getLifeLog" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSeaf.LeftRecordModelA = [BZLeftRecordModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self.tableView reloadData];
        }
    }];
}

// 设置导航栏
- (void)setNavigationBar{
    [self addLeftBackItem];
    self.navigationItem.title = @"生活日志";
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addLeftRecord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

}
// 添加生活日志
- (void)addLeftRecord{
    BZAddLeftRecordController *addLeftRecordVC = [[BZAddLeftRecordController alloc] init];
    [self.navigationController pushViewController:addLeftRecordVC animated:YES];
}
- (void)initTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64) style:UITableViewStylePlain];
    _tableView = tableView;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _LeftRecordModelA.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出模型
    BZLeftRecordModel *leftRecordInfo = _LeftRecordModelA[indexPath.row];
    // 创建可重用cell
    NSString *reuseID = [NSString stringWithFormat:@"Cell%ld%ld",indexPath.section,indexPath.row];
    
    BZLeftRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[BZLeftRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID images:leftRecordInfo.image];
    }
    // 给cell内部子控件赋值
    cell.leftRecordInfo = leftRecordInfo;
    // 返回cell
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 删除日志
        // 取出模型
        BZLeftRecordModel *leftRecordInfo = _LeftRecordModelA[indexPath.row];
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = leftRecordInfo.ID;
        [httpUtil doPostRequest:@"api/medicalApiController/deleteLifeLog" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [_LeftRecordModelA removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
        }];
    
    }];
      return @[deleteRoWAction];
}

// 点击每一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     BZLeftRecordModel *leftRecordInfo = _LeftRecordModelA[indexPath.row];
    BZEditLeftRecordController *addLeftRecordVC = [[BZEditLeftRecordController alloc] init];
    addLeftRecordVC.leftRecordInfo = leftRecordInfo;
    [self.navigationController pushViewController:addLeftRecordVC animated:YES];
    
}











@end
