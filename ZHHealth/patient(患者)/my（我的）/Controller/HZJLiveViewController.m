//
//  HZJLiveViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/9.
//  Copyright © 2015年 U1KJ. All rights reserved.
//
#define frame [UIScreen mainScreen].bounds
#import "HZJLiveViewController.h"

#import "HZJLiveTableViewCell.h"

#import "HZJCompileViewController.h"

@interface HZJLiveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation HZJLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //主题
    [self addTitleView];
    //添加左边的按钮
    [self addLeftBackItem];
    
    //添加右边按钮
    [self addRightItem];
    
    //添加Table view
    [self addTableView];
}
- (void)addRightItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compileNote)];

}
- (void)compileNote{
    

    HZJCompileViewController *Compiles = [[HZJCompileViewController alloc]init];
    [self.navigationController pushViewController:Compiles animated:YES];

    

}
- (void) addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -35, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
}

- (void)addTitleView{
    CGFloat twidth = 100;
    CGFloat theight = 44;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - twidth) * 0.5, 0, twidth, theight)];
    titleLabel.text = @"生活日志";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuselden = @"Reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuselden];
    if (!cell) {
        cell = [HZJLiveTableViewCell cellWithTableCell:tableView];
        
    }
    //主题
    UILabel *zhuti = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 160, 30)];
    zhuti.text = @"lhfkdnfyrfhhgfhdfhd";
    zhuti.font = [UIFont systemFontOfSize:20];
    [cell.contentView addSubview:zhuti];
    
    //内容
    UILabel *neirong = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, 160, 80)];
    neirong.text = @"2121111222222135555555555555555555555555555555552222222222223333333333333333333333333333";
    neirong.numberOfLines = 0;
    neirong.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:neirong];
    
    //图片
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(190, 15, 110, 110)];
    image.image = [UIImage imageNamed:@"background@3x"];
    [cell.contentView addSubview:image];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
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
