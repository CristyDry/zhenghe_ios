//
//  BZSearchResultViewController.m
//  ZHHealth
//
//  Created by pbz on 15/11/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZSearchResultViewController.h"
#import "HWSearchBar.h"
#import "BZClassifyAccount.h"
#import "BZProductListModel.h"
#import "BZSearchResultCell.h"
#import "MXPullDownMenu.h"
#import "BZBeginSearchViewController.h"
#import "MJRefresh.h"
#import "BZProductDetailController.h"
#import "BZDoctorListController.h"
#define mainWidth  [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height

@interface BZSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,MXPullDownMenuDelegate,UITextFieldDelegate,BZSearchResultCellDelegate,BZDoctorListControllerDelegate>

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSMutableArray *productListS;
@property (nonatomic,strong)  MXPullDownMenu *menu;
@property (nonatomic,strong)  NSArray *orderArray;
@property (nonatomic,strong)  NSArray *arrayName;
@property (nonatomic,strong)  BZClassifyAccount *classifyAccount;
@property (nonatomic,strong)  BZProductListModel *productListModel;
// 已选择的分类ID
@property (nonatomic,copy)  NSString *selectClassifyId;
// 已选择的最小价格
@property (nonatomic,copy)  NSString *selectPriceMin;
// 已选择的最大价格
@property (nonatomic,copy)  NSString *selectPriceMax;
// 已选择的药品类型
@property (nonatomic,copy)  NSString *selectType;
// 已选择的排序方式
@property (nonatomic,copy)  NSString *selectOrderBy;
// 页数
@property (nonatomic,assign)  NSInteger pageNoIndex;


@end

@implementation BZSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNoIndex = 0;
    [self addLeftBackItem];
    // 搜索框
    [self searchBar];
    // 下拉菜单
    [self pullMenu];
    // addTableView
    [self addTableView];
    //  请求数据
    [self returnSearchResultInfos];
    // 设置上拉加载更多
    [self loadMore];
    // 下拉返回前一页
    [self rePage];
    //
    
}
// 搜索框
- (void)searchBar{
    HWSearchBar *searchBar = [[HWSearchBar alloc] initWithFrame:CGRectMake(30, 5, mainWidth - 60, 34)];
    searchBar.placeholder = nil;
    self.navigationItem.titleView = searchBar;
    searchBar.delegate = self;
}
// 网络请求分组数据
- (void)returnSearchResultInfos{
    [_productListS removeAllObjects];
     NSMutableDictionary *args = [NSMutableDictionary dictionary];
    if (_isFormClassify == YES) {
        // 产品分类信息模型
        args[@"classifyId"] = _classifyId;
        __weak typeof(self)weakSelf = self;
        [httpUtil doPostRequest:@"api/ZhengheProduct/getProductList" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.productListS = [BZProductListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self.tableView reloadData];
            }
        }];
    }else{
        // 产品分类信息模型
        args[@"keys"] = _keys;
        __weak typeof(self)weakSelf = self;
        [httpUtil doPostRequest:@"api/ZhengheProduct/searchProduct" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                if (responseMd.response == nil) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有你要搜索的产品" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    weakSelf.productListS = [BZProductListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                    [self.tableView reloadData];

                }
            }
        }];
    }
}
// 下拉弹框
- (void)pullMenu{

    NSMutableArray *arrayName = [NSMutableArray array];
    [arrayName addObject:@"分类"];
    [arrayName addObject:@"不限制"];
    for (BZClassifyAccount *classifyAccount in self.classifyInfos) {
        _classifyAccount = classifyAccount;
        [arrayName addObject:classifyAccount.classifyName];
    }
    _arrayName = arrayName;
    NSArray *arrayPrice = @[@"价格",@"不限制",@"1-20元",@"20-50元",@"50-100元",@"100-200元"];
    NSArray *arrayOTC = @[@"非处方药",@"处方药",@"不限制"];
    NSArray *arrayComprehensive = @[@"综合排序",@"销量排序",@"价格从低到高",@"价格从高到低"];
    NSArray *orderArray = @[ arrayName, arrayPrice, arrayOTC ,arrayComprehensive ];
    _orderArray = orderArray;
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:orderArray selectedColor:[UIColor orangeColor]];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 64, menu.frame.size.width, menu.frame.size.height);
    _menu = menu;
    [self.view addSubview:menu];
    // 分割线
    UIView *separationLineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 1)];
    separationLineTop.backgroundColor = [UIColor lightGrayColor];
    [menu addSubview:separationLineTop];
    UIView *separationLineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 35, mainWidth, 1)];
    separationLineBottom.backgroundColor = [UIColor lightGrayColor];
    [menu addSubview:separationLineBottom];
}

#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    
        switch (column) {
                //分类
            case 0:
            {
                if (row == 0) {
                    return;
                }else if (row == 1){
                    _selectClassifyId = @"";
                    [self order];
                }else {
                    BZClassifyAccount *classifyModel = _classifyInfos[row - 2];
                    _selectClassifyId = classifyModel.ID;
                    [self order];
                }
                
                
            }
                break;
                // 价格排序
            case 1:
            {
                if (row == 0) {
                    return;
                }else if (row ==1){
                    _selectPriceMin = @"";
                    _selectPriceMax = @"";
                    [self order];
                }else if (row == 2){
                    _selectPriceMin = @"1";
                    _selectPriceMax = @"20";
                    [self order];
    
                }else if (row == 3){
                    _selectPriceMin = @"20";
                    _selectPriceMax = @"50";
                    [self order];
                    
                }else if (row == 4){
                    _selectPriceMin = @"50";
                    _selectPriceMax = @"100";
                    [self order];
                    
                }else if (row == 5){
                    _selectPriceMin = @"100";
                    _selectPriceMax = @"200";
                    [self order];
                    
                }
            }
                break;
                // 是否处方药
            case 2:
            {
                if (row == 0) {
                    _selectType = @"otc";
                    [self order];
                }else if (row == 1){
                    _selectType = @"rx";
                    [self order];
                    
                }else if (row == 2){
                    _selectType = @"";
                    [self order];
                }
            }
                break;
                // 综合排序
            case 3:
            {
                if (row == 0){
                    _selectOrderBy = @"1";
                    [self order];
                    
                }else if (row == 1){
                    _selectOrderBy = @"2";
                    [self order];
                    
                }else if (row == 2){
                    _selectOrderBy = @"3";
                    [self order];
                    
                }else if (row == 3){
                    _selectOrderBy = @"4";
                    [self order];
                    
                }
            }
                break;
            default:
                break;
        }

}

// 排序
- (void)order{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"classifyId"] = _selectClassifyId;
    args[@"priceMin"]   = _selectPriceMin;
    args[@"priceMax"]   = _selectPriceMax;
    args[@"type"]       = _selectType;
    args[@"orderBy"]    = _selectOrderBy;
    args[@"keys"] = @"";
    args[@"pageNo"] = [NSString stringWithFormat:@"%ld",(long)_pageNoIndex];
    args[@"pageSize"] = @"4";
    __weak typeof(self)weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheProduct/searchProduct" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            NSLog(@"responseMd.response:%@",responseMd.response);
            weakSelf.productListS = [BZProductListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
}
#pragma mark - 添加一个tableView
- (void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_menu.frame), mainWidth, mainHeight - CGRectGetMaxY(_menu.frame)) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

// 上拉加载更多
- (void)loadMore{

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNoIndex ++;
        [self order];
    }];
}
// 下拉返回前一页
- (void)rePage{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_pageNoIndex == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            _pageNoIndex --;
            [self order];
        }
    }];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return round(self.productListS.count * 0.5);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    // 创建可重用cell
    BZSearchResultCell *cell = [BZSearchResultCell searchResultCellWithTableView:tableView];
    cell.delegate = self;
    // 设置cell数据
    NSInteger index = indexPath.row * 2;
    for (NSInteger i = 0; i < 2; i++) {
        if (self.productListS.count > index) {
            _productListModel = self.productListS[index];
            [cell setProductInfo:_productListModel atIndex:i];
        }else{
            [cell setProductInfo:nil atIndex:i];
        }
        index++;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BZSearchResultCell *cell  = [[BZSearchResultCell alloc] init];
    return  cell.typeLabelMaxY + 5;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    BZSearchResultCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
}

#pragma mark - 搜索框代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    BZBeginSearchViewController *beginSearchController = [[BZBeginSearchViewController alloc] init];
    beginSearchController.classifyInfos = _classifyInfos;
    [self.navigationController pushViewController:beginSearchController animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    beginSearchController.hidesBottomBarWhenPushed = YES;
}

#pragma mark - BZSearchResultCell的自定义代理方法，跳转到药品详情页
- (void)pushProductDetailController:(NSString *)productId{
    
    BZProductDetailController *productDetailController = [[BZProductDetailController alloc] init];
    productDetailController.productId = productId;
    [self.navigationController pushViewController:productDetailController animated:NO];
    
}

@end
