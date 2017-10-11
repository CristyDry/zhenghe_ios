//
//  HLTPrescriptionHistoryViewControllerViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/10.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "HLTPrescriptionHistoryViewControllerViewController.h"
#import "SoSlideScrollView.h"
#import "OrderTableViewCell.h"
@interface HLTPrescriptionHistoryViewControllerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet SoSlideScrollView *_contentView;
    int _orderType;   //2：已经取消  0：待接收  1：已接收 3：医生取消
    UITableView *_currentTableView;
    NSMutableArray *arr;
}

@end

@implementation HLTPrescriptionHistoryViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处方记录";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    
    [self setUIAction];
}


#pragma mark - setUI -
-(void)setUIAction{
    
    arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<4; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight-32-64) style:UITableViewStyleGrouped];
        tableView.tag = 10 + i;
        [tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"OrderCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc]init];
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:(CGRect){0,0,5,5}];
        [arr addObject:tableView];
    }
    NSMutableArray *arrTitle=[[NSMutableArray alloc]initWithArray:@[@"待接收",@"已完成",@"药店取消",@"医生取消"]];
    [_contentView so_initCreateTitles:arrTitle ContentViews:arr];
    _contentView.selectBtnBlock = ^(NSInteger index,UITableView *tableView){
        
        
        switch (index) {
            case 0:
            {
                _orderType = 0;
                _currentTableView = tableView;
                
            }
                break;
            case 1:
            {
                _orderType = 1;
                _currentTableView = tableView;
                
            }
                break;
            case 2:
            {
                _orderType = 2;
                _currentTableView = tableView;
                
            }
                break;
            case 3:
            {
                _orderType = 3;
                _currentTableView = tableView;
                
            }
                break;

            default:
                break;
        }
    };
    
    _orderType = 1;
    _currentTableView = arr[0];
}

#pragma mark UITableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:(CGRect){0,0,10,10}];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"OrderCell";
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @try {
        if (tableView.tag == 10) {
            
        } else if (tableView.tag == 11) {
            
        } else if (tableView.tag == 12) {
            
        } else if (tableView.tag == 13) {
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        //
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
