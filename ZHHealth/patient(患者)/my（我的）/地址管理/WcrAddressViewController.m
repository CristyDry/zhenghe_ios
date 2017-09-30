//
//  WcrAddressViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrAddressViewController.h"

#import "WcrAddressCell.h"
#import "BZAddressModel.h"
#import "BZEnsureOrderController.h"
#import "WcrEditAddressViewController.h"

@interface WcrAddressViewController ()<UITableViewDataSource,UITableViewDelegate,WcrAddressCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *addressArray;

@end

@implementation WcrAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.title = @"地址管理";
    [self setNavigationBarProperty];
    // 请求数据
    [self requestAddressInfos];
    [self initTableView];
    // 添加地址按钮
    [self addNewAddress];
}
- (void)viewWillAppear:(BOOL)animated{
    [self requestAddressInfos];
}
// 请求数据
- (void)requestAddressInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"num"] = account.Id;
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/addressApiController/getPatientAddress" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSeaf.addressArray = [BZAddressModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 归档进沙盒
            [BZAddressModel encode:weakSeaf.addressArray];
            BOOL a = [BZAddressModel isAddress];
            if (a == YES) {
                NSLog(@"有地址");
            }else{
                NSLog(@"无地址");
            }
            [self.tableView reloadData];
        }
    }];
}
- (void)initTableView{
   
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64)];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 0.1f)];
}
#pragma mark - 添加地址按钮 
-(void)addNewAddress {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainHeight - AUTO_MATE_HEIGHT(60), kMainWidth, AUTO_MATE_HEIGHT(60))];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    CGFloat height = AUTO_MATE_HEIGHT(40);
    CGFloat xPoint = AUTO_MATE_WIDTH(35);
    CGFloat yPoint = (bgView.height_wcr - height) / 2.0 + 5;
    CGFloat width = kMainWidth - xPoint * 2;
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [addButton setBackgroundColor:[UIColor colorWithRGB:202 G:202 B:202]];
    [addButton setTitle:@" 添加新地址" forState:0];
    [addButton setImage:[UIImage imageFileNamed:@"iconfont-tianjia" andType:YES] forState:0];
    addButton.titleLabel.font = [UIFont systemFontOfSize:KFont - 4];
    [addButton setTitleColor:kBlackColor forState:0];
    
    [addButton addTarget:self action:@selector(addAddressAction:)];
    [bgView addSubview:addButton];
    
}

#pragma mark - 添加新的地址
-(void)addAddressAction:(UIButton*)button {
    WcrEditAddressViewController *editVC = [[WcrEditAddressViewController alloc]init];
    editVC.isFromCell = NO;
    editVC.isFromShoppingCart = NO;
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark - Table View Data Source 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"cell";
    
    WcrAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WcrAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.addressModel = _addressArray[indexPath.row];
    
    return cell;
}

#pragma mark - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWcrAddressCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BZEnsureOrderController *ensureOrderVC = [[BZEnsureOrderController alloc] init];
    ensureOrderVC.addressModel = _addressArray[indexPath.row];
    ensureOrderVC.isFormAddress = YES;
    [self.navigationController pushViewController:ensureOrderVC animated:YES];
    
}

// 点击cell右边的小箭头
- (void)pushToEditAdress:(BZAddressModel *)addressModel{
    WcrEditAddressViewController *editVC = [[WcrEditAddressViewController alloc]init];
    editVC.isFromCell = YES;
    editVC.addressModel = addressModel;
    [self.navigationController pushViewController:editVC animated:YES];
}
@end
