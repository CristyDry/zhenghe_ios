//
//  BZMyOrderController.m
//  ZHHealth
//
//  Created by pbz on 15/12/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMyOrderController.h"

@interface BZMyOrderController ()
@property (nonatomic,strong)  UIButton *startBtn;
@property (nonatomic,strong)  UIView *colorLine;
@property (nonatomic,strong)  UIButton *allBtn;
@end

@implementation BZMyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.title = @"我的订单";
    [self setCustomUI];
    
}
- (void)setCustomUI{
    self.view.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    // 顶部的view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    NSArray *topBtnName = @[@"全部",@"待付款",@"待收货",@"已完成"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * kMainWidth * 0.25, 0, kMainWidth * 0.25, topView.bounds.size.height - 1)];
        topBtn.tag = i + 1;
        [topBtn setTitle:topBtnName[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topBtn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:topBtn];
        if (i == 0) {
            topBtn.selected = YES;
            _allBtn = topBtn;
        }
    }
    UIView *colorLine = [[UIView alloc] initWithFrame:CGRectMake(10, topView.bounds.size.height - 1, kMainWidth * 0.25 - 20, 1)];
    colorLine.backgroundColor = kNavigationBarColor;
    [topView addSubview:colorLine];
    _colorLine = colorLine;
    
    // tableView
    
    
}

- (void)topBtnClick:(UIButton *) topBtn{
    _allBtn.selected = NO;
    if(topBtn!=self.startBtn){
        
        self.startBtn.selected=NO;
        
        self.startBtn=topBtn;
        
    }
    self.startBtn.selected=YES;
    
    switch (topBtn.tag) {
        case 1:
        {// 点击全部
            _colorLine.x_wcr = 10;
        }
            break;
        case 2:
        {// 待付款
            _colorLine.x_wcr = kMainWidth * 0.25 + 10;
        }
            break;
        case 3:
        {// 待发货
            _colorLine.x_wcr = kMainWidth * 0.5 + 10;
        }
            break;
        case 4:
        {// 已完成
            _colorLine.x_wcr = kMainWidth * 0.75 + 10;
        }
            break;
            
        default:
            break;
    }

}








@end
