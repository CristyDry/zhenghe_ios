//
//  UIViewController+AddLeftBackItem.h
//  1212
//
//  Created by 全日制 on 15/6/13.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AddLeftBackItem)


/**
 *
 *  定义返回按钮
 *
 */
-(void)addLeftBackItem;

/**
 *  设置导航栏的属性
 *  字体大小和颜色
 *  导航栏的颜色
 *  状态栏的颜色
 */
-(void)setNavigationBarProperty;

//-(void)addGestureRecognizerToSlider;

/*
 *  imageName
 *  @return  button
 */
-(UIButton*)addRightBarButtomWithImageName:(NSString*)imageName;


-(void)initializationTableViewWithTableView:(UITableView*)tableView;

@end
