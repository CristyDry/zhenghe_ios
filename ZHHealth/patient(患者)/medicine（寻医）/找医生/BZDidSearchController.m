//
//  BZDidSearchController.m
//  ZHHealth
//
//  Created by pbz on 15/12/26.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZDidSearchController.h"
#import "HWSearchBar.h"
#import "SearchRecordManager.h"
#import "BZDoctorModel.h"
#import "SearchViewController.h"
@interface BZDidSearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  HWSearchBar *searchBar;
@property (nonatomic,strong)  SearchRecordManager *recordManager;
@property (nonatomic,strong)  UITableView *searchRecordView;
@property (nonatomic,strong)  NSMutableArray *doctorModelArray;
@property (nonatomic,strong)  SearchViewController *searchController;
@end

@implementation BZDidSearchController

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
    _searchBar = [[HWSearchBar alloc] initWithFrame:CGRectMake(30, 5, kMainWidth - 60, 34)];
    self.navigationItem.titleView = _searchBar;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.clearsOnBeginEditing = YES;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
}
#pragma mark - 搜索记录
- (void)searchRecord{
    
    _recordManager = [[SearchRecordManager alloc]init];
    _recordManager.local = @"yishengjilv";
    UITableView *searchRecordView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth , kMainHeight) style:UITableViewStylePlain];
    _searchRecordView = searchRecordView;
    UIButton *clearRecordBtn = [self clearRecordBtn];
    _searchRecordView.tableFooterView = clearRecordBtn;
    _searchRecordView.delegate = self;
    _searchRecordView.dataSource = self;
    [self.view addSubview:_searchRecordView];
}
- (UIButton *)clearRecordBtn{
    
    UIButton *clearRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 44)];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [_recordManager saveRecord];
}


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
    args[@"keyword"] = keys;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            if (responseMd.response == nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有搜索到您找的专家，请检查搜索信息是否准确" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                weakSelf.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                
                SearchViewController  *searchVC = [[SearchViewController alloc] init];
                searchVC.keys = keys;
                searchVC.doctorModelArray = weakSelf.doctorModelArray;
                searchVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:searchVC animated:NO];
            }
           
        }
    }];
}


@end
