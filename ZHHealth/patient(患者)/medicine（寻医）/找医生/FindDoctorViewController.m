//
//  FindDoctorViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "FindDoctorViewController.h"
#import "SearchViewController.h"
#import "BZFirstServicesModel.h"
#import "BZDidSearchController.h"
#import "BZDoctorModel.h"
@interface FindDoctorViewController ()

@property (nonatomic, strong) NSArray *officeNames;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic,strong)  NSMutableArray *FirstServicesArray;
@property (nonatomic,strong)  UIScrollView *scrollView;

@end

@implementation FindDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _FirstServicesArray = [NSMutableArray array];

    // 请求一级科室
    [self requestFirstServices];
    
    self.title = @"找医生";
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 请求一级科室
- (void)requestFirstServices{
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/findFirstDepartments" args:nil targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSeaf.FirstServicesArray = [BZFirstServicesModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self customUI];
        }
    }];
}
-(void)customUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat xPoint = 0.0f;
    CGFloat yPoint = KTopLayoutGuideHeight;
    CGFloat width = kMainWidth;
    CGFloat height = kMainHeight - yPoint;
    CGRect frame = CGRectMake(xPoint, yPoint, width, height);
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    _scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    frame.size.height = AUTO_MATE_HEIGHT(50);
    frame.origin.y = 0.0;
    
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    
    frame.origin.x = AUTO_MATE_WIDTH(20);
    frame.origin.y = AUTO_MATE_HEIGHT(7);
    frame.size.width = kMainWidth - frame.origin.x * 2;
    frame.size.height = frame.size.height - frame.origin.y * 2;
    
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    [textfield textFieldWithPlaceholder:@"医院、科室、医生名" andFont:KFont - 4 andSecureTextEntry:NO];
    UIImage *leftImage = [UIImage imageFileNamed:@"iconfont-sousuo" andType:YES];
    UIButton *leftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, frame.size.height)];
    [leftView setImage:leftImage forState:0];
    leftView.userInteractionEnabled = NO;
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.userInteractionEnabled = NO;
    UIImage *image = [UIImage imageFileNamed:@"搜索框" andType:YES];
    textfield.background = image;
    [bgView addSubview:textfield];
    UIView *separetionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textfield.frame) + 10, kMainWidth, 15)];
    separetionView.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    [bgView addSubview:separetionView];
    
    
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:textfield.frame];
    [searchButton addTarget:self action:@selector(searchButtonAction)];
    [bgView addSubview:searchButton];
    
    [self createHospitalOfficeListWithSuperView:scrollView];
    
}

#pragma mark - 搜索
-(void)searchButtonAction {
    // 搜索
    BZDidSearchController *searchVC = [[BZDidSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark - 科室列表
-(void)createHospitalOfficeListWithSuperView:(UIScrollView*)superView {
    
    CGRect frame = superView.frame;
    
    frame.size.width = kMainWidth / 4.0;
    // 50:图片的宽高，30:按钮的高
    frame.size.height = 20.0 + 50.0 + 30.0;
    frame.origin.x = 0.0;
    frame.origin.y = AUTO_MATE_HEIGHT(50) + 20;
    
    CGSize imageSize = CGSizeMake(50.0, 50.0);
    CGFloat offsetTop = 20.0;
    CGFloat buttonHight = 30.0;
    
    for (int i = 0; i < _FirstServicesArray.count; i++) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        bgView.opaque = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        
        frame.origin.x += frame.size.width;
        BZFirstServicesModel *model = _FirstServicesArray[i];
        [self setContentWithTop:offsetTop andImageSize:imageSize andImageURL:model.avatar andButtonTilte:model.departmentsName andButtonHeight:buttonHight andSuperView:bgView andBtnTag:(int) i];
        
        [superView addSubview:bgView];
        
        if ((i + 1) % 4 == 0) {
            frame.origin.x = 0.0;
            frame.origin.y += bgView.height_wcr;
        }
        
        if (i == _FirstServicesArray.count - 1) {
            
            UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.maxY_wcr, kMainWidth, 15)];
            whiteView.backgroundColor = [UIColor whiteColor];
            [superView addSubview:whiteView];
            
            superView.contentSize = CGSizeMake(kMainWidth, bgView.maxY_wcr - superView.y_wcr + 25 + KTopLayoutGuideHeight);
            
        }
    }
    
}

-(void)setContentWithTop:(CGFloat)top andImageSize:(CGSize)imageSize andImageURL:(NSString*)URL andButtonTilte:(NSString*)buttonTitle andButtonHeight:(CGFloat)btnHeight andSuperView:(UIView*)superView andBtnTag:(int) i{
    
    CGFloat xPoint = (superView.width_wcr - imageSize.width) / 2.0;
    CGFloat yPoint = top;
    CGRect frame = CGRectMake(xPoint, yPoint, imageSize.width, imageSize.height);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.layer.cornerRadius = imageSize.height * 0.5;
    imageView.layer.masksToBounds = YES;
    imageView.opaque = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    imageView.backgroundColor = [UIColor clearColor];
    [superView addSubview:imageView];
    
    frame.origin.y = imageView.maxY_wcr;
    frame.origin.x = 0.0;
    frame.size.height = btnHeight;
    frame.size.width = superView.width_wcr;
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.tag = i;
    button.opaque = YES;
    [button buttonWithTitle:buttonTitle andTitleColor:kBlackColor andBackgroundImageName:nil andFontSize:KFont - 5];
    [button setEnlargeEdgeWithTop:imageView.height_wcr right:0 bottom:0 left:0];
    [button addTarget:self action:@selector(clickButtonAction:)];
    [superView addSubview:button];
    
}

#pragma mark - 科室跳转
-(void)clickButtonAction:(UIButton*)button {
    BZFirstServicesModel *model = _FirstServicesArray[button.tag];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"firstDepartmentsId"] = model.ID;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            SearchViewController *searchVC = [[SearchViewController alloc]init];
            searchVC.keys = button.titleLabel.text;
            searchVC.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self.navigationController pushViewController:searchVC animated:YES];
        }
    }];
}

@end
