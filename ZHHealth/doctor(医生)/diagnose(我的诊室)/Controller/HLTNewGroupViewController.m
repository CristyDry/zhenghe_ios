//
//  HLTNewGroupViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTNewGroupViewController.h"

@interface HLTNewGroupViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation HLTNewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建分组";
    self.view.backgroundColor = kBackgroundColor;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addTextField];
    [self addCumUI];
}

-(void)addTextField
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, KTopLayoutGuideHeight + 20, kMainWidth - 40, 45)];
    _textField.placeholder = @"给分组取个名字";
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
    
    
    // 退出登录按钮
    CGFloat xPoint = AUTO_MATE_WIDTH(35);
    CGFloat yPoint = AUTO_MATE_HEIGHT(230);
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
