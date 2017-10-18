//
//  WCRExpertController.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WCRExpertController.h"

#import "WCRExpertCell.h"
#import "BZDoctorModel.h"

#import "BZProfessorDetailViewController.h"
#import "WCROrderController.h"

@interface WCRExpertController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *experts;

@end

@implementation WCRExpertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专家会诊";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 请求专家数据
    [self resquestProfessorsInfos];
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    // 预约说明
//    [self addRightBarButton];
    // 添加一个tableView
    [self setTableViewProperty];
    // 拨打预约热线
    [self addcallBtn];
}
#pragma mark -  拨打预约热线
- (void)addcallBtn{
    
    CGFloat heightOfBtn = 40;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, kMainHeight - heightOfBtn, kMainWidth, heightOfBtn)];
    [button buttonWithTitle:@"拨打预约热线" andTitleColor:kBackgroundColor andBackgroundImageName:nil andFontSize:KFont - 3];
    [button addTarget:self action:@selector(callThePhone)];
    button.backgroundColor = [UIColor colorWithHexString:@"05b7c3"];
    [self.view addSubview:button];

}
// 拨打预约热线
-(void)callThePhone {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"预约电话" message:@"是否拨打预约电话400-123-123？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"拨打预约热线");
        UIWebView *callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:@"tel:400-123-123"];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
// 请求专家数据
- (void)resquestProfessorsInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/expertConsultation" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.experts = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 添加一个tableView
            [self setTableViewProperty];
        }
    }];
}
-(void)setTableViewProperty {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 104) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(void)addRightBarButton{
    float width = 64;
    float height = 44;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [button buttonWithTitle:@"预约说明" andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 4];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    [button addTarget:self action:@selector(orderAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
#pragma mark - 预约说明
-(void)orderAction {
    
    WCROrderController *orderVC = [[WCROrderController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

#pragma mark - TableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _experts.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WCRExpertCell";
    WCRExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WCRExpertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.doctor = _experts[indexPath.section];
    
    return cell;
}

#pragma mark - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWCRExpertCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BZProfessorDetailViewController *doctorDetailVC = [[BZProfessorDetailViewController alloc]init];
    doctorDetailVC.doctor = _experts[indexPath.section];
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
    
}

@end
