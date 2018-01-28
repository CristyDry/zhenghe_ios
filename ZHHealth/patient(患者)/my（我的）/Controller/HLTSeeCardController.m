//
//  HLTSeeCardController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTSeeCardController.h"
#import "HLTSeeCordCell.h"
#import "HLTNewCordController.h"
#import "KxMenu.h"
#import "HLTCdlistCell.h"
#import "HLTNewListController.h"

@interface HLTSeeCardController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *firstText;

@property (nonatomic, strong) HLTMRecordModel *afterCordModel;//修改后
@property (nonatomic, strong) SAMTextView *doctorTextview;
@property (nonatomic, strong) SAMTextView *medicaTextview;

@property (nonatomic, strong) UIScrollView *imageScroll;//图片滚动视图
@property (nonatomic, strong) UIView *bgView;

@end

@implementation HLTSeeCardController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isPatient) { 
        [self requestData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览病历";
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    [self addRightBarButton];
    [self setNavigationBarProperty];
    [self addTableview];
}

-(void)requestData
{
    LoginResponseAccount * accound = [LoginResponseAccount decode];
    NSMutableDictionary * args = [NSMutableDictionary dictionary];
    args[@"id"] = accound.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/medicalApiController/getHistoryList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.dataArray = [HLTMRecordModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            _cordModel = weakSelf.dataArray[_number];
            [_tableView reloadData];
        }
    }];
}

#pragma mark - 右边按钮
- (void)addRightBarButton{
    
    /*UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 30, 0, 30, 5)];
    rightBarButton.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"iconfont-gengduo-2@2x"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [rightBarButton addTarget:self action:@selector(showRightMenu:) forControlEvents:UIControlEventTouchUpInside];*/
    
}

#pragma  mark - 返回tabBar
- (void)showRightMenu:(UIButton *)sender{
    // 盲板背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    _bgView = bgView;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgView];
    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgView)];
    [bgView addGestureRecognizer:tapBgView];
    
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
    
    [KxMenu showMenuInView:bgView
                  fromRect:CGRectMake(kMainWidth - 90, 64, 90, 0)
                 menuItems:menuItems];
    [KxMenu setTintColor:[UIColor whiteColor]];
    
}
#pragma mark - 菜单点击事件
- (void) pushMenuItem:(KxMenuItem *)sender
{
    [self removeBgView];
    
    if ([sender.title isEqualToString:@"咨询"]) {
        
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 0;
        
    }else if ([sender.title isEqualToString:@"信息"]){
        
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 1;
        
    }else if ([sender.title isEqualToString:@"知识"]){
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 2;
    }else if ([sender.title isEqualToString:@"我的"]){
        
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)removeBgView {
    [_bgView removeFromSuperview];
}

#pragma mark - 添加tableview
-(void)addTableview
{
    _firstText = @[@"病历标题",@"姓名",@"性别",@"出生日期",@"科室",@"就诊时间"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight-KTopLayoutGuideHeight-5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


#pragma mark - tableview section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return AUTO_MATE_HEIGHT(50);
    }else if(section == 5){
        return 0;
    }else
        return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        
        
        CGFloat xPoint = AUTO_MATE_WIDTH(10);
        CGFloat yPoint = AUTO_MATE_HEIGHT(10);
        CGFloat width = AUTO_MATE_WIDTH(70);
        CGFloat height = AUTO_MATE_HEIGHT(20);
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.backgroundColor = kBackgroundColor;
        
        UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint*4, 0, 1, yPoint*2)];
        line1.backgroundColor = [UIColor blackColor];
        [view addSubview:line1];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, line1.maxY_wcr, width, height)];
        label.text = @"我的病程";
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint*4, label.maxY_wcr, 1, yPoint)];
        line2.backgroundColor = [UIColor blackColor];
        [view addSubview:line2];
        
        return view;
    }else
        return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section ==1){
        return 130;
    }else if (indexPath.section == 5){
        return AUTO_MATE_HEIGHT(60);
    }else if(indexPath.section == 4){
        cdList * cdlist = _cordModel.cdList[indexPath.row];
        if (cdlist.image.count>0) {
            return AUTO_MATE_HEIGHT(130);
        }else{
            return AUTO_MATE_HEIGHT(80);
        }
    }else if(indexPath.section ==3){
        if (_cordModel.image.count > 0) {
            return AUTO_MATE_HEIGHT(130);
        }
            return AUTO_MATE_HEIGHT(36);
    }else{
        return AUTO_MATE_HEIGHT(115);
    }
}


#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return _firstText.count;
    }if (section == 4) {
        if (_cordModel.cdList.count == 0) {
            return 0;
        }else
        return _cordModel.cdList.count;
    } else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat xPoint = AUTO_MATE_WIDTH(15);
    CGFloat yPoint = AUTO_MATE_HEIGHT(10);
    CGFloat width = kMainWidth-xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(75);
    
    if (indexPath.section == 0) {
        
        HLTSeeCordCell * seeCell = [[HLTSeeCordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seeCell"];
        seeCell.textString = _firstText[indexPath.row];
        seeCell.cordModel = _cordModel;
        return seeCell;
        
    }else if (indexPath.section == 1) {
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
        label.text = @"医生诊断";
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        
        _doctorTextview = [[SAMTextView alloc] initWithFrame:CGRectMake(xPoint, label.maxY_wcr+5, width, height+yPoint)];
        _doctorTextview.text = _cordModel.diagnose;
        _doctorTextview.font = [UIFont systemFontOfSize:15];
        _doctorTextview.layer.borderColor = KLineColor.CGColor;
        _doctorTextview.layer.borderWidth = 1;
        _doctorTextview.selectable = NO;
        [cell.contentView addSubview:_doctorTextview];
        return cell;
        
    }else if (indexPath.section ==2){
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
        label.text = @"基本病情";
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        
        _medicaTextview = [[SAMTextView alloc] initWithFrame:CGRectMake(xPoint, label.maxY_wcr+5, width, height)];
        _medicaTextview.text = _cordModel.Description;
        _medicaTextview.font = [UIFont systemFontOfSize:14];
        _medicaTextview.layer.borderColor = KLineColor.CGColor;
        _medicaTextview.layer.borderWidth = 1;
        _medicaTextview.selectable = NO;
        [cell.contentView addSubview:_medicaTextview];
        
        return cell;
        
    }else if (indexPath.section ==3){
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
        label.text = @"检查报告和处方单图片";
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        
        if (_cordModel.image.count >0) {
            height =AUTO_MATE_HEIGHT(120)-label.maxY_wcr;
            //  UIScrollView
            _imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(xPoint, label.maxY_wcr+3, kMainWidth-xPoint*2, height)];
            [cell.contentView addSubview:_imageScroll];
            height = height-AUTO_MATE_WIDTH(20);
            
            for (int i = 0; i<_cordModel.image.count; i++) {
                UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake((height+10)*i, 10, height, height)];
                [imageview sd_setImageWithURL:[NSURL URLWithString:_cordModel.image[i]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
                
                [_imageScroll addSubview:imageview];
                _imageScroll.contentSize = CGSizeMake(CGRectGetMaxX(imageview.frame) + 90, 0) ;
            }
        }
        return cell;
        
    }else if (indexPath.section ==4){
        
        HLTCdlistCell * cdlistCell = [tableView dequeueReusableCellWithIdentifier:@"cdlist"];
        if (!cdlistCell) {
            cdlistCell = [[HLTCdlistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cdlist"];
        }
        
        cdlistCell.cdlistModel = _cordModel.cdList[indexPath.row];
        cdlistCell.backgroundColor = kBackgroundColor;
        return cdlistCell;
        
    }else{
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        CGFloat xPoint = AUTO_MATE_WIDTH(10);
        CGFloat yPoint = AUTO_MATE_HEIGHT(10);
        CGFloat width = kMainWidth-xPoint*2;
        CGFloat height = AUTO_MATE_HEIGHT(60);
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(xPoint, 0, width, height)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        bgView.clipsToBounds = YES;
        bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bgView.layer.borderWidth = 1;
        [cell.contentView addSubview:bgView];
        
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake((width-30)*0.5, yPoint, 30, 30)];
        imageview.image = [UIImage imageNamed:@"iconfont-tianjia"];
        [bgView addSubview:imageview];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview.maxY_wcr+5, kMainWidth-xPoint*2, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"创建病程,完善病历";
        label.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:label];
        
        cell.backgroundColor = kBackgroundColor;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isPatient) {
        return;
    }
    if (indexPath.section == 4) {
        
        HLTNewListController * newList = [[HLTNewListController alloc] init];
        newList.cdlistModel = _cordModel.cdList[indexPath.row];
        newList.cordModel = _cordModel;
        newList.isEditList = YES;
        newList.isCreateList = NO;
        [self.navigationController pushViewController:newList animated:YES];
        
    }else if (indexPath.section == 5){
        
        HLTNewListController * newList = [[HLTNewListController alloc] init];
        newList.cdlistModel = _cordModel.cdList[indexPath.row];
        newList.cordModel = _cordModel;
        newList.isEditList = NO;
        newList.isCreateList = YES;
        [self.navigationController pushViewController:newList animated:YES];
        
    }else{
        
        HLTNewCordController * editCord = [[HLTNewCordController alloc] init];
        editCord.cordModel = _cordModel;
        editCord.isSeeTurn = YES;
        editCord.isNewTurn = NO;
        [self.navigationController pushViewController:editCord animated:YES];
    }
    
}

#pragma mark - 让tableview的section跟着一起滑动
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = AUTO_MATE_HEIGHT(50);
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
