//
//  HLTEditGroupController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTEditGroupController.h"

@interface HLTEditGroupController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation HLTEditGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建分组";
    self.view.backgroundColor = kBackgroundColor;
    [self addLeftBackItem];
    [self addRightButton];
    [self setNavigationBarProperty];
    [self addTextField];
    [self addCumUI];
}


#pragma mark - 右边按钮
-(void)addRightButton
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(delate) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark - 删除按钮点击事件
-(void)delate
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要删除分组？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([_groupModel.count integerValue] >0)
        {
            UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非空分组不可删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerView show];
        }
        else
        {
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            args[@"id"] = _groupModel.ID;
            [httpUtil doPostRequest:@"api/ZhengheDoctor/deleteGroup" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    [self isStatus];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}


-(void)isStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"删除成功";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}


-(void)addTextField
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, KTopLayoutGuideHeight + 20, kMainWidth - 40, 45)];
    _textField.placeholder = _groupModel.groupName;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth = 0.8;
    [self.view addSubview:_textField];
}

#pragma mark - ui
-(void)addCumUI
{
    //分组说明
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, _textField.maxY_wcr + 35, kMainWidth-40, 80)];
    [self.view addSubview:_textLabel];
    
    UILabel * textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _textField.frame.size.width, 20)];
    [self createLabel:textLabel1 withTextString:@"如何给患者分组:"];
    
    UILabel * textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, textLabel1.maxY_wcr, _textField.frame.size.width, 20)];
    [self createLabel:textLabel2 withTextString:@"1.手动新建一个分组"];
    
    UILabel * textLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, textLabel2.maxY_wcr, _textField.frame.size.width,20)];
    [self createLabel:textLabel3 withTextString:@"2.查看患者详情"];
    
    UILabel * textLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, textLabel3.maxY_wcr, _textField.frame.size.width, 20)];
    [self createLabel:textLabel4 withTextString:@"3.点击分组将该患者分入改组"];
    
    
    // 保存按钮
    CGFloat xPoint = AUTO_MATE_WIDTH(35);
    CGFloat yPoint = _textLabel.maxY_wcr+xPoint;
    CGFloat width = kMainWidth - xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(35);
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [saveButton buttonWithTitle:@"保存" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [saveButton addTarget:self action:@selector(saveButtonEvent)];
    [self.view addSubview:saveButton];
    
}

#pragma mark - 自定义label
-(void)createLabel:(UILabel *)label withTextString:(NSString *)text
{
    label.text = text;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:17];
    [_textLabel addSubview:label];
}

#pragma mark - 保存按钮点击事件
-(void)saveButtonEvent
{
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _groupModel.ID;
    args[@"groupName"]=_groupModel.groupName;
    args[@"doctorId"] = account.Id;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/saveGroup" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
