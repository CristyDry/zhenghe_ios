//
//  BZProductListTwoController.m
//  ZHHealth
//
//  Created by pbz on 16/1/6.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import "BZProductListTwoController.h"
#import "BZProductListTwoCell.h"
#import "BZProductDetailController.h"
@interface BZProductListTwoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *tableView;
@end

@implementation BZProductListTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.title = @"商品清单";
    [self addRightView];
    [self initTableView];
}
// 添加右边按钮
- (void)addRightView{
    float width = 80;
    float height = 30;
    UIButton *acontBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [acontBtn setTitle:[NSString stringWithFormat:@"共1件"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:acontBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
}

// 初始化一个tableView
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    static NSString *reuseID = @"productListTwoCell";
    BZProductListTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[BZProductListTwoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    // 给cell内部子控件赋值
    cell.productDetailInfosModel = _productDetailInfosModel;
    cell.ADpic = _ADpic;
    
    // 返回cell
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainWidth * 0.22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BZProductDetailController *productDetailController = [[BZProductDetailController alloc] init];
    productDetailController.productId = _productDetailInfosModel.ID;
    [self.navigationController pushViewController:productDetailController animated:YES];
}


@end
