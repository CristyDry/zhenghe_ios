//
//  HLTPDetailController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/25.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTPDetailController.h"
#import "HLTPDetailCell.h"
#import "HLTMoveGroupController.h"
#import "HLTChatViewController.h"
#import "RCDChatViewController.h"
#import "BZMedicalRecordController.h"

@interface HLTPDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;//tableview
@property (nonatomic, strong) UIView *bgView;//头视图

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UILabel *groupLabel;

@end

@implementation HLTPDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addtableview];
    [self addBottomButton];
}

#pragma mark - 添加tableview
-(void)addtableview
{
    CGFloat xPoint = 10.0;
    CGFloat yPoint = 10.0;
    CGFloat height = 80.0;
    CGFloat width = 80.0;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, height)];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    //头像
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint*2, yPoint, width-yPoint*2, width-yPoint*2)];
    _avatarImage.layer.cornerRadius = (width-yPoint*2)*0.5;
    _avatarImage.clipsToBounds = YES;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:_huanzheModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    [_bgView addSubview:_avatarImage];
    
    //名字
    width = kMainWidth - _avatarImage.maxX_wcr - xPoint*4;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.maxX_wcr +xPoint*2, (height-30)*0.5, width, 30)];
    _nameLabel.text = _huanzheModel.patient;
    [_bgView addSubview:_nameLabel];
    
    
    _titleArray = @[@"性别",@"年龄",@"地区"];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight-KTopLayoutGuideHeight-70) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = kBackgroundColor;
    _tableview.tableHeaderView = _bgView;
    _tableview.rowHeight = 40;
    _tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableview];
    
   
    
    
}

#pragma mark - 底部button
-(void)addBottomButton
{
    UIView * bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainHeight-AUTO_MATE_HEIGHT(40), kMainWidth, AUTO_MATE_HEIGHT(40))];
    bottonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottonView];
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 1)];
    line.backgroundColor = KLineColor;
    [bottonView addSubview:line];
    
    CGFloat yPoint = AUTO_MATE_HEIGHT(5);
    CGFloat height = AUTO_MATE_HEIGHT(30);
    CGFloat width = AUTO_MATE_WIDTH(100);
    CGFloat jiange = AUTO_MATE_WIDTH(60);
    CGFloat xPoint = (kMainWidth-jiange-width*2)*0.5;
    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(leftButton.maxX_wcr+jiange, yPoint, width, height)];
    
    [self createButton:bottonView withLabelStr:@"发消息" andColor:kNavigationBarColor andButton:leftButton andTag:400];
    [self createButton:bottonView withLabelStr:@"删除用户" andColor:kNavigationBarColor andButton:rightButton andTag:401];
}

-(void)createButton:(UIView *)view withLabelStr:(NSString *)str andColor:(UIColor *)color andButton:(UIButton *)button andTag:(NSInteger)tag
{
    [button setTitle:str forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.tag = tag;
    [button addTarget:self action:@selector(bottonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

-(void)bottonClick:(UIButton *)button
{
    switch (button.tag-400) {
        case 0://发消息
        {
            HLTChatViewController *conversationVC = [[HLTChatViewController alloc]init];
            conversationVC.conversationType =  ConversationType_PRIVATE;
            conversationVC.targetId = _huanzheModel.ID;
            conversationVC.huanzheModel = _huanzheModel;
            NSLog(@"model.targetId=============%@",conversationVC.targetId);
            conversationVC.title =  _huanzheModel.patient;
            UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:conversationVC];
            [self presentViewController:nvc animated:YES completion:nil];
        }
            break;
        case 1://删除患者
        {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除用户" message:@"同时会将我从对方的列表中删除" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
                NSMutableDictionary * args = [NSMutableDictionary dictionary];
                args[@"doctorId"] = account.Id;
                args[@"patientId"] = _huanzheModel.ID;
                [httpUtil doPostRequest:@"" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        [self isStatus:@"删除成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark -table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _titleArray.count;
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        if([kUserDefaults boolForKey:@"viewMr"]){
            label.text = @"病历";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            label.text = @"资料";
        }
        [cell.contentView addSubview:label];
        return cell;
        
    }else if (indexPath.section == 1)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        label.text = @"分组";
        
        [cell.contentView addSubview:label];
        
        _groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth-130, 10, 100, 20)];
        _groupLabel.text = _huanzheModel.groupName;
        _groupLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:_groupLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else
    {
        HLTPDetailCell * cell = [[HLTPDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textString = _titleArray[indexPath.row];
        cell.huanzheModel = _huanzheModel;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if(![kUserDefaults boolForKey:@"viewMr"]){
            return;
        }
        
        //跳转到患者病历
        BZMedicalRecordController * medical = [[BZMedicalRecordController alloc] init];
        medical.huanzheModel = _huanzheModel;
        medical.isPatient = NO;
        [self.navigationController pushViewController:medical animated:YES];
                
    }else if (indexPath.section == 1){
        //跳转到移动分组
        HLTMoveGroupController * moveVC = [[HLTMoveGroupController alloc] init];
        moveVC.huanzheModel = _huanzheModel;
        [self.navigationController pushViewController:moveVC animated:YES];
    }
        
}


-(void)isStatus:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
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
