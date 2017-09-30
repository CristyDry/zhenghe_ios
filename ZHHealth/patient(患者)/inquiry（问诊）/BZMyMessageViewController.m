//
//  BZMyMessageViewController.m
//  ZHHealth
//
//  Created by pbz on 15/12/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMyMessageViewController.h"
#import "DVSwitch.h"


@interface BZMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)DVSwitch  *dvSwitch;

@property (nonatomic,strong)  UITableView *messageTableView;



@end

@implementation BZMyMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self setupDVSwitch];
    
}


-(void)setupDVSwitch{
    // 设置DVSwitch
    DVSwitch *dvSwitch = [[DVSwitch alloc]initWithStringsArray:@[@"医生",@"消息"]];
    _dvSwitch = dvSwitch;
    dvSwitch.frame = CGRectMake(0, 0, kMainWidth * 0.4, 30);
    dvSwitch.backgroundColor = [UIColor colorWithHexString:@"#05b7c3"];
    dvSwitch.font = [UIFont systemFontOfSize:17];
    dvSwitch.labelTextColorInsideSlider = [UIColor colorWithHexString:@"#05b7c3"];
    dvSwitch.layer.cornerRadius = 15;
    dvSwitch.layer.borderWidth = 1;
    dvSwitch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationItem.titleView = dvSwitch;
    
    // 添加一个UITableView
    UITableView *messageTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight) style:UITableViewStylePlain];
    _messageTableView = messageTableView;// 多分区的话要设置
    [self initializationTableViewWithTableView:messageTableView];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
//    messageTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 0.1f)];
    
    //     切换控制器
    [_dvSwitch setPressedHandler:^(NSUInteger index){
        switch (index) {
            case 0:
            {
                BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
                tabBarVC.selectedIndex = 1;
            }
                break;
            case 1:
            {
//                BZMyMessageViewController *myMessageViewController = [[BZMyMessageViewController alloc] init];
//                [self.navigationController pushViewController:myMessageViewController animated:YES];
            }
                break;
            default:
                break;
        }
        //        self.selectedIndex = index;
    }];
}

#pragma mark - UITableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
        static NSString *cellIdentifier1 = @"requestCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // 头像
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorder, 7, 46, 46)];
            iconView.image = [UIImage imageNamed:@"shape-16"];
            iconView.layer.cornerRadius = iconView.bounds.size.width * 0.5;
            iconView.layer.masksToBounds = YES;
            [cell.contentView addSubview:iconView];
            // 标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:20];
            label.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 20, 0, kMainWidth, 60);
            label.text = @"申请与通知";
            [cell.contentView addSubview:label];
            
        }
        
        return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 60;
}




@end
