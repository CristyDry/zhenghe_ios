//
//  SoSlideScrollView.m
//  EHRMobile
//
//  Created by soso on 15/4/14.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "SoSlideScrollView.h"

#define KTITLEHEIGHT 38

@implementation SoSlideScrollView
{
    NSInteger currentIndex;          //  当前选中的主视图
    
    NSMutableArray *arrView;         //  保存初始的arrContent
    
    BOOL isBtnSelect;                //  主视图切换是否通是点击btn
    
    BOOL isDraging;                  //  是否拖动中。。
    
    BOOL btnAction;        //  add PH 如果是点击了button，不需要重新调用scrollView 点击button的方法
    
    UIView *bottomLine;
}

-(NSMutableArray*)arrContent
{
    if (_arrContent == nil) _arrContent = [[NSMutableArray alloc]init];
    return _arrContent;
}
-(NSMutableArray*)arrTitle
{
    if(_arrTitle == nil) _arrTitle = [[NSMutableArray alloc]init];
    return _arrTitle;
}

// 加上
-(void)so_setData
{
    //顶部UI设置
    _titleScrollview.contentSize = CGSizeMake(((kMainWidth*1.0/_arrTitle.count))*_arrTitle.count, KTITLEHEIGHT);
    _scrollview.contentSize = CGSizeMake(kMainWidth*(_arrTitle.count<=2?_arrTitle.count:4), _scrollview.frame.size.height-_titleScrollview.frame.size.height);
    _titleScrollview.frame = CGRectMake(0, 0, kMainWidth, KTITLEHEIGHT);
    //主视图设置
    _scrollview.frame = CGRectMake(0, _titleScrollview.frame.size.height, kMainWidth, kMainHeight-64-_titleScrollview.frame.size.height);
    //分页模式
    _scrollview.pagingEnabled = YES;
    _scrollview.backgroundColor = [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1];

    //顶部UI加上 btn
    for (int i=0; i<_arrTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(kMainWidth/_arrTitle.count), 0,
                               (kMainWidth/_arrTitle.count), KTITLEHEIGHT);
        btn.backgroundColor = [UIColor redColor];
        btn.tag = i+100;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAtion:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:_arrTitle[i] forState:UIControlStateNormal];
        [btn setTitle:@"呵呵哒" forState:UIControlStateNormal];
        [_titleScrollview addSubview:btn];
        
        if(_isNews){
            UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width/2.0 - btn.titleLabel.text.length*12,5, 8, 8)];
            redView.layer.cornerRadius  = 4.0f;
            redView.layer.masksToBounds = YES;
            redView.backgroundColor     = kNavigationBarColor;
            [_titleScrollview addSubview:redView];
        }
        
        if(i==0){
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            btn.transform = CGAffineTransformMakeScale(1.0+0.2, 1.0+0.2);
//            btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            
            bottomLine = [[UIView alloc]initWithFrame:(CGRect){20,btn.frame.size.height - 2,btn.frame.size.width - 40 ,2}];
            bottomLine.backgroundColor = [UIColor redColor];
            [btn addSubview:bottomLine];
        }
    }

    arrView = [[NSMutableArray alloc]initWithArray:self.arrContent];
    
    //ScrollView锁定在中间
    [_scrollview setContentOffset:CGPointMake(_arrTitle.count<4?0:kMainWidth, 0)];
    
    [self setContentView];
}

// 顶部视图btn点击执行的SEL
-(void)btnAtion:(UIButton*)sender
{
    btnAction = YES;
    isBtnSelect = YES;
    for (int i =0; i<_arrTitle.count; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:100+i];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        if(btn != sender) btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if(_arrTitle.count>=4){
        if (sender.tag-100>currentIndex) {
            currentIndex = sender.tag-100-1;
            if(!isDraging) [self setContentView];  // 不是拖动变换界面（点击Button）
            [_scrollview setContentOffset:CGPointMake(_scrollview.frame.size.width*2, 0) animated:YES];
        }else if (sender.tag-100<currentIndex) {
            currentIndex = sender.tag-100+1;
            if(!isDraging) [self setContentView]; // 不是拖动变换界面。(点击Button)
            [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }else {
            
        }
    }else{
        switch (sender.tag) {
                case 100:{
                    [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
                    currentIndex = 0;
                }break;
                case 101:{
                    [_scrollview setContentOffset:CGPointMake(kMainWidth, 0) animated:YES];
                    currentIndex = 1;
                }break;
                default:
                    break;
        }
    }
    
    _indexSelect = sender.tag -100 ;
    
    if(_selectBtnBlock) _selectBtnBlock(sender.tag-100,arrView[sender.tag-100]);
}

// 两在scrollView addSubView
-(void)so_initCreateTitles:(NSMutableArray *)titles ContentViews:(NSMutableArray *)views
{
    self.arrTitle   = titles;
    self.arrContent = views;
    [self so_initCreate];
}

-(void)so_initCreate
{
    currentIndex = 0;
    _titleScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, KTITLEHEIGHT)];
    _titleScrollview.showsHorizontalScrollIndicator = NO;
//    _titleScrollview.delegate = self;
    _titleScrollview.alwaysBounceHorizontal = YES;
    _titleScrollview.alwaysBounceVertical = NO;
//    _titleScrollview.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    _titleScrollview.backgroundColor = [UIColor blueColor];
    [self addSubview:_titleScrollview];
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _titleScrollview.frame.size.height, self.frame.size.width, kMainHeight-64-_titleScrollview.frame.size.height)];
    [self addSubview:_scrollview];
    _scrollview.delegate = self;
    _scrollview.pagingEnabled = YES;
    _scrollview.alwaysBounceVertical = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator   = NO;
    
    [self so_setData];
}

#pragma mark- scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    isDraging = YES;
    // 跟据滑动数值 改变字体大小
    // offsetX的值在 -320~320;
    float offsetX =  kMainWidth - scrollView.contentOffset.x ;
    
    if(_arrTitle.count == 2) {
        offsetX = scrollView.contentOffset.x;
    }

    NSInteger tempValue = currentIndex;
    UIButton *currBtn = (UIButton *)[_titleScrollview viewWithTag:100+currentIndex];
    // 当通过btn执行 不需要该缩小动画
//    if(!isBtnSelect) {
//        if (_arrTitle.count == 2 && currentIndex == 1)
//            currBtn.transform = CGAffineTransformMakeScale(1.0+abs((int)offsetX)/kMainWidth*0.2, 1.0+abs((int)offsetX)/kMainWidth*0.2);
//        else
//            currBtn.transform = CGAffineTransformMakeScale(1.2-abs((int)offsetX)/kMainWidth*0.2, 1.2-abs((int)offsetX)/kMainWidth*0.2);
//    }
    
    if(_arrTitle.count>=4){
        if (offsetX<0) {     // 设置字体放大动画
            tempValue++;
            if (tempValue>=arrView.count) {
                tempValue = 0;
            }
//            UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:tempValue + 100];
//            btn.transform = CGAffineTransformMakeScale(1.0+abs((int)offsetX)/kMainWidth*0.2, 1.0+abs((int)offsetX)/kMainWidth*0.2);
            
        }else
        {
            tempValue--;
            if (tempValue < 0) {
                tempValue = arrView.count-1;
            }
//            UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:tempValue + 100];
//            btn.transform = CGAffineTransformMakeScale(1.0+abs((int)offsetX)/kMainWidth*0.2, 1.0+abs((int)offsetX)/kMainWidth*0.2);
            
            }
    }
    
    if (_arrTitle.count==2) {
//        if (currentIndex == 0) {
//            UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:101];
//            btn.transform = CGAffineTransformMakeScale(1.0+abs((int)offsetX)/kMainWidth*0.2, 1.0+abs((int)offsetX)/kMainWidth*0.2);
//        }else {
//            UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:100];
//            btn.transform = CGAffineTransformMakeScale(1.2-abs((int)offsetX)/kMainWidth*0.2, 1.2-abs((int)offsetX)/kMainWidth*0.2);
//        }

        if (scrollView.contentOffset.x == kMainWidth) {
            UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:101];
//            btn.transform = CGAffineTransformMakeScale(1.0+0.2, 1.0+0.2);
            currentIndex  = 1;
            if (!btnAction) {
                [self btnAtion:btn];
                btnAction = NO;
            }
        }else if (scrollView.contentOffset.x ==0){
            UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:100];
//            btn.transform = CGAffineTransformMakeScale(1.0+0.2, 1.0+0.2);
            currentIndex  = 0;
            if (!btnAction) {
                [self btnAtion:btn];
                btnAction = NO;
            }
        }
        isBtnSelect = NO;
        CGRect frmae = bottomLine.frame;
        frmae.origin.x  = (frmae.size.width + 20 )* currentIndex + (20* (currentIndex+1));
        bottomLine.frame = frmae;
        return;
    }
    
    // 当滑动深度为一页时为YES
    if (scrollView.contentOffset.x >= kMainWidth*2) {
        currentIndex ++;
        if (currentIndex>=arrView.count) {
            currentIndex =0;
        }
        UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:100+currentIndex];
        if (!btnAction) {
            [self btnAtion:btn];
            btnAction = NO;
        }
        [self setContentView];
        isBtnSelect = NO;
    }else if (scrollView.contentOffset.x <= 0){
        currentIndex --;
        if (currentIndex<0) {
            currentIndex = arrView.count-1;
        }
        UIButton *btn = (UIButton *)[_titleScrollview viewWithTag:100+currentIndex];
        if (!btnAction) {
            [self btnAtion:btn];
            btnAction = NO;
        }
        [self setContentView];
        isBtnSelect = NO;
    }
    
    
    CGRect frmae = bottomLine.frame;
    frmae.origin.x  = (frmae.size.width + 20 )* currentIndex + (20* (currentIndex+1));
    bottomLine.frame = frmae;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}

// _arrContent执行addSubView
-(void)setContentView
{
    //删除现SubView
    [_scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //设置要加的视图
    [self arrContents];
    //加上SubView
    NSInteger counter = 0;
    //设置内容页（遍历每一页的内容）        
    for (UIView *contentView in _arrContent) {
        //设置内容尺寸和位移
        CGRect frame = contentView.frame;
        frame.origin = CGPointMake(kMainWidth * (counter++), 0);
        contentView.frame = frame;
        [_scrollview addSubview:contentView];
    }
    //ScrollView锁定在中间
    [_scrollview setContentOffset:CGPointMake(_arrTitle.count<4?0:kMainWidth, 0)];
    
    isDraging = NO;
}

// 保存展示中的三个View
-(void)arrContents
{
    if(_arrTitle.count<4) return;
    [_arrContent removeAllObjects];
    [_arrContent addObject:arrView[(currentIndex-1)<0?arrView.count-1:currentIndex-1]];
    [_arrContent addObject:arrView[ currentIndex]];
    [_arrContent addObject:arrView[(currentIndex+1)>=arrView.count?0:currentIndex+1]];
}

/*
 - (void)drawRect:(CGRect)rect {
 
 }
 */

@end



