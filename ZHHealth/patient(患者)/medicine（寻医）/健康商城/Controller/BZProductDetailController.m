//
//  BZProductDetailController.m
//  ZHHealth
//
//  Created by pbz on 15/12/7.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZProductDetailController.h"
#import "SDCycleScrollView.h"
#import "BZProductDetailADPictureModel.h"
#import "LoginResponseAccount.h"
#import "KxMenu.h"
#import "LoginResponseAccount.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "BZShoppingCartModel.h"
#import "BZDoctorListController.h"
#import "BZShoppingCartViewController.h"
#import "BZAddressModel.h"
#import "BZEnsureOrderController.h"
#import "WcrEditAddressViewController.h"
#import "BZShoppingCartModelSelected.h"
#import "NFXIntroViewController.h"
#define mainWidth  [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height
@interface BZProductDetailController ()<UIWebViewDelegate,SDCycleScrollViewDelegate,BZDoctorListControllerDelegate>
/**轮播器*/
@property (nonatomic,strong)  SDCycleScrollView *cycleScrollView;
/**保存广告图片数组*/
@property (nonatomic,strong)  NSArray *carouselA;
@property (nonatomic,strong)  UIScrollView *scrollView;
@property (nonatomic,strong)  LoginResponseAccount *loginaccount;
@property (nonatomic,strong)  UIButton *collectPic;
@property (nonatomic,strong)  UILabel *countLabel;
@property (nonatomic,strong)  UIButton *collectTitle;
@property (nonatomic,strong)  NSMutableArray *shoppingCartModelArray;
@property (nonatomic,strong)  UIWebView *instructionWebView;
@property (nonatomic,strong)  NSMutableArray *ADpicArray;
@end

@implementation BZProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginaccount = [LoginResponseAccount decode];
    // 请求药品数据
    [self requestProductInfos];
    // 设置导航栏
    [self navigation];
    // 底部view
    [self bottomView];
    // 请求购物车数据
    [self shoppingCartCount];
}
// 请求药品数据
- (void)requestProductInfos{
    // 取出用户ID
    LoginResponseAccount *userInfos = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"productId"] = _productId;
    args[@"userId"] = userInfos.Id;
    args[@"userType"] = @"1";
    __weak typeof (self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheProduct/getProductDesc" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            // ad图片
            weakSelf.ADpicArray = [responseMd.response objectForKey:@"carousel"];
//            weakSelf.carouselA = [BZProductDetailADPictureModel mj_objectArrayWithKeyValuesArray:carouselArray];
            // 归档到本地
            NSString *file = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BZProductDetailADPictureModel.data"];
            [NSKeyedArchiver archiveRootObject:weakSelf.ADpicArray toFile:file];
            // 药品详情
            NSDictionary *productInfos = [responseMd.response objectForKey:@"product"];
            weakSelf.productDetailInfosModel = [BZProductDetailInfosModel mj_objectWithKeyValues:productInfos];
            // 中间内容
            [self contentView];

            // 是否已收藏
            NSString *isCollect = [responseMd.response objectForKey:@"isCollect"];
            // 判断是否已登录，如果未登录，所有状态都为未收藏
            if ([LoginResponseAccount isLogin]) {
                // 已经登录
                if ([isCollect isEqualToString:@"0"]) {
                    _collectPic.selected = NO;
                    _collectTitle.selected = NO;
                }else{
                    _collectPic.selected = YES;
                    _collectTitle.selected = YES;
                }
                }else{
                // 未登录，跳转到登录界面
                    _collectPic.selected = NO;
                    _collectTitle.selected = NO;
            }
            
          }
    }];
}
// 请求购物车数据
- (void)shoppingCartCount{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"num"] = _loginaccount.Id;
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/orderApiController/buyCarList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSeaf.shoppingCartModelArray = [BZShoppingCartModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            _countLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)weakSeaf.shoppingCartModelArray.count];
        }
    }];
}
// 设置导航栏
- (void)navigation{
    [self addLeftBackItem];
    self.navigationItem.title = @"药品详情";
    // 右边按钮
    /*UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 30, 0, 30, 5)];
    rightBarButton.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"iconfont-gengduo-2@2x"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [rightBarButton addTarget:self action:@selector(showRightMenu:) forControlEvents:UIControlEventTouchUpInside];*/
}
// 右边按钮菜单
- (void)showRightMenu:(UIButton *)sender{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"咨询"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"信息"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"知识"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"我的"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      ];
  
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(mainWidth - 90, 64, 90, 0)
                 menuItems:menuItems];
    [KxMenu setTintColor:[UIColor whiteColor]];

}
- (void) pushMenuItem:(KxMenuItem *)sender
{
    
    if ([sender.title isEqualToString:@"咨询"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else if ([sender.title isEqualToString:@"信息"]){
        
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 1;
        
    }else if ([sender.title isEqualToString:@"知识"]){
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 2;
    }else if ([sender.title isEqualToString:@"我的"]){
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 3;
    }

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - 底部栏
- (void)bottomView{

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainHeight - 64, mainWidth, 64)];
    [self.view addSubview:bottomView];
    CGFloat viewH = bottomView.bounds.size.height;
    

    // 收藏
    UIView *collectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth * 0.25 - 20, viewH)];
    collectView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:collectView];
    UIButton *collectPic = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, collectView.width_wcr, 32)];
    [collectPic setImage:[UIImage imageNamed:@"iconfont-collect"] forState:UIControlStateNormal];
    [collectPic setImage:[UIImage imageNamed:@"iconfont-collect"] forState:UIControlStateHighlighted];
    [collectPic setImage:[UIImage imageNamed:@"iconfont-collect-拷贝"] forState:UIControlStateSelected];
    [collectPic setImage:[UIImage imageNamed:@"iconfont-collect-拷贝"] forState:UIControlStateHighlighted];
    [collectPic addTarget:self action:@selector(collects) forControlEvents:UIControlEventTouchUpInside];
    [collectView addSubview:collectPic];
    _collectPic = collectPic;
    UIButton *collectTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 32, collectView.width_wcr, 32)];
    collectTitle.titleLabel.font = [UIFont systemFontOfSize:14];
    [collectTitle setTitle:@"收藏" forState:UIControlStateNormal];
    [collectTitle setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectTitle addTarget:self action:@selector(collects) forControlEvents:UIControlEventTouchUpInside];
    [collectView addSubview:collectTitle];
    _collectTitle = collectTitle;
    
    // 购物车
    UIView *shoppingCartView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(collectPic.frame), 0, mainWidth * 0.25 - 20, viewH)];
    shoppingCartView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:shoppingCartView];
    UIButton *shoppingCartPic = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, shoppingCartView.width_wcr, 32)];
    [shoppingCartPic setImage:[UIImage imageNamed:@"iconfont-lumigouff580e-2@2x"] forState:UIControlStateNormal];
    [shoppingCartPic addTarget:self action:@selector(shoppingCartClick) forControlEvents:UIControlEventTouchUpInside];
    [shoppingCartView addSubview:shoppingCartPic];

    UIButton *shoppingCartTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 32, shoppingCartView.width_wcr, 32)];
    shoppingCartTitle.titleLabel.font = [UIFont systemFontOfSize:14];
    [shoppingCartTitle setTitle:@"购物车" forState:UIControlStateNormal];
    [shoppingCartTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shoppingCartTitle addTarget:self action:@selector(shoppingCartClick) forControlEvents:UIControlEventTouchUpInside];
    [shoppingCartView addSubview:shoppingCartTitle];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(shoppingCartView.width_wcr - 26, 2, 24, 20)];
    [shoppingCartView addSubview:countLabel];
    countLabel.layer.cornerRadius = 8;
    countLabel.layer.masksToBounds = YES;
    _countLabel = countLabel;
    countLabel.text = @"0";
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.backgroundColor = [UIColor redColor];
    
    // 加入购物车
    UIButton *addShoppingCart = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shoppingCartView.frame), 0, mainWidth * 0.25 + 20, viewH)];
    addShoppingCart.backgroundColor = [UIColor colorWithHexString:@"#c1c1c1"];
    [addShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addShoppingCart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addShoppingCart.titleLabel.font = [UIFont systemFontOfSize:14];
    [addShoppingCart addTarget:self action:@selector(addShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addShoppingCart];
    
    // 立即购买
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addShoppingCart.frame), 0, mainWidth * 0.25 + 20, viewH)];
    buyBtn.backgroundColor = [UIColor colorWithHexString:@"#05b7c3"];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
    
    // 分割线
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 1)];
    separateLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:separateLine];
}
// 点击收藏
- (void)collects{
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        if (_collectPic.selected == NO) {
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            LoginResponseAccount *userAccount = [LoginResponseAccount decode];
            args[@"userId"] = userAccount.Id;
            args[@"userType"] = @"1";
            args[@"thingType"] = @"b";
            args[@"thingId"] = _productId;
            args[@"status"] = @"1";
            [httpUtil doPostRequest:@"api/ZhengheDoctor/collectThing" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    _collectPic.selected = YES;
                    _collectTitle.selected = YES;
                }
            }];
        }else{
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            LoginResponseAccount *userAccount = [LoginResponseAccount decode];
            args[@"userId"] = userAccount.Id;
            args[@"userType"] = @"1";
            args[@"thingType"] = @"b";
            args[@"thingId"] = _productId;
            args[@"status"] = @"0";
            [httpUtil doPostRequest:@"api/ZhengheDoctor/collectThing" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    _collectPic.selected = NO;
                    _collectTitle.selected = NO;
                }
            }];
        }

    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

// 点击加入购物车
- (void)addShoppingCart{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您好，现暂未支持网上支付功能，敬请期待。如需购药，请拨打热线：400-334-323" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    //    [alertView show];
    // 判断是否已经登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        // 判断购物车中是否已经存在该商品
        // 判断购物车是够为空
        if (_shoppingCartModelArray.count == 0) {
            // 购物车为空
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否有为您推荐该药品的医生" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // 否
                [self addShoppingCartURLWithDoctorID:@""];
            }];
            [alert addAction:cancel];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 是
                BZDoctorListController *doctorListVC = [[BZDoctorListController alloc] init];
                doctorListVC.isAddToShoppingcart = YES;
                doctorListVC.delegate = self;
                [self.navigationController pushViewController:doctorListVC animated:YES];
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }else{
            // 购物车不为空
            for (BZShoppingCartModel *shoppingCarModel in _shoppingCartModelArray) {
                if ([shoppingCarModel.productId isEqualToString: _productDetailInfosModel.ID]) {
                    // 购物车中已存在该商品
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该药品已存在您的购物车中" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否有为您推荐该药品的医生" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        // 否
                        [self addShoppingCartURLWithDoctorID:@""];
                    }];
                    [alert addAction:cancel];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        // 是
                        BZDoctorListController *doctorListVC = [[BZDoctorListController alloc] init];
                        doctorListVC.isAddToShoppingcart = YES;
                        doctorListVC.delegate = self;
                        [self.navigationController pushViewController:doctorListVC animated:YES];
                    }];
                    [alert addAction:sure];
                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }
            }
            
        }
        
        
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - BZDoctorListControllerDelegate
- (void)pushBZProductDetailVCWithDoctorID:(NSString *)doctorID{

    [self addShoppingCartURLWithDoctorID:doctorID];
}

// 加入购物车请求
- (void)addShoppingCartURLWithDoctorID:(NSString *) doctorID{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = _loginaccount.Id;
    args[@"productId"] = _productId;
    args[@"count"] = @"1";
    args[@"doctorId"] = doctorID ;
    [httpUtil doPostRequest:@"api/orderApiController/addToBuyCar" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            [self shoppingCartCount];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"加入购物车成功";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
    }];
}

// 点击购物车
- (void)shoppingCartClick{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    BZShoppingCartViewController *shoppingCartController = [[BZShoppingCartViewController alloc] init];
    shoppingCartController.hidesBottomBarWhenPushed = YES;
    [self jumpVC:shoppingCartController];
};

// 点击购买
- (void)buyClick{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您好，现暂未支持网上支付功能，敬请期待。如需购药，请拨打热线：400-334-323" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
//    [alertView show];
    
    // 判断是否已经登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否有为您推荐该药品的医生" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 否，跳转到购买界面
            // 把选中的模型保存到本地
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:_productDetailInfosModel];
            [BZShoppingCartModelSelected encode:array];
            
            BZEnsureOrderController *ensureOrderVC = [[BZEnsureOrderController alloc] init];
            ensureOrderVC.isFormAddress = NO;
            [self.navigationController pushViewController:ensureOrderVC animated:YES];
            
    }];
        [alert addAction:cancel];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 是，跳转到选择医生界面
            BZDoctorListController *doctorListVC = [[BZDoctorListController alloc] init];
            doctorListVC.isAddToShoppingcart = NO;
            [self.navigationController pushViewController:doctorListVC animated:YES];
    }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:^{}];
        
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - 中间内容
- (void)contentView{
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainWidth, mainHeight - 128)];
    _scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    // 轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, mainWidth, mainWidth * 0.6) imageURLStringsGroup:nil];
    _cycleScrollView = cycleScrollView;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"background@3x"];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.dotColor = [UIColor redColor];
    [scrollView addSubview:cycleScrollView];
//    NSMutableArray *imagesURLStrings = [NSMutableArray array];
//    for (BZProductDetailADPictureModel *adPictureModel in _ADpicArray) {
//        [imagesURLStrings addObject:adPictureModel.avatar];
//    }
    cycleScrollView.imageURLStringsGroup = _ADpicArray;
    
    CGFloat cycleScrollViewMaxY = CGRectGetMaxY(cycleScrollView.frame);
    
    // 药品详情
    CGFloat marginH = 10;
    CGFloat marginV = 15;
    UIView *productDetailView = [[UIView alloc] init];
    [_scrollView addSubview:productDetailView];
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginV, 5, mainWidth - 20, 20)];
    nameLabel.text = self.productDetailInfosModel.productName;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [productDetailView addSubview:nameLabel];
    
    // 药品规格
    UILabel *standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginV, CGRectGetMaxY(nameLabel.frame) + marginH, mainWidth - 40, 20)];
    standardLabel.text = self.productDetailInfosModel.standard;
    standardLabel.font = [UIFont systemFontOfSize:14];
    standardLabel.textColor = [UIColor grayColor];
    standardLabel.textAlignment = NSTextAlignmentLeft;
    [productDetailView addSubview:standardLabel];
    // 药品类型
    UIImageView *type = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 40, nameLabel.frame.origin.y + 2, 30, standardLabel.bounds.size.height - 4)];
    if ([self.productDetailInfosModel.type isEqualToString:@"otc"]) {
        type.image = [UIImage imageNamed:@"otc"];
    }else{
        type.image = [UIImage imageNamed:@"rx"];
    }
    [productDetailView addSubview:type];
    // 药品价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginV, CGRectGetMaxY(standardLabel.frame) + marginH, mainWidth, 20)];
    [priceLabel setTextColor:[UIColor redColor]];
    priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f",self.productDetailInfosModel.price];
    [productDetailView addSubview:priceLabel];
    // 药品功效
    UIFont *pfunctionFont = [UIFont fontWithName:@"Arial" size:14];
    CGSize pfunctionSize = CGSizeMake(mainWidth, 800);
    
    NSString *pfunction = self.productDetailInfosModel.pfunction;
    UILabel *pfunctionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [pfunctionLabel setNumberOfLines:0];
    CGSize pfunctionLabelSize = [pfunction sizeWithFont:pfunctionFont constrainedToSize:pfunctionSize lineBreakMode:NSLineBreakByWordWrapping];
    pfunctionLabel.frame = CGRectMake(0, 5, pfunctionSize.width, pfunctionSize.height);
    pfunctionLabel.textColor = [UIColor lightGrayColor];
    pfunctionLabel.frame = CGRectMake(marginV, CGRectGetMaxY(priceLabel.frame) + marginH, pfunctionLabelSize.width -10, pfunctionLabelSize.height);
    pfunctionLabel.text = pfunction;
    pfunctionLabel.font = pfunctionFont;
    [productDetailView addSubview:pfunctionLabel];
    productDetailView.frame =CGRectMake(0, cycleScrollViewMaxY, mainWidth, CGRectGetMaxY(pfunctionLabel.frame) + 20);
           // 说明书
    // 灰色分割view
    UIView *sparetionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(productDetailView.frame) + 20, kMainWidth, 10)];
    sparetionView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:sparetionView];
    //
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(marginV, CGRectGetMaxY(sparetionView.frame), kMainWidth - marginV, AUTO_MATE_WIDTH(30))];
    label1.textAlignment = 0;
    label1.text = @"药品说明书";
    label1.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:label1];
    //
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), kMainWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:view1];
    
    UIWebView *instructionWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), kMainWidth, kMainHeight)];
    instructionWebView.delegate = self;
    _instructionWebView = instructionWebView;
    instructionWebView.backgroundColor = [UIColor redColor];
    [instructionWebView loadHTMLString:_productDetailInfosModel.explains baseURL:nil];
    [_scrollView addSubview:instructionWebView];

}
#pragma mark - 点击轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (NSString *imageUrl in _ADpicArray) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        [imagesArray addObject:image];
    }
    NFXIntroViewController *scanImageView = [[NFXIntroViewController alloc] initWithViews:imagesArray];
    [self presentViewController:scanImageView animated:YES completion:^{
        
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    webView.height_wcr = webViewHeight;
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(webView.frame));

}

// 药品详情
- (void)productDetail:(CGFloat) cycleScrollViewMaxY{
    
    CGFloat marginH = 10;
    CGFloat marginV = 15;
    UIView *productDetailView = [[UIView alloc] init];
    [_scrollView addSubview:productDetailView];
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginV, 5, mainWidth - 20, 20)];
    nameLabel.text = self.productDetailInfosModel.productName;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [productDetailView addSubview:nameLabel];
    
    // 药品规格
    UILabel *standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginV, CGRectGetMaxY(nameLabel.frame) + marginH, mainWidth - 40, 20)];
    standardLabel.text = self.productDetailInfosModel.standard;
    standardLabel.font = [UIFont systemFontOfSize:14];
    standardLabel.textColor = [UIColor grayColor];
    standardLabel.textAlignment = NSTextAlignmentLeft;
    [productDetailView addSubview:standardLabel];
    // 药品类型
    UIImageView *type = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 40, nameLabel.frame.origin.y + 2, 30, standardLabel.bounds.size.height - 4)];
    if ([self.productDetailInfosModel.type isEqualToString:@"otc"]) {
        type.image = [UIImage imageNamed:@"otc"];
    }else{
        type.image = [UIImage imageNamed:@"rx"];
    }
    [productDetailView addSubview:type];
    // 药品价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginV, CGRectGetMaxY(standardLabel.frame) + marginH, mainWidth, 20)];
    [priceLabel setTextColor:[UIColor redColor]];
    priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f",self.productDetailInfosModel.price];
    [productDetailView addSubview:priceLabel];
    // 药品功效
    UIFont *pfunctionFont = [UIFont fontWithName:@"Arial" size:14];
    CGSize pfunctionSize = CGSizeMake(mainWidth, 800);
    
    NSString *pfunction = self.productDetailInfosModel.pfunction;
    UILabel *pfunctionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [pfunctionLabel setNumberOfLines:0];
    CGSize pfunctionLabelSize = [pfunction sizeWithFont:pfunctionFont constrainedToSize:pfunctionSize lineBreakMode:NSLineBreakByWordWrapping];
    pfunctionLabel.frame = CGRectMake(0, 5, pfunctionSize.width, pfunctionSize.height);
    pfunctionLabel.textColor = [UIColor lightGrayColor];
    pfunctionLabel.frame = CGRectMake(marginV, CGRectGetMaxY(priceLabel.frame) + marginH, pfunctionLabelSize.width -10, pfunctionLabelSize.height);
    pfunctionLabel.text = pfunction;
    pfunctionLabel.font = pfunctionFont;
    [productDetailView addSubview:pfunctionLabel];
    productDetailView.frame =CGRectMake(0, cycleScrollViewMaxY, mainWidth, CGRectGetMaxY(pfunctionLabel.frame) + 20);

//    // 说明书
//    UIWebView *instructionWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pfunctionLabel.frame), kMainWidth, kMainHeight)];
//    instructionWebView.delegate = self;
//    instructionWebView.backgroundColor = [UIColor redColor];
////    instructionWebView.autoresizesSubviews = YES;//自动调整大小
////    
////    instructionWebView.scalesPageToFit =YES;//自动对页面进行缩放以适应屏幕
//  
//    [instructionWebView loadHTMLString:_productDetailInfosModel.explains baseURL:nil];
//      [self.view addSubview:instructionWebView];
  }
// 判断是否已经登录，跳转控制器
- (void)jumpVC:(UIViewController *)VC{
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
@end
