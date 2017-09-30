//
//  HLTProfessViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTProfessViewController.h"

@interface HLTProfessViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HLTProfessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"专业领域";
    [self setNavigationBarProperty];
    //左右button
    [self addLeftandRightButton];
    //多行输入框
    [self addTextView];
}

#pragma mark - 左右两边button
-(void)addLeftandRightButton
{
    //取消
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.tag = 200;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAndRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    
    //保存
    UIButton * rightButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    rightButton.tag = 201;
    [rightButton addTarget:self action:@selector(leftAndRight:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}


#pragma mark - button点击事件
-(void)leftAndRight:(UIButton *)button
{
    switch (button.tag-200) {
        case 0:
        {
            NSLog(@"取消");
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            //将所需的参数id解档出来
            HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
            
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            args[@"id"] = account.Id;
            args[@"professionalField"] = _textView.text;
            args[@"intro"] = nil;
           // __weak typeof(self) weakSelf = self;
            [httpUtil doPostRequest:@"api/ZhengheDoctor/saveInformation" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    [self isStatus];
                    _editmodel.professionalField = _textView.text;
                    [_delegate changeProfess:_editmodel];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 添加输入框
-(void)addTextView
{
    CGFloat xPoint = 20.0;
    CGFloat yPoint = 20.0;
    CGFloat width = kMainWidth-xPoint*2;
    CGFloat height = AUTO_MATE_HEIGHT(280);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(xPoint, KTopLayoutGuideHeight+yPoint, width, height)];
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.text = _editmodel.professionalField;
    [self.view addSubview:_textView];
}


-(void)isStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"修改成功";
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
