//
//  BZMyMessageViewController.m
//  ZHHealth
//
//  Created by pbz on 15/12/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMyMessageViewController.h"
#import "BZMessageCell.h"
#import "BZRequestAndNotifyModel.h"

@interface BZMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)  UITableView *messageTableView;
@property (nonatomic,strong)  NSArray *RequestAndNotifyA;


@end

@implementation BZMyMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加一个UITableView
    [self addTableView];
    // 请求数据
//    [self resquestMyDoctor];
}
// 请求我的医生数据
- (void)resquestMyDoctor{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    // 取出患者id
    //    LoginResponseAccount *account = [LoginResponseAccount decode];
    //    args[@"id"] = account.Id;
    args[@"id"] = @"102";
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/applyMessage" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.RequestAndNotifyA = [BZRequestAndNotifyModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 添加一个UITableView
            [self addTableView];
            
        }
    }];
}
// 添加一个UITableView
- (void)addTableView{
    UITableView *messageTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight) style:UITableViewStylePlain];
    _messageTableView = messageTableView;
    [self.view addSubview:messageTableView];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
}

#pragma mark - UITableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    BZMessageCell *cell = [BZMessageCell BZMessageCellWithTableView:tableView];
    
//    //设置数据
//    BZRequestAndNotifyModel *requestAndNotifyModel = _RequestAndNotifyA[indexPath.row];
//    cell.requestAndNotifyModel = requestAndNotifyModel;
    return cell;
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}




@end
