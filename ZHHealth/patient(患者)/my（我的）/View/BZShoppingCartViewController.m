//
//  BZShoppingCartViewController.m
//  ZHHealth
//
//  Created by pbz on 15/11/24.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZShoppingCartViewController.h"
#import "BZShoppingCartCell.h"
#import "BZHealthShopViewController.h"
#define frame [UIScreen mainScreen].bounds
@interface BZShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *tableView;
@end

@implementation BZShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 请求数据
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self requestInfos];
    // 添加返回按钮
    [self addLeftBackItem];
    // 添加中间标题--购物车
    [self addTitleView];
}
// 请求数据
- (void)requestInfos{
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"num"] = account.Id;
    [httpUtil doPostRequest:@"api/orderApiController/buyCarList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if ([responseMd.msg isEqualToString:@"购物车是空的"]) {
            self.view.backgroundColor = [UIColor clearColor];
            UIImageView *imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(kMainWidth * 0.4, kMainHeight * 0.2, kMainWidth * 0.2, kMainWidth * 0.2)];
            imageViews.image = [UIImage imageNamed:@"iconfont-lumigouff580e"];
            [self.view addSubview:imageViews];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViews.maxY_wcr + 10, kMainWidth, 30)];
            label.text = @"购物车是空的";
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth * 0.3, label.maxY_wcr + 30, kMainWidth * 0.4, 50)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 3;
            btn.clipsToBounds = YES;
            [btn addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"去逛逛" forState:UIControlStateNormal];
            [self.view addSubview:btn];
        }else{
            // 添加右边按钮--编辑购物车
            [self addRightView];
            // 添加tableView
            [self addTableView];
            // 添加底部栏
            [self addBottomView];
        }
    }];
}
// 去逛逛
- (void)toBuy{
    BZHealthShopViewController *healthShopVC = [[BZHealthShopViewController alloc] init];
    healthShopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:healthShopVC animated:YES];
}
// 中间标题--购物车
- (void)addTitleView{
    CGFloat twidth = 100;
    CGFloat theight = 44;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - twidth) * 0.5, 0, twidth, theight)];
    titleLabel.text = @"购物车";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}
// 添加右边按钮--编辑购物车
- (void)addRightView{
    // 编辑按钮的图片不对,到时要更换
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-cart"] style:UIBarButtonItemStylePlain target:self action:@selector(EditShoppingCart)];
}
- (void)EditShoppingCart{

}
// 添加tableView
- (void)addTableView{
    // 添加tableViews
//    CGRect frame = [UIScreen mainScreen].bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -35, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 140;
}
// 添加底部栏
- (void)addBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, frame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    // 底部栏的子控件
      // 1. 左边全选按钮
    UIButton *allSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 100, 16)];
    [allSelectedBtn setImage:[UIImage imageNamed:@"u35"] forState:UIControlStateNormal];
    [allSelectedBtn setImage:[UIImage imageNamed:@"u37"] forState:UIControlStateSelected];
    [allSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectedBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    allSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [allSelectedBtn addTarget:self action:@selector(selectAllClick:)];
    allSelectedBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:allSelectedBtn];
      // 2. 显示花费的label
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectedBtn.bounds) + 20, 14, 100, 16)];
    costLabel.text = @"合记 ￥45";
    costLabel.textColor = [UIColor redColor];
    costLabel.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:costLabel];
      // 3.右边的结算按钮
    CGFloat balanceBtnWidth = 80;
    UIButton *balanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - balanceBtnWidth, 0, balanceBtnWidth, bottomView.bounds.size.height)];
    balanceBtn.backgroundColor = [UIColor colorWithRGB:73 G:175 B:188];
    [balanceBtn setTitle:@"去结算" forState:UIControlStateNormal];
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [balanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:balanceBtn];
    [self.view addSubview:bottomView];
}
// 点击全选按钮
- (void)selectAllClick:(UIButton *) button{
    button.selected = !button.selected;
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 创建可重用cell
    static NSString *reuseID = @"shoppingCart";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [BZShoppingCartCell cellWithTableView:tableView];
    }

    return cell;

}





@end
