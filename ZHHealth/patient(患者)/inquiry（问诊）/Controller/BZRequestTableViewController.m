//
//  BZRequestTableViewController.m
//  ZHHealth
//
//  Created by pbz on 15/12/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZRequestTableViewController.h"
#import "BZRequestCell.h"
#import "LoginResponseAccount.h"
#import "BZRequestAndNotifyModel.h"

@interface BZRequestTableViewController ()
@property (nonatomic,strong)  NSMutableArray *requestAndNotifyModelA;
@end

@implementation BZRequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setNavigationBar];
    // 请求数据
    [self requestInfos];

}
// 设置导航栏
- (void)setNavigationBar{
    [self addLeftBackItem];
    self.navigationItem.title = @"申请与通知";
    // 右边清除按钮
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 60, 0, 60, 40)];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    
}
// 请求数据
- (void)requestInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    // 取出患者id
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"id"] = account.Id;
    __weak typeof(self) weakself = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/applyMessage" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakself.requestAndNotifyModelA = [BZRequestAndNotifyModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self.tableView reloadData];
        }
    }];
}
// 点击清除
- (void)clearClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除所有历史申请记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        LoginResponseAccount *account = [LoginResponseAccount decode];
        args[@"id"] = account.Id;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/clearMessage" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                _requestAndNotifyModelA = nil;
                [self.tableView reloadData];
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _requestAndNotifyModelA.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建可重用cell
    BZRequestCell *cell = [BZRequestCell BZRequestCellWithTableView:tableView];
    
    //设置数据
    BZRequestAndNotifyModel *requestAndNotifyModel = _requestAndNotifyModelA[indexPath.row];
    cell.requestAndNotifyModel = requestAndNotifyModel;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

@end
