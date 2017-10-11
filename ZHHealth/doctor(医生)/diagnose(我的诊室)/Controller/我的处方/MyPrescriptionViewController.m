//
//  MyPrescriptionViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/10.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "MyPrescriptionViewController.h"
#import "HLTPrescriptionHistoryViewControllerViewController.h"

@interface MyPrescriptionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *PrescriptionTableview;
}
@end

@implementation MyPrescriptionViewController

- (NSArray *)sectionIconArray {
    if (_sectionIconArray == nil) {
        _sectionIconArray = [NSArray arrayWithObjects:@"",@"diagnosis_icon",@"prescription_icon" ,nil];
    }
    return _sectionIconArray;
}

- (NSArray *)sectionTitleArray {
    if (_sectionTitleArray == nil) {
        _sectionTitleArray = [NSArray arrayWithObjects:@"患者信息", @"临床诊断", @"处方信息", nil];
    }
    return _sectionTitleArray;
}

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
    
    // 编辑按钮的图片不对,到时要更换
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] init];
//    rightBarButtonItem.image = [[UIImage imageNamed:@"三点"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - 处方历史点击事件
-(void)ClickPrescriptionHistory
{
    HLTPrescriptionHistoryViewControllerViewController *presctiptionHistoryVc = [GetPrescriptionStoryboard instantiateViewControllerWithIdentifier:@"HLTPrescriptionHistoryViewControllerViewController"];
    [self.navigationController pushViewController:presctiptionHistoryVc animated:YES];
}

#pragma mark - UIDatasource 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"UserMessageCell";
    } else if (indexPath.section == 1) {
        identifier = @"SymptomsCell";
    } else {
        identifier = @"DrugMessageCell";
    }
    cell  = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 145;
    } else if (indexPath.section == 1) {
        return 76;
    } else {
        return 69;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 40)];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame) + 10, 10, 60, 30)];
    sectionTitle.textColor = [UIColor darkGrayColor];
    sectionTitle.font = [UIFont systemFontOfSize:17];
    sectionTitle.textAlignment = NSTextAlignmentLeft;
    iconImage.image = [UIImage imageFileNamed:[NSString stringWithFormat:@"%@",self.sectionIconArray[section]] andType:YES];
    sectionTitle.text = self.sectionTitleArray[section];
    
    [headerView addSubview:iconImage];
    [headerView addSubview:sectionTitle];
    headerView.backgroundColor = [UIColor clearColor];
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
