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
#import "SpriteImageView.h"
#import "HLTPrescriptionDetailViewController.h"
#import "ChuFangStatementsViewController.h"

@interface HLTPrescriptionHistoryViewControllerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet SoSlideScrollView *_contentView;
    __weak IBOutlet UIView *NothingView;
    
    int _orderType;   //0：待接收  1：已接收 2：已经取消  3：医生取消
    UITableView *_currentTableView;
    NSMutableArray *arr;
    NSArray *ChuFangHistoryArray;
}

@end

@implementation HLTPrescriptionHistoryViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处方记录";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addRightButton];
    
    [self setUIAction];
    [self loadChuFangHistoryData];
}
#pragma mark - 右边新建按钮
-(void)addRightButton
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setImage:[UIImage imageNamed:@"三点"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ClickPrescriptionStatements) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
#pragma mark - 处方报表跳转
-(void)ClickPrescriptionStatements
{
    ChuFangStatementsViewController *ChuFangStatementsVC = [GetPrescriptionStoryboard instantiateViewControllerWithIdentifier:@"ChuFangStatementsViewController"];
    [self.navigationController pushViewController:ChuFangStatementsVC animated:YES];
}
#pragma mark - setUI -
-(void)setUIAction{
    arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<4; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight-32-64-10) style:UITableViewStyleGrouped];
        tableView.tag = 10 + i;
        [tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"ChuFangCell"];
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
                [self loadChuFangHistoryData];
            }
                break;
            case 1:
            {
                _orderType = 1;
                _currentTableView = tableView;
                [self loadChuFangHistoryData];
            }
                break;
            case 2:
            {
                _orderType = 2;
                _currentTableView = tableView;
                [self loadChuFangHistoryData];
            }
                break;
            case 3:
            {
                _orderType = 3;
                _currentTableView = tableView;
                [self loadChuFangHistoryData];
            }
                break;
                
            default:
                break;
        }
    };
    
    _orderType = 0;
    _currentTableView = arr[0];
}
#pragma mark 加载数据
- (void)loadChuFangHistoryData {
    // 取出医生id
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"status"] = [NSString stringWithFormat:@"%d",_orderType];
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    args[@"userId"] = account.Id;
//    args[@"id"] = ;
    [httpUtil doPostRequest:@"api/ZhengheRx/list" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            if (responseMd.isResultOk) {
                switch (_orderType) {
                    case 0:  {// 1：待接收
                        ChuFangHistoryArray = responseMd.response;
                        UITableView *tableView = (UITableView *)[_contentView viewWithTag:10];
                        [tableView reloadData];
                    }break;
                    case 1:{  // 1：已接收
                        ChuFangHistoryArray = responseMd.response;
                        UITableView *tableView = (UITableView *)[_contentView viewWithTag:11];
                        [tableView reloadData];
                    } break;
                    case 2:{  // 2：已经取消
                        ChuFangHistoryArray = responseMd.response;
                        UITableView *tableView = (UITableView *)[_contentView viewWithTag:12];
                        [tableView reloadData];
                    }break;
                    case 3:{  // 3：医生取消
                        ChuFangHistoryArray = responseMd.response;
                        UITableView *tableView = (UITableView *)[_contentView viewWithTag:13];
                        [tableView reloadData];
                    }break;
                        
                    default:
                        break;
                }
                if (ChuFangHistoryArray.count == 0) {
                    [self.view bringSubviewToFront:NothingView];
                } else {
                    [self.view sendSubviewToBack:NothingView];
                }

            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据有误，请重新点击" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }
    }];
}

- (void)requestCancleOrder:(NSString *)orderStr {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要取消处方，取消后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = orderStr;
        //    args[@"id"] = ;
        [httpUtil doPostRequest:@"api/ZhengheRx/cancel" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self loadChuFangHistoryData];
            }
        }];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark UITableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 208;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return ChuFangHistoryArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:(CGRect){0,0,10,10}];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ChuFangCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @try {
        NSDictionary *chufangDic = ChuFangHistoryArray[indexPath.section];
        NSLog(@"%@",chufangDic);
        @try {
            cell.chuFangNumLable.text = [NSString stringWithFormat:@"处方号：%@",chufangDic[@"rxNo"]];
            cell.chuFangStutusLable.text = [NSString stringWithFormat:@"%@",chufangDic[@"statusName"]];
            cell.chuFangAmountLable.text = [NSString stringWithFormat:@"实付款：¥ %.2f",[chufangDic[@"totalAmount"] floatValue]];
            cell.chuFangTimeLable.text = [NSString stringWithFormat:@"%@",chufangDic[@"rxDate"]];
            
            cell.btnBlock = ^(UIButton *btn) {
                // 操作点击事件
                switch (_orderType) {
                    case 0:  {// 1：待接收
                        [self requestCancleOrder:chufangDic[@"id"]];
                    }break;
                    case 1:{  // 1：已接收
                        
                    } break;
                    case 2:{  // 2：已经取消

                    }break;
                    case 3:{  // 3：医生取消

                    }break;
                        
                    default:
                        break;
                }

            };
            if (tableView.tag == 10) {
                NSMutableArray *ChuaFangArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *urldic in chufangDic[@"zhengheRxDetailList"]) {
                    [ChuaFangArr addObject:urldic[@"imgUrl"]];
                }
                cell.spriteImageView.imageArray = ChuaFangArr;
                cell.chuFangOptionBtn.hidden = NO;
            } else if (tableView.tag == 11) {
                NSMutableArray *ChuaFangArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *urldic in chufangDic[@"zhengheRxDetailList"]) {
                    [ChuaFangArr addObject:urldic[@"imgUrl"]];
                }
                cell.spriteImageView.imageArray = ChuaFangArr;
                cell.chuFangOptionBtn.hidden = YES;
            } else if (tableView.tag == 12) {
                NSMutableArray *ChuaFangArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *urldic in chufangDic[@"zhengheRxDetailList"]) {
                    [ChuaFangArr addObject:urldic[@"imgUrl"]];
                }
                cell.spriteImageView.imageArray = ChuaFangArr;
                cell.chuFangOptionBtn.hidden = YES;
            } else if (tableView.tag == 13) {
                NSMutableArray *ChuaFangArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *urldic in chufangDic[@"zhengheRxDetailList"]) {
                    [ChuaFangArr addObject:urldic[@"imgUrl"]];
                }
                cell.spriteImageView.imageArray = ChuaFangArr;
                cell.chuFangOptionBtn.hidden = YES;
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            //
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDic = ChuFangHistoryArray[indexPath.section];
    HLTPrescriptionDetailViewController *detailVC = [GetPrescriptionStoryboard instantiateViewControllerWithIdentifier:@"HLTPrescriptionDetailViewController"];
    detailVC.chuFangDic = cellDic;
    [self.navigationController pushViewController:detailVC animated:YES];
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
