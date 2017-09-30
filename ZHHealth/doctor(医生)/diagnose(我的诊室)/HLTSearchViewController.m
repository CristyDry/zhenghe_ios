//
//  HLTSearchViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTSearchViewController.h"
#import "HLTSearch.h"
#import "HLTSearchCell.h"
#import "HLTChatViewController.h"

@interface HLTSearchViewController ()  <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *statusBarView;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cacheArray;   // 搜索记录

@property (nonatomic, strong) NSMutableArray *resultArray;  // 搜索结果

@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic) BOOL isSearch;



@end

@implementation HLTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 从本地获取搜索记录
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/cacheSearch.plist",NSHomeDirectory()];
//    _cacheArray = [NSMutableArray arrayWithContentsOfFile:path];
//    if (!_cacheArray) {
//        _cacheArray = [[NSMutableArray alloc]init];
//    }
    
    [self addCustomRightBackItem];
    
    self.view.backgroundColor = kBackgroundColor;
    
    _isSearch = YES;
    if (_isFromFind) {
        _isSearch = NO;
    }
    
    [self customSearchUI];
    [self requestSearchData];
}

#pragma mark - 获取患者数据
-(void)requestSearchData
{
    self.resultArray = [[NSMutableArray alloc] initWithCapacity:45];
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"doctorId"] = account.Id;
    args[@"key"] = _searchTF.text;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/searchPatient" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.resultArray = [HLTSearch mj_objectArrayWithKeyValuesArray:responseMd.response];
            if (weakSelf.resultArray.count == 0) {
                 weakSelf.alertLabel.hidden = NO;
            }
           [_tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customBarProperty];
}

#pragma mark - 导航栏视图
-(void)customBarProperty {
    
    // 导航栏
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kMainWidth, 20)];
    statusBarView.backgroundColor=[UIColor colorWithHexString:@"#05b7c3"];
    _statusBarView = statusBarView;
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    CGFloat xPoint = 0.0;
    CGFloat yPoint = 5.0;
    CGFloat width = kMainWidth - 35;
    CGFloat height = 44 - yPoint * 2;
    CGRect frame = CGRectMake(xPoint, yPoint, width, height);
    
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    _searchTF = textfield;
    [textfield textFieldWithPlaceholder:nil andFont:KFont - 4 andSecureTextEntry:NO];
    UIImage *leftImage = [UIImage imageFileNamed:@"iconfont-sousuo" andType:YES];
    UIButton *leftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, frame.size.height)];
    [leftView setImage:leftImage forState:0];
    leftView.userInteractionEnabled = NO;
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.delegate = self;
    textfield.returnKeyType = UIReturnKeySearch;
    UIImage *image = [UIImage imageFileNamed:@"搜索框" andType:YES];
    textfield.background = image;
    
    self.navigationItem.titleView = textfield;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 17)]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

#pragma mark - 右边取消按钮
-(void)addCustomRightBackItem
{
    float width = 40;
    float height = 28;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    //UIImage *image = [UIImage imageFileNamed:@"12" andType:YES];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#05b7c3"] forState:UIControlStateNormal];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:0];
    
    [button addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)backLeftNavItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 搜索界面
-(void)customSearchUI {
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+1, kMainWidth, kMainHeight) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    
    // 没有搜索到内容的提示
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight + 30, kMainWidth, 30)];
    self.alertLabel = alertLabel;
    self.alertLabel.hidden = YES;
    alertLabel.text = @"亲，没有找到你想要的结果";
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLabel];
    
}


#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = @"searchCell";
    HLTSearchCell * searchCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!searchCell) {
        searchCell = [[HLTSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    searchCell.searchModel = _resultArray[indexPath.row];
    return searchCell;
    
}


#pragma mark - cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    huanzhe * huanzheModel = _resultArray[indexPath.row];
    HLTChatViewController *conversationVC = [[HLTChatViewController alloc]init];
    conversationVC.conversationType =  ConversationType_PRIVATE;
    conversationVC.targetId = huanzheModel.ID;
    conversationVC.title =  huanzheModel.patient;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:conversationVC];
    [self presentViewController:nvc animated:YES completion:nil];
}


#pragma mark - tableView 在滑动的过程中，收起键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchTF  resignFirstResponder];
}


#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (_searchTF.text.length > 0) {
        [self requestSearchData];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _isSearch = YES;
    [_tableView reloadData];
    
    return YES;
}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_statusBarView removeFromSuperview];
    
    [self setNavigationBarProperty];
    
    for (NSString *string in _cacheArray) {
        NSLog(@"cache:%@",string);
    }
    
    // 将搜索记录缓存
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/cacheSearch.plist",NSHomeDirectory()];
//    [_cacheArray writeToFile:path atomically:YES];
    
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
