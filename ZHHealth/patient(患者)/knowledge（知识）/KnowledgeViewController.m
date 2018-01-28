//
//  KnowledgeViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "KnowledgeViewController.h"

#import "WCRChannelViewController.h"

//#import "WCRKnowledge.h"
#import "WCRKnowledgeCell.h"
#import "WCRChannelViewController.h"
#import "WCRKnowledgeDetailController.h"
#import "BZChannelListModel.h"
#import "BZAdPictureModel.h"
#import "BZArticleListModel.h"
@interface KnowledgeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,WCRChannelViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *headerButtons; // 频道按钮
@property (nonatomic, strong) UIButton *tempBtn;             // 选中按钮的中间变量
@property (nonatomic, strong) UIScrollView *scrollView;      // 轮播图

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SDCycleScrollView *advertisementSV;   // 轮播图片
@property (nonatomic, strong) NSArray *imageURLs;

//@property (nonatomic, strong) NSArray *knowlegdes;
@property (nonatomic,strong)  NSMutableArray *channelListModelA;    // 频道模型数组
@property (nonatomic,strong)  NSArray *adPictureA;
@property (nonatomic,strong)  NSArray *articleA;
@property (nonatomic,strong)  WCRChannelViewController *channelViewController;
@property (nonatomic,strong)  NSMutableArray *channelListSelectModelA;
@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 请求频道列表
    [self setchannelList];
    // 右边添加频道按钮
    [self addRightButton];
    // 频道列表滑动栏
    [self setScrollButton];
    // 创建一个tableView
    [self initTableView];
}

- (void)setchannelList{
    // 取出频道列表数据
    _channelListSelectModelA = [BZChannelListModel decode];
    // 如果为空，从新请求
    //if (_channelListSelectModelA == nil) {
        NSMutableDictionary *channelArgs = [NSMutableDictionary dictionary];
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/knowledgeWikiInit" args:channelArgs targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                // 转成模型数组
                weakSeaf.channelListSelectModelA = [BZChannelListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [BZChannelListModel encode:weakSeaf.channelListSelectModelA];
                [self setScrollButton];
                [self.tableView reloadData];
            }
        }];
    //}
}
-(void)initTableView {
    // AUTO_MATE_HEIGHT(40)
    CGFloat height = _scrollView.maxY_wcr;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, kMainWidth, kMainHeight - KBottomLayoutGuideHeight - height) style:UITableViewStylePlain];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 设置头视图
    CGFloat width = kMainWidth;
    height = width * (380 / 640.0);
    SDCycleScrollView *advertisementSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, height) imageURLStringsGroup:nil];
    _advertisementSV = advertisementSV;
    advertisementSV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    advertisementSV.delegate = self;
    advertisementSV.titleLabelHeight = advertisementSV.bounds.size.height * 0.34;
    advertisementSV.titleLabelTextFont = [UIFont systemFontOfSize:17];
    advertisementSV.titleLabelBackgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    advertisementSV.dotColor = [UIColor colorWithHexString:@"#05b7c3"]; 
    advertisementSV.placeholderImage = [UIImage imageNamed:@"ic_error"];
    advertisementSV.autoScrollTimeInterval = 3.0;
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [advertisementSV setHeight_wcr:0];
    [httpUtil doPostRequest:@"api/ZhengheDoctor/articleCarousel" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.adPictureA = [BZAdPictureModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            NSMutableArray *imagesURLStrings = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (BZAdPictureModel *mode in weakSelf.adPictureA) {
                [imagesURLStrings addObject:mode.avatar];
                [titles addObject:mode.title];
            }
            if(titles.count < 1){
                [advertisementSV setHeight_wcr:0];
            }else{
                [advertisementSV setHeight_wcr:kMainWidth * (380 / 640.0)];
            }
            // 图片
            advertisementSV.imageURLStringsGroup = imagesURLStrings;
            // 标题
            advertisementSV.titlesGroup = titles;
        }
    }];
    // 设置推荐页的cell内容
    // 网络请求，刷新界面数据
    NSMutableDictionary *recommendArgs = [NSMutableDictionary dictionary];
    recommendArgs[@"id"] = @"1";
    [httpUtil doPostRequest:@"api/ZhengheDoctor/knowledgeWiki" args:recommendArgs targetVC:self response:^(ResponseModel *responseMd) {
        weakSelf.articleA = [BZArticleListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
        [self.tableView reloadData];
    }];
    _tableView.tableHeaderView = advertisementSV;
    
}

#pragma mark - 点击轮播图片
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WCRKnowledgeDetailController *knowlegdeDetailVC = [[WCRKnowledgeDetailController alloc]init];
    knowlegdeDetailVC.hidesBottomBarWhenPushed = YES;
    BZArticleListModel *articleListModel = _adPictureA[index];
    knowlegdeDetailVC.articleId = articleListModel.ID;
    [self.navigationController pushViewController:knowlegdeDetailVC animated:NO];
}

-(void)addRightButton {
    
    UIButton *rightButton = [self addRightBarButtomWithImageName:@"iconfont-tianjia-4"];
    [rightButton addTarget:self action:@selector(knowRightButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}
#pragma mark - 添加频道菜单
-(void)knowRightButton {
    NSMutableDictionary *channelArgs = [NSMutableDictionary dictionary];
    [httpUtil doPostRequest:@"api/ZhengheDoctor/knowledgeWikiInit" args:channelArgs targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            WCRChannelViewController *channelVC = [[WCRChannelViewController alloc]init];
            channelVC.channelListModelA = [BZChannelListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            channelVC.hidesBottomBarWhenPushed = YES;
            channelVC.delegate = self;
            [self.navigationController pushViewController:channelVC animated:YES];
        }
    }];
}

-(void)setScrollButton {
    
    CGFloat xPoint = 0.0;
    CGFloat yPoint = 0.0 + KTopLayoutGuideHeight;
    CGFloat width = kMainWidth;
    CGFloat height = AUTO_MATE_HEIGHT(40);
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    yPoint = 0.0;
    _channelListSelectModelA = [BZChannelListModel decode];
    for (int i = 0; i < _channelListSelectModelA.count; i++) {
        
        // 算实际的宽度
        BZChannelListModel *channelModel = _channelListSelectModelA[i];
        NSString *channelName = channelModel.classifyName;
        width = [Tools calculateLabelWidth:channelName font:[UIFont systemFontOfSize:KFont - 3] AndHeight:height];
        width += 30;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        button.tag = i;
        [button buttonWithTitle:channelName andTitleColor:kBlackColor andBackgroundImageName:nil andFontSize:KFont - 3];
        [button setTitleColor:[UIColor colorWithHexString:@"#05b7c3"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(headerButtonAction:)];
        button.opaque = YES;
        
        xPoint = button.maxX_wcr;
        
        if (i == 0) {
            button.selected = YES;
            self.tempBtn = button;
        }
        
        if (i == _channelListSelectModelA.count - 1) {
            scrollView.contentSize = CGSizeMake(button.maxX_wcr, height);
        }
        
        [scrollView addSubview:button];
    }
    
    width = [Tools calculateLabelWidth:self.tempBtn.titleLabel.text font:[UIFont systemFontOfSize:KFont - 3] AndHeight:height];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, scrollView.height_wcr - 2, width, 2)];
    _line = line;
    line.backgroundColor = kNavigationBarColor;
    line.centerX_wcr = _tempBtn.centerX_wcr;
    [scrollView addSubview:line];
    
}

#pragma mark - 菜单按钮点击事件
-(void)headerButtonAction:(UIButton*)button {
    
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    }else if (self.tempBtn != nil && self.tempBtn == button) {
        self.tempBtn.selected = YES;
        
    }else if (self.tempBtn != nil && self.tempBtn != button) {
        self.tempBtn.selected = NO;
        
        button.selected = YES;
        self.tempBtn = button;
        
    }
    
    __block typeof(self) weakSelf = self;
    CGFloat width = [Tools calculateLabelWidth:self.tempBtn.titleLabel.text font:[UIFont systemFontOfSize:KFont - 3] AndHeight:self.tempBtn.height_wcr];
    _line.width_wcr = width;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.line.centerX_wcr = weakSelf.tempBtn.centerX_wcr;
    }];
    
    // 网络请求，刷新界面数据
    BZChannelListModel *channel= _channelListSelectModelA[button.tag];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = channel.ID;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/knowledgeWiki" args:args targetVC:self response:^(ResponseModel *responseMd) {
        weakSelf.articleA = [BZArticleListModel mj_objectArrayWithKeyValuesArray:responseMd.response];
        [self.tableView reloadData];
    }];
    
    if ([self.tempBtn.titleLabel.text isEqualToString:@"推荐"]) {
        _tableView.tableHeaderView = _advertisementSV;
    }else {
        _tableView.tableHeaderView = nil;
    }
    [_tableView reloadData];
}

#pragma mark - Table View Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _articleA.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"cell";
    
    WCRKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WCRKnowledgeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.knowledge = _articleA[indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWCRKnowledgeCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WCRKnowledgeDetailController *knowlegdeDetailVC = [[WCRKnowledgeDetailController alloc]init];
    knowlegdeDetailVC.hidesBottomBarWhenPushed = YES;
    BZArticleListModel *articleListModel = _articleA[indexPath.row];
    knowlegdeDetailVC.articleId = articleListModel.ID;
    [self.navigationController pushViewController:knowlegdeDetailVC animated:NO];
    
}

#pragma mark - 选择频道的代理方法
- (void)pushKnowledgeViewController:(NSMutableArray *)selectedChannels{
//    [_headerButtons removeAllObjects];
    
//    for (NSString  *channelName in selectedChannels) {
//        [_headerButtons addObject:channelName];
//    }
    
    [self setScrollButton];
    [self.tableView reloadData];
}
@end
