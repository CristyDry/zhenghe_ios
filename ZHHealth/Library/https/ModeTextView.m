//
//  ModeTextView.m
//  EHealth_HM
//
//  Created by dengwz on 13-11-4.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import "ModeTextView.h"
#import "Tools.h"

@implementation ModeTextView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        self.layer.cornerRadius = 3.0f;
        self.layer.masksToBounds = YES;
        
        [self loadView];
    }
    return self;
}

-(void)loadView
{
    lab = [[UILabel alloc]init];
    lab.numberOfLines = 0;
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont boldSystemFontOfSize:14.0f];
    lab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    NSArray *views = [UIApplication sharedApplication].keyWindow.subviews;
    for(UIView *view in views){
        if([view isKindOfClass:[ModeTextView class]]){
            [view removeFromSuperview];
        }
    }
}

-(void)ShowMessage:(NSString *)msg
{
    
    
    if([Tools isBlankString:msg]) return;
    lab.text = msg;
    CGSize autoSize = [self getLabSize];
    lab.frame = CGRectMake(0, 0, autoSize.width + 20, autoSize.height + 20);
    
    self.frame = CGRectMake((kMainWidth - lab.frame.size.width)/2, kMainHeight - 50 - lab.frame.size.height - 20, lab.frame.size.width, lab.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2f animations:^{
        lab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    } completion:^(BOOL finished) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoHidden) userInfo:nil repeats:NO];
    }];
    
}

-(void)ShowMessageAtTop:(NSString *)msg
{
    if([Tools isBlankString:msg]) return;
    lab.text = msg;
    CGSize autoSize = [self getLabSize];
    lab.frame = CGRectMake(0, 0, autoSize.width + 20, autoSize.height + 20);
    
    self.frame = CGRectMake((kMainWidth - lab.frame.size.width)/2, 70, lab.frame.size.width, lab.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2f animations:^{
        lab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    } completion:^(BOOL finished) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoHidden) userInfo:nil repeats:NO];
    }];
    
}


/**
 *	@brief	自动消失隐藏后，清除
 */
-(void)autoHidden
{
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(CGSize)getLabSize
{
    NSString *msg = [NSString stringWithFormat:@"%@",lab.text];
    CGSize size = [msg sizeWithFont:lab.font constrainedToSize:CGSizeMake(280, 100) lineBreakMode:lab.lineBreakMode];
    return size;
}


@end
