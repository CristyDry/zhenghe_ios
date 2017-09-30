//
//  HLTMycardViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMycardViewController.h"

@interface HLTMycardViewController ()

@property (nonatomic, strong) UIImageView *iconImageview;
@property (nonatomic, strong) UIImageView *bigImageview;

@property (nonatomic, strong) NSString *iconURL;//图片网址
@end

@implementation HLTMycardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码名片";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self getMyCard];
    [self createIconImageview];
}

#pragma mark - 请求名片二维码
-(void)getMyCard
{
    //将所需的参数id解档出来
    LoginResponseAccount * account = [LoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/businessCard" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            //[_smallIV sd_setImageWithURL:[NSURL URLWithString:knowledge.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]]
            weakSelf.iconURL = responseMd.response;
            //NSLog(@"weakSelf.iconURL=%@",weakSelf.iconURL);
        }
    }];
}

#pragma mark - 添加Imageview
-(void)createIconImageview
{
    //背景圆角矩形
    CGFloat xPoint = 30.0;
    CGFloat yPoint = 20.0;
    CGFloat width = kMainWidth - xPoint *2;
    CGFloat height = AUTO_MATE_HEIGHT(350);
    UIImageView * bigView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint,KTopLayoutGuideHeight+ yPoint, width , height)];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 10;
    bigView.clipsToBounds = YES;
    bigView.layer.borderWidth = 1;
    bigView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bigView.userInteractionEnabled = YES;
    [self.view addSubview:bigView];
    
    //label1
    UILabel * pleaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3*yPoint, width, 20)];
    pleaseLabel.textAlignment = NSTextAlignmentCenter;
    pleaseLabel.text = @"请患者打开正合App扫描下面二维码";
    pleaseLabel.textColor = [UIColor grayColor];
    
    [bigView addSubview:pleaseLabel];
    
    //二维码
    width = AUTO_MATE_WIDTH(100);
    xPoint = (bigView.frame.size.width-width)*0.5;
    UIImageView * erweimaImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, pleaseLabel.maxY_wcr+yPoint*2, width, width)];
    [erweimaImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverce_address,_iconURL]] placeholderImage:[UIImage imageNamed:@"cli_300px"]];
    [bigView addSubview:erweimaImage];
    
    //医生信息
    
    
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
