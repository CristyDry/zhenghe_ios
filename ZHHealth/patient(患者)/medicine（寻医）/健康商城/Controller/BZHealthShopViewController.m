//
//  BZHealthShopViewController.m
//  ZHHealth
//
//  Created by pbz on 15/11/27.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZHealthShopViewController.h"
#import "HWSearchBar.h"
#import "UIView+Extension.h"
#import "BZHealthShopADModel.h"
#import "SDCycleScrollView.h"
#import "BZSearchResultViewController.h"
#import "BZClassifyAccount.h"
#import "BZClassifyInfoCell.h"
#import "BZSearchResultModel.h"
#import "BZProductListModel.h"
#import "BZBeginSearchViewController.h"
#import "BZProductDetailController.h"
#define mainWidth  [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height
@interface BZHealthShopViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate ,UITextFieldDelegate>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSTimer *timer;
@property (nonatomic,strong) NSArray *ADAarray;
@property (nonatomic,strong)  NSArray *cellArray;
@property (nonatomic,strong)  BZClassifyAccount *classifyAccount;
@property (nonatomic,strong)  NSArray *classifyInfos;
@property (nonatomic,strong)  UITextField *SearchBar;

@end

@implementation BZHealthShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 左边的返回按钮
    [self addLeftBackBtn];
    // 搜索框
    [self searchBar];
    // tableView
    [self addTableView];
    // 图片轮播
    self.tableView.tableHeaderView = [self headerView];
   
    // 请求分类药品信息
    [self returnClassifyInfos];
  
}
// 左边的返回按钮
-(void)addLeftBackBtn
{
    
    float width = 17;
    float height = 17;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageNamed:@"arrow"];
    
    [button setBackgroundImage:image forState:0];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    
    [button addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backLeftNavItemAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}
- (void)searchBar{
    _SearchBar = [[HWSearchBar alloc] initWithFrame:CGRectMake(30, 5, mainWidth - 60, 34)];
    self.navigationItem.titleView = _SearchBar;
    _SearchBar.delegate = self;
    _SearchBar.clearsOnBeginEditing = YES;
    _SearchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
}
#pragma mark - 添加一个tableView
- (void)addTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight) style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    
}

#pragma mark - 图片轮播
- (UIView *)headerView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth * 0.6)];
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height) imageURLStringsGroup:nil];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.delegate = self;
    cycleScrollView2.titleLabelHeight = cycleScrollView2.bounds.size.height * 0.34;
    cycleScrollView2.titleLabelTextFont = [UIFont systemFontOfSize:15];
    cycleScrollView2.titleLabelBackgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    cycleScrollView2.dotColor = [UIColor blueColor]; // 自定义分页控件小圆标颜色
    [headerView addSubview:cycleScrollView2];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"num"] = @"3";
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheProduct/getStoreCarousel" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            NSLog(@"图片轮播");
            weakSelf.ADAarray = [BZHealthShopADModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            NSMutableArray *imagesURLStrings = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (BZHealthShopADModel *mode in weakSelf.ADAarray) {
                [imagesURLStrings addObject:mode.avatar];
                [titles addObject:mode.title];
            }
            // 图片
            cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
            // 标题
            cycleScrollView2.titlesGroup = titles;
        }
    }];
    return headerView;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BZProductDetailController *productDetailController = [[BZProductDetailController alloc] init];
    NSMutableArray *productId = [NSMutableArray array];
    for (BZHealthShopADModel *mode in _ADAarray) {
        [productId addObject:mode.productId];
    }
    productDetailController.productId = productId[index];
    [self.navigationController pushViewController:productDetailController animated:YES];
}

/**
 *  请求分类药品信息
 */
- (void)returnClassifyInfos{
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheProduct/getProductClassifyList" args:nil targetVC:self response:^(ResponseModel *responseMd) {
        
        if (responseMd.isResultOk) {
            
            weakSelf.classifyInfos = [BZClassifyAccount mj_objectArrayWithKeyValuesArray:responseMd.response];
            
            [self.tableView reloadData];
        }
    }];

}



#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.classifyInfos.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    BZClassifyInfoCell *cell = [BZClassifyInfoCell BZClassifyInfoCellWithTableView:tableView];
   
    //设置数据
    BZClassifyAccount *classifyInfo = _classifyInfos[indexPath.row];
    cell.infos = classifyInfo;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BZClassifyAccount *clssifyInfo = _classifyInfos[indexPath.row];
    [self createSearchResultController:clssifyInfo.ID];
//    if ([clssifyInfo.classifyName isEqualToString:@"家常必备"]) {
//        [self createSearchResultController:clssifyInfo.ID];
//    }else if ([clssifyInfo.classifyName isEqualToString:@"感冒咳嗽"]){
//        [self createSearchResultController:clssifyInfo.ID];
//    }else if ([clssifyInfo.classifyName isEqualToString:@"清热解毒"]){
//        [self createSearchResultController:clssifyInfo.ID];
//    }else if ([clssifyInfo.classifyName isEqualToString:@"退烧止痛"]){
//        [self createSearchResultController:clssifyInfo.ID];
//    }else if ([clssifyInfo.classifyName isEqualToString:@"肠胃不适"]){
//        [self createSearchResultController:clssifyInfo.ID];
//    }else if ([clssifyInfo.classifyName isEqualToString:@"皮肤外用"]){
//        [self createSearchResultController:clssifyInfo.ID];
//    }else if ([clssifyInfo.classifyName isEqualToString:@"妇科用药"]){
//        [self createSearchResultController:clssifyInfo.ID];
//    }
}
// 创建SearchResultController
- (void)createSearchResultController:(NSString *) ID{
    [self.navigationController setNavigationBarHidden:NO];
    BZSearchResultViewController *searchResultController =[[BZSearchResultViewController alloc] init];
    searchResultController.classifyId = ID;
    searchResultController.isFormClassify = YES;
    searchResultController.classifyInfos = _classifyInfos;
    searchResultController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchResultController animated:YES];
}

// 搜索框代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    BZBeginSearchViewController *beginSearchController = [[BZBeginSearchViewController alloc] init];
    beginSearchController.classifyInfos = _classifyInfos;
    [self.navigationController pushViewController:beginSearchController animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    beginSearchController.hidesBottomBarWhenPushed = YES;
}


@end
