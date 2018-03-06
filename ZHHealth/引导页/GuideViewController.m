//
//  GuideViewController.m
//  BDBox
//
//  Created by U1KJ on 15/9/7.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import "GuideViewController.h"
#import "MedicineViewController.h"
#import "MyViewController.h"
#import "KnowledgeViewController.h"
#import "InquiryViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *images;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.images = @[@"引导页1",@"引导页2",@"引导页3",@"引导页4"];
    
    // 设置导航页
    [self createScrollView];
    
}

- (void)createScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    for (NSInteger i = 0; i < self.images.count; i++) {
        
        UIImage *image = [UIImage imageFileNamed:self.images[i] andType:YES];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        // 设置frame属性
        CGRect frame = CGRectZero;
        frame.origin = CGPointMake(self.view.frame.size.width * i, 0);
        frame.size = self.view.frame.size;
        imageView.frame = frame;
        
        // 将图片视图添加到scrollView中
        [scrollView addSubview:imageView];
        
    }
    
    // 设置scrollView的属性
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.images.count, self.view.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置按钮点击最后一页进入应用
    // 在最后一页点击进入APP
    CGFloat yPatient = kMainHeight - 180;
    UIButton *patientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonPropertyWithButton:patientBtn andYpoint:yPatient andTag:2015 andButtonTitle:@"马上体验"];
    [scrollView addSubview:patientBtn];
    if([kUserDefaults boolForKey:@"viewAll"]){

        CGFloat yDoctor = patientBtn.maxY_wcr + 30;
        UIButton *doctorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setButtonPropertyWithButton:doctorButton andYpoint:yDoctor andTag:2016 andButtonTitle:@"我是专家"];
        [scrollView addSubview:doctorButton];
    }
    [self.view addSubview:scrollView];
    
    // 分页控件
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kMainHeight - 30, kMainWidth, 20)];
    self.pageControl = pageControl;
    pageControl.numberOfPages = self.images.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    
}

-(void)setButtonPropertyWithButton:(UIButton*)button andYpoint:(CGFloat)yPoint andTag:(int)buttonTag andButtonTitle:(NSString*)buttonTitle{
    
    CGFloat width = kMainWidth - kBorder * 2;
    CGFloat xPoint = kMainWidth * (self.images.count - 1) + kBorder;
    
    button.frame = CGRectMake(xPoint, yPoint, width, 40);
    button.tag = buttonTag;
    [button buttonWithTitle:buttonTitle andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"背景-拷贝" andFontSize:16];
    [button.layer setCornerRadius:5.0f];
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(enterApp:)];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.pageControl) {
        CGFloat offsetX = scrollView.contentOffset.x;
        int page = offsetX / scrollView.width_wcr;
        self.pageControl.currentPage = page;
    }
    
}


#pragma mark - 进入APP
-(void)enterApp:(UIButton*)button{
    
    if (button.tag == 2015) {
        
        [AppConfig saveLoginType:kPatient];
        
        UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
        
        // 患者
        NSArray *norArray = @[@"图层-8",@"图层-9",@"iconfont-zhishiku",@"shape-23"];
        NSArray *selArray = @[@"形状-3",@"形状-8",@"形状-12",@"shape-232"];
        NSArray *titles = @[@"咨询",@"咨询",@"知识",@"我的"];
        NSArray *classNames = @[@"MedicineViewController",@"InquiryViewController",@"KnowledgeViewController",@"MyViewController"];
        NSMutableArray *vcArray = [NSMutableArray array];
        
        for (int i = 0; i < classNames.count; i++) {
            UIViewController *vc = [[NSClassFromString(classNames[i]) alloc]init];
            
            vc.tabBarItem.image = [[UIImage imageFileNamed:norArray[i] andType:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageFileNamed:selArray[i] andType:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            vc.tabBarItem.title = titles[i];
            
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontSize,NSFontAttributeName,nil] forState:UIControlStateNormal];
            
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [vc setNavigationBarProperty];
            vc.navigationItem.title = titles[i];
            if ([titles[i] isEqualToString:@"知识"]) {
                // 知识百科
                vc.navigationItem.title = @"知识百科";
            }
            
            [vcArray addObject:navc];
        }
        
//        UITabBarController *tabBarVC = [[UITabBarController alloc]init];
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        //设置整个tabBar的每个item选中时的颜色
        tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
        
        UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
        tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
        
        tabBarVC.viewControllers = vcArray;
        
        [self presentViewController:tabBarVC animated:YES completion:nil];
        
    }else if (button.tag == 2016) {
        // 医生
        [AppConfig saveLoginType:kDoctor];
        
        UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
        
        NSArray *norArray = @[@"图层-10",@"图层-12",@"iconfont-zhishiku",@"shape-23"];
        NSArray *selArray = @[@"形状-2",@"形状-1",@"形状-12",@"shape-232"];
        NSArray *titles = @[@"健康在线",@"我的咨询",@"知识",@"个人中心"];
        NSArray *classNames = @[@"HLTAdmissionsViewController",@"HLTDiagnoseViewController",@"KnowledgeViewController",@"HLTMyViewController"];
        NSMutableArray *vcArray = [NSMutableArray array];
        
        for (int i = 0; i < classNames.count; i++) {
            UIViewController *vc = [[NSClassFromString(classNames[i]) alloc]init];
            
            vc.tabBarItem.image = [[UIImage imageFileNamed:norArray[i] andType:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageFileNamed:selArray[i] andType:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            vc.tabBarItem.title = titles[i];
            
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontSize,NSFontAttributeName,nil] forState:UIControlStateNormal];
            
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [vc setNavigationBarProperty];
            vc.navigationItem.title = titles[i];
            if ([titles[i] isEqualToString:@"知识"]) {
                // 知识百科
                vc.navigationItem.title = @"知识百科";
            }
            
            [vcArray addObject:navc];
        }
        
        //        UITabBarController *tabBarVC = [[UITabBarController alloc]init];
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        
        //设置整个tabBar的每个item选中时的颜色
        tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
        
        UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
        tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
        
        tabBarVC.viewControllers = vcArray;
        
        [self presentViewController:tabBarVC animated:YES completion:nil];
        

        
    }
    
}

@end
