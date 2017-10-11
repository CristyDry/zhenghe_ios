//
//  MyPrescriptionViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/10.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "MyPrescriptionViewController.h"
#import "HLTPrescriptionHistoryViewControllerViewController.h"
#import "ShoppingCountView.h"

@interface MyPrescriptionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *PrescriptionTableview;
    
}
@end

@implementation MyPrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处方信息";
    PrescriptionTableview.dataSource = self;
    PrescriptionTableview.delegate = self;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addRightButton];
    
}

#pragma mark - 右边新建按钮
-(void)addRightButton
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setImage:[UIImage imageNamed:@"三点"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ClickPrescriptionHistory) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
#pragma mark - 处方历史点击事件
-(void)ClickPrescriptionHistory
{
    HLTPrescriptionHistoryViewControllerViewController *presctiptionHistoryVc = [GetPrescriptionStoryboard instantiateViewControllerWithIdentifier:@"HLTPrescriptionHistoryViewControllerViewController"];
    [self.navigationController pushViewController:presctiptionHistoryVc animated:YES];
}

#pragma mark - UIDatasource 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *identifier = @"DrugMessageCell";;
    cell  = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 50)];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame) + 8, 8, kMainWidth-100, 30)];
    sectionTitle.font = [UIFont systemFontOfSize:17];
    sectionTitle.textAlignment = NSTextAlignmentLeft;
    iconImage.image = [UIImage imageFileNamed:@"prescription_icon" andType:YES];
    sectionTitle.text = @"处方信息";
    
    [headerView addSubview:iconImage];
    [headerView addSubview:sectionTitle];
    headerView.backgroundColor = RGBACOLOR(218, 218, 218, 0.82);
    return headerView;
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
