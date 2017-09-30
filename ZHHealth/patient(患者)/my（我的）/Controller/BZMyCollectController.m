//
//  BZMyCollectController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMyCollectController.h"
#import "BZProductsCollectController.h"
#import "BZArticleCollectController.h"

@interface BZMyCollectController ()

@property (nonatomic,strong)  UIButton *articleBtn;
@property (nonatomic,strong)  UIButton *productBtn;
@property (nonatomic,strong)  UIView *line;
@end

@implementation BZMyCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    [self addLeftBackItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的收藏";
    [self setTopView];
}


-(void)setTopView{
    
    CGFloat height = 50;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, height)];
    [self.view addSubview:topView];
    topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    topView.layer.borderWidth = 1;
    
    CGFloat pointX = 20;
    UIButton *articleBtn = [[UIButton alloc] initWithFrame:CGRectMake(pointX, 0, kMainWidth * 0.5 - pointX * 2, height)];
    [articleBtn setTitle:@"文章" forState:UIControlStateNormal];
    articleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    articleBtn.tag = 1;
    articleBtn.selected = YES;
    [articleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [articleBtn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
    [articleBtn addTarget:self action:@selector(clickBtn:)];
    [topView addSubview:articleBtn];
    _articleBtn = articleBtn;
    
    UIButton *productBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(articleBtn.frame) + pointX, 0, articleBtn.bounds.size.width, height)];
    [productBtn buttonWithTitle:@"药品" andTitleColor:[UIColor blackColor] andBackgroundImageName:nil andFontSize:18];
    productBtn.tag = 2;
    [productBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [productBtn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
    [productBtn addTarget:self action:@selector(clickBtn:)];
    [topView addSubview:productBtn];
    _productBtn = productBtn;
    
    // line
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(pointX, 48, kMainWidth * 0.5 - pointX * 2, 1)];
    line.backgroundColor = kNavigationBarColor;
    [topView addSubview:line];
    _line = line;
    // 文章
    BZArticleCollectController *ArticleCollectVC = [[BZArticleCollectController alloc] init];
    [self addChildViewController:ArticleCollectVC];
    
    // 药品
    BZProductsCollectController *ProductsCollectVC = [[BZProductsCollectController alloc] init];
    [self addChildViewController:ProductsCollectVC];
    
}
- (void)clickBtn:(UIButton *)btn{
    if (btn.tag == 1) {
        _articleBtn.selected = YES;
        _productBtn.selected = NO;
        self.selectedIndex = 0;
        _line.x_wcr = 20;
        
    }else{
     
        _articleBtn.selected = NO;
        _productBtn.selected = YES;
        self.selectedIndex = 1;
        _line.x_wcr = CGRectGetMaxX(_articleBtn.frame) + 20;
    }
}

@end
