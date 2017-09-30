//
//  HLTCollectViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTCollectViewController.h"
#import "HLTLabel.h"

#import "HLTCollectModel.h"
#import "HLTCollectCell.h"

#import "WCRKnowledgeDetailController.h"

@interface HLTCollectViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HLTCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    //添加左边返回按钮
    [self addLeftBackItem];
    //中间标题
    [self addTitleView];
    //数据
    [self requestCollectInfo];
}

#pragma mark - 中间标题
- (void)addTitleView{
    
    HLTLabel * titleLabel = [[HLTLabel alloc] init];
    [titleLabel useLabel:@"我的收藏"];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 收藏数据
-(void)requestCollectInfo
{
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:45];
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    args[@"type"] = [NSString stringWithFormat:@"1"];
    args[@"user"] = [NSString stringWithFormat:@"2"];
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/medicalApiController/getPatientCollectList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.dataArray = [HLTCollectModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            
            [self addTabelview];
        }
    }];
    
}

#pragma mark - tableview
-(void)addTabelview
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight-KTopLayoutGuideHeight) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.rowHeight = 70;
    _tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"collectCell";
    HLTCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HLTCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.collectModel = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    WCRKnowledgeDetailController *knowlegdeDetailVC = [[WCRKnowledgeDetailController alloc]init];
    knowlegdeDetailVC.hidesBottomBarWhenPushed = YES;
    HLTCollectModel *collectModel = _dataArray[indexPath.row];
    knowlegdeDetailVC.articleId = collectModel.Id;
    [self.navigationController pushViewController:knowlegdeDetailVC animated:NO];
    
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
