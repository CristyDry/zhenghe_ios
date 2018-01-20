//
//  BaseViewControler.m
//  ZHHealth
//
//  Created by Apple on 2018/1/21.
//  Copyright © 2018年 U1KJ. All rights reserved.
//

#import "BaseViewControler.h"

@interface BaseViewControler ()

@end

@implementation BaseViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    //开启iOS7及以上的滑动返回效果
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//UIGestureRecognizerDelegate 重写侧滑协议

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return [self gestureRecognizerShouldBegin];;
    
}

- (BOOL)gestureRecognizerShouldBegin {
    
    return YES;
    
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
