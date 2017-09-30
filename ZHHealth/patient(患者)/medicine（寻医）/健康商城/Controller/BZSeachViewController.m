//
//  BZSeachViewController.m
//  ZHHealth
//
//  Created by pbz on 15/12/3.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZSeachViewController.h"
#import "HWSearchBar.h"
#import "BZClassifyAccount.h"
#import "BZProductListModel.h"
#import "BZSearchResultCell.h"
#import "MXPullDownMenu.h"
#import "BZBeginSearchViewController.h"
#import "BZHealthShopViewController.h"
#import "BZDoctorListController.h"
#define mainWidth  [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height
@interface BZSeachViewController ()<UITableViewDataSource,UITableViewDelegate,MXPullDownMenuDelegate,UITextFieldDelegate,BZDoctorListControllerDelegate>

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSArray *productListS;
@property (nonatomic,strong)  MXPullDownMenu *menu;

@end

@implementation BZSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftBackItem];
    // 搜索框
    [self searchBar];
    // 下拉菜单
    [self pullMenu];
    // addTableView
    [self addTableView];

}

-(void)leftBackItem
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
-(void)backLeftNavItemAction{
    
    BZHealthShopViewController *healthShopVC = self.navigationController.childViewControllers[1];
//    healthShopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController popToViewController:healthShopVC animated:YES];
}

// 搜索框
- (void)searchBar{
    HWSearchBar *searchBar = [[HWSearchBar alloc] initWithFrame:CGRectMake(30, 5, mainWidth - 60, 34)];
    searchBar.placeholder = nil;
    self.navigationItem.titleView = searchBar;
    searchBar.delegate = self;
    searchBar.clearsOnBeginEditing = YES;
}

// 下拉弹框
- (void)pullMenu{
    
    NSMutableArray *arrayName = [NSMutableArray array];
    for (BZClassifyAccount *model in self.classifyInfos) {
        [arrayName addObject:model.classifyName];
    }

    NSArray *arrayPrice = @[@"价格",@"不限制",@"1-20元",@"20-50元",@"50-100元",@"100-200元",@"200元以上"];
    NSArray *arrayOTC = @[@"处方药(RX)",@"不限制",@"非处方药(OTC)"];
    NSArray *arrayComprehensive = @[@"综合排序",@"销量排序",@"价格从低到高",@"价格从高到低"];
    NSArray *array = @[arrayName,arrayPrice, arrayOTC ,arrayComprehensive ];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:array selectedColor:[UIColor orangeColor]];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 60, menu.frame.size.width, menu.frame.size.height);
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
    NSLog(@"%ld -- %ld", (long)column, (long)row);
}

#pragma mark - 添加一个tableView
- (void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_menu.frame), mainWidth, mainHeight - CGRectGetMaxY(_menu.frame)) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return round(self.searchResultA.count * 0.5);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 创建可重用cell
    BZSearchResultCell *cell = [BZSearchResultCell searchResultCellWithTableView:tableView];
    // 设置cell数据
    NSInteger index = indexPath.row * 2;
    for (NSInteger i = 0; i < 2; i++) {
        if (self.searchResultA.count > index) {
            BZProductListModel *productListModel = self.searchResultA[index];
            [cell setProductInfo:productListModel atIndex:i];
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
    NSLog(@"indexPath.row:%ld",(long)indexPath.row);
//    BZSearchResultCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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
