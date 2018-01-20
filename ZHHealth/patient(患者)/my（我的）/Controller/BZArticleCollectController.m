//
//  BZArticleCollectController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZArticleCollectController.h"
#import "BZArticleCollectCell.h"
#import "LoginViewController.h"
#import "BZCollectArticleListModel.h"
#import "WCRKnowledgeDetailController.h"
@interface BZArticleCollectController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSArray *articleListA;
@end

@implementation BZArticleCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestArticleData];
}
// 请求文章数据
- (void)requestArticleData{
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        // 取出患者id
        LoginResponseAccount *account = [LoginResponseAccount decode];
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] =account.Id;
        args[@"type"] = @"1";
        args[@"user"] = @"1";
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/medicalApiController/getPatientCollectList" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.articleListA = [BZCollectArticleListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
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
    CGFloat length = 60;
    if([kUserDefaults boolForKey:@"viewAll"] || [kUserDefaults boolForKey:@"viewDoc"]){
        length = 120;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, length, kMainWidth, kMainHeight - length) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _articleListA.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    static NSString *reuseID = @"articleCollectCell";
    BZArticleCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[BZArticleCollectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    // 给cell内部子控件赋值
    cell.articleListModel = _articleListA[indexPath.row];
    // 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainWidth * 0.22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WCRKnowledgeDetailController *knowlegdeDetailVC = [[WCRKnowledgeDetailController alloc]init];
    knowlegdeDetailVC.hidesBottomBarWhenPushed = YES;
    BZCollectArticleListModel *articleListModel = _articleListA[indexPath.row];
    knowlegdeDetailVC.articleId = articleListModel.ID;
    [self.navigationController pushViewController:knowlegdeDetailVC animated:YES];
}









@end
