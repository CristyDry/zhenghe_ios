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
#import "BZShoppingCartModel.h"
#import "BZProductDetailController.h"
#import "BZAddressModel.h"
#import "WcrEditAddressViewController.h"
#import "BZEnsureOrderController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BZShoppingCartModelSelected.h"
@interface BZShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,BZShoppingCartCellDelegate>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSMutableArray *shoppingCartModelArray;
@property (nonatomic)  BOOL isAllSeleced;
@property (nonatomic,strong)  UIButton *allSelectedBtn;
@property (nonatomic,strong)  UILabel *costLabel;
@property (nonatomic,strong)  NSMutableArray *shoppingCartModelSelected;
@property (nonatomic,strong)  UIButton *balanceBtn;
@property (nonatomic,strong)  UIButton *deleteBtn ;
@property (nonatomic,strong)  NSString *productId;
@property (nonatomic,assign)  CGFloat totalCost;
@property (nonatomic,strong)  LoginResponseAccount *account;
@end

@implementation BZShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 请求数据
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self requestInfos];
    // 添加返回按钮
    [self addLeftBackBtn];
    // 添加中间标题--购物车
    self.title = @"购物车";
}
// 请求数据
- (void)requestInfos{
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    _account = [LoginResponseAccount decode];
    args[@"num"] = _account.Id;
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/orderApiController/buyCarList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if ([responseMd.msg isEqualToString:@"购物车是空的"]) {
            [_tableView removeFromSuperview];
            self.view.backgroundColor = [UIColor whiteColor];
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
            weakSeaf.shoppingCartModelArray = [BZShoppingCartModel mj_objectArrayWithKeyValuesArray:responseMd.response];
        }
    }];
}
// 去逛逛
- (void)toBuy{
    BZHealthShopViewController *healthShopVC = [[BZHealthShopViewController alloc] init];
    healthShopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:healthShopVC animated:YES];
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
    self.tabBarController.selectedIndex = 3;
}
// 添加右边按钮--编辑购物车
- (void)addRightView{
    float width = 17;
    float height = 17;
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageNamed:@"img_my_editor"];
    
    [editBtn setBackgroundImage:image forState:0];
    [editBtn setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    
    [editBtn addTarget:self action:@selector(EditShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
}
// 编辑购物车
- (void)EditShoppingCart:(UIButton *) editBtn{
    [_shoppingCartModelSelected removeAllObjects];
    editBtn.selected = !editBtn.selected;
    if (editBtn.selected == YES) {
        _deleteBtn.hidden = NO;
        _costLabel.hidden = YES;
        _balanceBtn.hidden = YES;
    }else{
        _deleteBtn.hidden = YES;
        _costLabel.hidden = NO;
        _balanceBtn.hidden = NO;
    }
}
// 添加tableView
- (void)addTableView{
    // 添加tableViews
    TPKeyboardAvoidingTableView *tptableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64-44)];
    [self.view addSubview:tptableView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight -64 - 44) style:UITableViewStylePlain];
    [tptableView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 140;
}
// 添加底部栏
- (void)addBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainHeight - 44, kMainWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    // 底部栏的子控件
      // 1. 左边全选按钮
    UIButton *allSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 14, 30, 16)];
    self.allSelectedBtn = allSelectedBtn;
    [allSelectedBtn setImage:[UIImage imageNamed:@"u35"] forState:UIControlStateNormal];
    [allSelectedBtn setImage:[UIImage imageNamed:@"u37"] forState:UIControlStateSelected];
    [allSelectedBtn addTarget:self action:@selector(selectAllClick:)];
    allSelectedBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:allSelectedBtn];
    UILabel *allSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectedBtn.frame), 14, 70, 16)];
    allSelectedLabel.text = @"全选";
    [bottomView addSubview:allSelectedLabel];
      // 2. 显示花费的label
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectedLabel.bounds) + 20, 14, 100, 16)];
    _costLabel = costLabel;
    costLabel.hidden = NO;
    costLabel.text = @"合记 ￥";
    costLabel.textColor = [UIColor redColor];
    costLabel.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:costLabel];
      // 3.右边的结算按钮
    CGFloat balanceBtnWidth = 80;
    UIButton *balanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - balanceBtnWidth, 0, balanceBtnWidth, bottomView.bounds.size.height)];
    _balanceBtn = balanceBtn;
    balanceBtn.hidden = NO;
    [balanceBtn addTarget:self action:@selector(balanceClick) forControlEvents:UIControlEventTouchUpInside];
    balanceBtn.backgroundColor = [UIColor colorWithRGB:73 G:175 B:188];
    [balanceBtn setTitle:@"去结算" forState:UIControlStateNormal];
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [balanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:balanceBtn];
    // 删除按钮
    CGFloat deleteWidth = 80;
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - deleteWidth - 20, 7, deleteWidth, 30)];
    _deleteBtn = deleteBtn;
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = YES;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = [UIColor redColor].CGColor;
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.cornerRadius = 2;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [bottomView addSubview:deleteBtn];
    [self.view addSubview:bottomView];
    
}

// 点击全选按钮
- (void)selectAllClick:(UIButton *) button{
   button.selected = !button.selected;
    if (button.selected == YES) {
        for (BZShoppingCartModel *shoppingCarModel in self.shoppingCartModelArray) {
            shoppingCarModel.isSelected = YES;
        }

    }else{
        for (BZShoppingCartModel *shoppingCarModel in self.shoppingCartModelArray) {
            shoppingCarModel.isSelected = NO;
        }
}
    [self.tableView reloadData];
    [self setAllCost];
    
}

// 点击删除按钮
- (void)deleteClick{
    [_shoppingCartModelSelected removeAllObjects];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = account.Id;
    for (BZShoppingCartModel *shoppingCartModel in _shoppingCartModelArray) {
        if (shoppingCartModel.isSelected == YES) {
            [_shoppingCartModelSelected addObject:shoppingCartModel];
            switch (_shoppingCartModelSelected.count) {
                case 0:
                    return;
                    break;
                case 1:
                       {   BZShoppingCartModel *shoppingCartModel = _shoppingCartModelSelected[0];
                           _productId = shoppingCartModel.ID;
                        }
                    break;
                default:
                        {
                            NSMutableArray *profuctIdArray = [[NSMutableArray alloc]init];
                            for (BZShoppingCartModel *shoppingCartModelSelected in _shoppingCartModelSelected) {
                                [profuctIdArray addObject:shoppingCartModelSelected.ID];
                            }
                            NSString *productIdString = [profuctIdArray componentsJoinedByString:@","];
                            _productId = productIdString;
                        }
                break;
            }
        }
    }
    args[@"cartIds"] = _productId;;
    [httpUtil doPostRequest:@"api/orderApiController/delFromBuyCar" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            [self requestInfos];
        }
    }];
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _shoppingCartModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 创建可重用cell
    static NSString *reuseID = @"shoppingCart";
    BZShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [BZShoppingCartCell cellWithTableView:tableView];
    }
    cell.shoppingCartModel = _shoppingCartModelArray[indexPath.row];
    cell.delegate = self;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BZProductDetailController * productVC = [[BZProductDetailController alloc] init];
    BZShoppingCartModel *shoppingCartModel = _shoppingCartModelArray[indexPath.row];
    productVC.productId = shoppingCartModel.productId;
    [self.navigationController pushViewController:productVC animated:YES];

}
#pragma mark - BZShoppingCartCellDelegate
- (void)isAllSelecteds:(BOOL)isAllSelected{
    if (isAllSelected == NO) {
        self.allSelectedBtn.selected = NO;
    }
}

// 设置总花费
- (void)setAllCost{
    _shoppingCartModelSelected = [[NSMutableArray alloc] init];
    CGFloat totalCost = 0.0f;
    for (BZShoppingCartModel *shoppingCartModel in _shoppingCartModelArray) {
        if (shoppingCartModel.isSelected == YES) {
            [_shoppingCartModelSelected addObject:shoppingCartModel];
            
             totalCost = totalCost + shoppingCartModel.sumPrice;
            _totalCost = totalCost;
            _costLabel.text = [NSString stringWithFormat:@"合记 ￥%0.2f",totalCost];
        }else{
            if ( _shoppingCartModelSelected.count == 0 ) {
                _costLabel.text = @"合记 ￥";
            }
        }
    }
    if (_shoppingCartModelSelected.count == _shoppingCartModelArray.count) {
        _allSelectedBtn.selected = YES;
    }else{
        _allSelectedBtn.selected = NO;
    }
}

// 点击结算按钮
- (void)balanceClick{

    // 把选中的模型保存到本地
    [BZShoppingCartModelSelected encode:_shoppingCartModelSelected];
    // 如果没有选中商品，弹出提示框
    if (_shoppingCartModelSelected.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"还没有选中商品，请选中您要购买的商品后再去结算" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if ([BZAddressModel isAddress]) {
        BZEnsureOrderController *ensureOrderVC = [[BZEnsureOrderController alloc] init];
        ensureOrderVC.isFormAddress = NO;
        [self.navigationController pushViewController:ensureOrderVC animated:YES];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置收货地址，请点击这里设置!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳到新建地址界面
            WcrEditAddressViewController *editVC = [[WcrEditAddressViewController alloc]init];
            editVC.isFromCell = NO;
            editVC.isFromShoppingCart = YES;
            [self.navigationController pushViewController:editVC animated:YES];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}




@end
