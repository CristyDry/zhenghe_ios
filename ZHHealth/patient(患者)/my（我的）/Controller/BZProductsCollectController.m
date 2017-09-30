//
//  BZProductsCollectController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZProductsCollectController.h"
#import "BZCollectProductListModel.h"
#import "LoginViewController.h"
#import "BZProductCollectCell.h"
#import "BZProductDetailController.h"

@interface BZProductsCollectController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSArray *productListA;

@end

@implementation BZProductsCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestArticleData];
}
// 请求收藏药品数据
- (void)requestArticleData{
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        // 取出患者id
        LoginResponseAccount *account = [LoginResponseAccount decode];
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] =account.Id;
        args[@"type"] = @"2";
        args[@"user"] = @"1";
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/medicalApiController/getPatientCollectList" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.productListA = [BZCollectProductListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self initTableView];
            }
        }];
        
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kMainWidth, kMainHeight - 120) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productListA.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    static NSString *reuseID = @"productCollectCell";
    BZProductCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[BZProductCollectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    // 给cell内部子控件赋值
    cell.productListModel = _productListA[indexPath.row];
    // 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainWidth * 0.22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BZCollectProductListModel *collectProductListModel = _productListA[indexPath.row];
    BZProductDetailController *productDetailController = [[BZProductDetailController alloc] init];
    productDetailController.productId = collectProductListModel.ID;
    [self.navigationController pushViewController:productDetailController animated:YES];

}




@end
