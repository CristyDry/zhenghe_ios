//
//  BaseTabBarController.m
//  ZHHealth
//
//  Created by pbz on 15/12/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+(BaseTabBarController *)sharedTabBarController{

    static BaseTabBarController *tabBarVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarVC = [[BaseTabBarController alloc]init];
    });
    
    return tabBarVC;
}


@end
