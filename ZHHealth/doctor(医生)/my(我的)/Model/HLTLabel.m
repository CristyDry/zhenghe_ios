//
//  HLTLabel.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTLabel.h"

@implementation HLTLabel

-(HLTLabel *)useLabel:(NSString *)labelText
{
    CGFloat twidth = 100;
    CGFloat theight = 44;
    self.frame = CGRectMake((kMainWidth - twidth) * 0.5, 0, twidth, theight);
    self.text = labelText;
    self.textAlignment = NSTextAlignmentCenter;
    [self setTextColor:[UIColor whiteColor]];
    self.font = [UIFont boldSystemFontOfSize:21];
    return self;
}

@end
