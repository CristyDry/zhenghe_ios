//
//  WCRChannelViewController.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WCRChannelViewController.h"
#import "BZChannelListModel.h"
#import "BZChannelListModel.h"
@interface WCRChannelViewController ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selectedButtons;
@property (nonatomic,strong)  BZChannelListModel *channels;
@property (nonatomic,strong)   UIButton *button;
@property (nonatomic,strong)  NSMutableArray *seletBtnArray;
@property (nonatomic,strong)  NSMutableArray *channelListSelectModelA;
@end

@implementation WCRChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 解压已选的频道
    _channelListSelectModelA = [BZChannelListModel decode];
    _selectedButtons = [NSMutableArray array];
    _titles = [NSMutableArray array];
    // 取出频道列表
    for (BZChannelListModel *channels in _channelListModelA) {
        [_titles addObject:channels.classifyName];
    }
    
    [self setNavigationBarProperty];
    
    self.title = @"频道管理";
    
    [self addLeftBackItem];
    
    [self setRightButton];
    
    [self customChannelUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)customChannelUI {
    NSMutableArray *seletBtnArray = [NSMutableArray array];
    _seletBtnArray = seletBtnArray;
    CGFloat width = 80;
    CGFloat height = 30;
    
    CGFloat offsetX = (kMainWidth - width * 4) / 5.0;
    CGFloat offsetY = 30.0;
    CGFloat xPoint = offsetX;
    CGFloat yPoint = offsetY + KTopLayoutGuideHeight;
    
    for (int i = 0; i < _titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xPoint, yPoint, width, height);
        [button buttonWithTitle:_titles[i] andTitleColor:kBlackColor andBackgroundImageName:nil andFontSize:KFont - 4];
        [button addTarget:self action:@selector(channelButtonAction:)];
        button.tag = i;
        [button setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
        _button = button;
        [seletBtnArray addObject:_button];
        if (i == 0) {
            _button.enabled = NO;
            [_button setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        }
        if (i != 0) {
            button.backgroundColor = [UIColor whiteColor];
            
            UIImage *unSelectedImage = [UIImage imageFileNamed:@"矩形-2" andType:YES];
            [button setBackgroundImage:unSelectedImage forState:0];
            
            UIImage *selectedImage = [UIImage imageFileNamed:@"矩形-1" andType:YES];
            [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
        }
        
        [self.view addSubview:button];
        
        xPoint = button.maxX_wcr + offsetX;
        if ((i + 1) % 4 == 0) {
            xPoint = offsetX;
            yPoint = button.maxY_wcr + offsetY;
        }
        
    }
    for (UIButton *selectBtn in seletBtnArray) {
        for (BZChannelListModel *selectBtnName in _channelListSelectModelA) {
            if ([selectBtnName.classifyName isEqualToString:selectBtn.titleLabel.text]) {
                selectBtn.selected = YES;
            }
        }
    }


}

-(void)setRightButton {
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.width_wcr = 40;
    rightButton.height_wcr = 30;
    [rightButton addTarget:self action:@selector(channelButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}

-(void)channelButtonAction:(UIButton*)button {
    button.selected = !button.selected;
//    [_channelListSelectModelA addObject:_channelListModelA[0]];
//    if (button.selected) {
//        [_selectedButtons addObject:_channelListModelA[button.tag]];
//    }
}


#pragma mark - 右边完成按钮
-(void)channelButtonAction {
    // 取出选中的模型
    NSMutableArray *selectedChannels = [NSMutableArray array];
//    [selectedChannels addObject:_channelListModelA[0]];
    for (UIButton *btn in _seletBtnArray) {
        if (btn.selected == YES) {
            [selectedChannels addObject:_channelListModelA[btn.tag]];
        }
    }
    // 归档进模型
    [BZChannelListModel encode:selectedChannels];
    // 把选中的模型传给代理
    if ([_delegate respondsToSelector:@selector(pushKnowledgeViewController:)]) {
        [_delegate pushKnowledgeViewController:selectedChannels];
    }
          [self.navigationController popViewControllerAnimated:YES];
}

@end
