//
//  SoSlideScrollView.h
//  EHRMobile
//
//  Created by soso on 15/4/14.
//  Copyright (c) 2015年 seebon. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef void(^SelectIndex)(NSInteger index ,UITableView *tableView);
@interface SoSlideScrollView : UIView<UIScrollViewDelegate>
{
    
}
@property (nonatomic ,strong) UIScrollView *titleScrollview;   // 视图顶部标题

@property (nonatomic ,strong) UIScrollView *scrollview;        // 主视图

@property (nonatomic,copy) SelectIndex selectBtnBlock;       // 当发生改变

@property (nonatomic,assign) NSInteger indexSelect;            // 当前显示的位置

@property (nonatomic,assign) BOOL isNews;                      // 是否显示消息提示

/**   标示栏数据 arrTitle为字符串数组  */
@property(nonatomic,strong)NSMutableArray *arrTitle;

/** @brief  内容数据 arrContent为UIView数组
 *  @brief  arrContent 展示中的三个View */
@property(nonatomic,strong)NSMutableArray *arrContent;

/** initailzer  */
-(void)so_initCreate;

/** initailzer */
-(void)so_initCreateTitles:(NSMutableArray*)titles ContentViews:(NSMutableArray*)views;

/** click button for title  */
-(void)setSelectBtnBlock:(void(^)(NSInteger index,UITableView *tableView))selectBlock;


@end
