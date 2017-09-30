//
//  BZBeginSearchViewController.m
//  ZHHealth
//
//  Created by pbz on 15/12/3.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZBeginSearchViewController.h"
#import "HWSearchBar.h"
#import "BZSearchResultViewController.h"
#import "BZSearchResultModel.h"
#import "BZClassifyAccount.h"
#import "SearchRecordManager.h"
#import "BZDoctorListController.h"
#define mainWidth  [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height
@interface BZBeginSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BZDoctorListControllerDelegate>
@property (nonatomic,strong)  NSArray *searchResultA;
@property (nonatomic,strong)  UITextField *searchBar;
@property (nonatomic,strong)  UITableView *searchRecordView;
@property (nonatomic,strong)  SearchRecordManager *recordManager;
@end

@implementation BZBeginSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏返回按钮
    [self addLeftBackItem];
    // 搜索框
    [self initSearchBar];
    // 搜索记录
    [self searchRecord];
    
}
// 搜索框
- (void)initSearchBar{
    _searchBar = [[HWSearchBar alloc] initWithFrame:CGRectMake(30, 5, mainWidth - 60, 34)];
    self.navigationItem.titleView = _searchBar;
    _searchBar.delegate = self;
    _searchBar.clearsOnBeginEditing = YES;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
}
#pragma mark - 搜索记录
- (void)searchRecord{
    
   _recordManager = [[SearchRecordManager alloc]init];
    _recordManager.local = @"yaopinsousuojilv";
    UITableView *searchRecordView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight) style:UITableViewStylePlain];
    _searchRecordView = searchRecordView;
    UIButton *clearRecordBtn = [self clearRecordBtn];
    _searchRecordView.tableFooterView = clearRecordBtn;
    _searchRecordView.delegate = self;
    _searchRecordView.dataSource = self;
    [self.view addSubview:_searchRecordView];
}
- (UIButton *)clearRecordBtn{

    UIButton *clearRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 44)];
    [clearRecordBtn buttonWithTitle:@"清除历史记录" andTitleColor:[UIColor redColor] andBackgroundImageName:nil andFontSize:13];
    [clearRecordBtn addTarget:self action:@selector(clearRecord)];
    return clearRecordBtn;
}
// 清除记录
- (void)clearRecord{
    
    [_recordManager cleanSearchRecord];
    [_searchRecordView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordManager.recordArray.count;
  }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    static NSString *reuseID = @"clearRecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    // 给cell赋值
    cell.textLabel.text = [_recordManager.recordArray objectAtIndex:indexPath.row];
    
    // 返回cell
    return cell;
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [_recordManager saveRecord];
//}

#pragma mark - 搜索框代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_recordManager addNewSearchWord:textField.text];
    // 请求搜索数据
    if (textField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"搜索内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self doPostRuquest:textField.text];
    }
    
    return YES;
}
// 点击搜索记录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 请求搜索数据
    [self doPostRuquest:cell.textLabel.text];
    [_recordManager addNewSearchWord:cell.textLabel.text];
}
// 请求搜索数据
- (void)doPostRuquest:(NSString *) keys{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"keys"] = keys;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheProduct/searchProduct" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.searchResultA = [BZSearchResultModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            
            BZSearchResultViewController  *searchController = [[BZSearchResultViewController alloc] init];
            searchController.classifyInfos = _classifyInfos;
            searchController.keys = keys;
            searchController.isFormClassify = NO;
            searchController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchController animated:NO];
        }
    }];
}

@end
