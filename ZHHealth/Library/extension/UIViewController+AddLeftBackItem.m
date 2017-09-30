//
//  UIViewController+AddLeftBackItem.m
//  1212
//
//  Created by 全日制 on 15/6/13.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIViewController+AddLeftBackItem.h"

@interface UIViewController()

@end


@implementation UIViewController (AddLeftBackItem)

/**
 *
 *  定义返回按钮
 *
 */
-(void)addLeftBackItem
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
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  设置导航栏的属性
 *  字体大小和颜色
 *  导航栏的颜色
 *  状态栏的颜色
 */
-(void)setNavigationBarProperty{
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:22]};
    
    self.view.backgroundColor = kBackgroundColor;
    
    UIImage *image = [UIImage imageFileNamed:@"背景-拷贝" andType:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:image]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)initializationTableViewWithTableView:(UITableView*)tableView {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 0.001)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 0.001)];
    [self.view addSubview:tableView];
}


#pragma mark - 左右滑动切换控制器
/*
-(void)addGestureRecognizerToSlider{
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
}
 */
/*
- (void) tappedRightButton:(id)sender{
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    NSArray *aryViewController = self.tabBarController.viewControllers;
    
    if (selectedIndex < aryViewController.count - 1) {
        
        UIView *fromView = [self.tabBarController.selectedViewController view];
        
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex + 1] view];
        
        [UIView transitionFromView:fromView toView:toView duration:0.3f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            
            if (finished) {
                
                [self.tabBarController setSelectedIndex:selectedIndex + 1];
                
            }
            
        }];
        
    }
    
}
 */
/*
- (void) tappedLeftButton:(id)sender{
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    if (selectedIndex > 0) {
        
        UIView *fromView = [self.tabBarController.selectedViewController view];
        
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex - 1] view];
        
        [UIView transitionFromView:fromView toView:toView duration:0.3f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            
            if (finished) {
                
                [self.tabBarController setSelectedIndex:selectedIndex - 1];
                
            }
            
        }];
        
    }
}
*/

-(UIButton *)addRightBarButtomWithImageName:(NSString *)imageName {
    
    float width = 30;
    float height = 30;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageFileNamed:imageName andType:YES];
    [button setImage:image forState:0];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    
    return button;
}

@end
