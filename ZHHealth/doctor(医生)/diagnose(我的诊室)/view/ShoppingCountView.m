//
//  ShoppingCountView.m
//  ShoppingView
//
//  Created by soso on 15/9/21.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "ShoppingCountView.h"

@interface ShoppingCountView ()

@end

@implementation ShoppingCountView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview];
    
    return self;
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview];
}

-(void)addSubview
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(nothingAction)];
    [self addGestureRecognizer:tap];
    
    _minus = [UIButton buttonWithType:UIButtonTypeCustom];
    _minus.frame = CGRectMake(0, 8, 25, 25);
    [_minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    [_minus setImage:[UIImage imageNamed:@"btn_reduce"] forState:UIControlStateNormal];
    [self addSubview:_minus];
    
    _plus = [UIButton buttonWithType:UIButtonTypeCustom];
    _plus.frame = CGRectMake(self.frame.size.width-25, 8, 25, 25);
    [_plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [_plus setImage:[UIImage imageNamed:@"btn_reduce_disable"] forState:UIControlStateNormal];
    [self addSubview:_plus];
    
    _amountTextField = [[UITextField alloc]initWithFrame:(CGRect){{25,0},{self.frame.size.width-50,self.frame.size.height}}];
    _amountTextField.textAlignment = NSTextAlignmentCenter;
    _amountTextField.textColor = [UIColor redColor];
    _amountTextField.placeholder = @"0";
    _amountTextField.text = @"1";
    [_amountTextField setFont:[UIFont systemFontOfSize:23]];
    // add PH 目前先不考虑给用户编辑
    _amountTextField.userInteractionEnabled = NO;
    [self addSubview:_amountTextField];
}

-(void)nothingAction{
   // 什么都不需要做
}

-(void)minusAction:(UIButton*)sender
{
    if(_minusBlock) {
        _minusBlock([_amountTextField.text integerValue],_dataID,_plus,_minus,_amountTextField);
    }
}

-(void)plusAction:(UIButton *)sender
{

    if (_plusBlock) {
        _plusBlock([_amountTextField.text integerValue],_dataID,_plus,_minus,_amountTextField);
    }
}

-(void)eventAction:(id)sender{
}

@end
