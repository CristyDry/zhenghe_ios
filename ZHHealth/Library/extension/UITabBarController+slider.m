//
//  UITabBarController+slider.m
//  tabBar左右滑动
//
//  Created by 吴前途 on 15/9/7.
//  Copyright (c) 2015年 吴前途. All rights reserved.
//

#import "UITabBarController+slider.h"

@implementation UITabBarController (slider)

-(void)setOpenGestury
{
    //判断tabbar上的手势为空就创建
    if ([self.view.gestureRecognizers count] == 0)
    {
        //加左右滑手势
        UISwipeGestureRecognizer* recognizer = nil;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectNextPage:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.view addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectNextPage:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.view addGestureRecognizer:recognizer];
        
    }
    
}
//手势触发
-(void)selectNextPage:(UISwipeGestureRecognizer*)recognizer
{
    UIViewController* curViewC = self.selectedViewController;
    if ([curViewC isKindOfClass:[UINavigationController class]])
    {
        int subCount = (int)[((UINavigationController*)curViewC).viewControllers count];
        if (subCount > 1)
        {
            //pop
            if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
            {
                [((UINavigationController*)curViewC) popViewControllerAnimated:YES];
            }
            
            return;
        }
    }
    NSArray* ary = self.viewControllers;
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        
        for (int iIndex = 1 ;iIndex < ary.count ;iIndex++)
        {
            int nextIndex = (int)(self.selectedIndex + iIndex)%ary.count;
            
            UIViewController* c = [ary objectAtIndex:nextIndex];
            BOOL couldClick = YES;
            if([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
            {
                couldClick = [self.delegate tabBarController:self shouldSelectViewController:c];
            }
            
            if (!couldClick)
            {
                continue;
            }
            else
            {
                if (self.selectedIndex == 2) {// 去掉这个条件可以无限循环
                    
                }else {
                    [self achieveAnimation:(int)self.selectedIndex toIndex:nextIndex recognizerDirection:UISwipeGestureRecognizerDirectionLeft];
                    self.selectedIndex = nextIndex;
                }
                
                break;
            }
            
        }
        
        
    }
    
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        
        for (int searchCount = 1; searchCount < ary.count; searchCount++)
        {
            
            int nextIndex = (int)(self.selectedIndex - searchCount + ary.count)%ary.count;
            UIViewController* c = [ary objectAtIndex:nextIndex];
            BOOL couldClick = YES;
            if([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
            {
                couldClick = [self.delegate tabBarController:self shouldSelectViewController:c];
            }
            if (!couldClick)
            {
                continue;
            }
            else
            {
                
                if (self.selectedIndex == 0) { // 去掉这个条件可以无限循环
                    
                }else {
                    [self achieveAnimation:(int)self.selectedIndex toIndex:nextIndex recognizerDirection:UISwipeGestureRecognizerDirectionRight];
                    self.selectedIndex = nextIndex;
                }
                
                
                break;
            }
        }
        
    }
    
}

//截图方法，图片用来做动画
-(UIImage*)imageByCropping:(UIView*)imageToCrop toRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale*rect.size.width, scale*rect.size.height) ;
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext =UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext,-1*rect.origin.x,-1*rect.origin.y);
    [imageToCrop.layer renderInContext:resizedContext];
    UIImage*imageOriginBackground =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return imageOriginBackground;
}


-(void)achieveAnimation:(int)originIndex toIndex:(int)toIndex recognizerDirection:(UISwipeGestureRecognizerDirection)direction
{
    if (originIndex < 0 || originIndex >= self.viewControllers.count)
    {
//        EZGAssert(0);
        return;
    }
    if (toIndex < 0 || toIndex >= self.viewControllers.count)
    {
//        EZGAssert(0);
        return;
    }
    
    
    UIViewController* v1 = [self.viewControllers objectAtIndex:originIndex];
    UIViewController* v2 = [self.viewControllers objectAtIndex:toIndex];
    
    UIImage* image1 = [self imageByCropping:v1.view toRect:v1.view.bounds];
    UIImage* image2 = [self imageByCropping:v2.view toRect:v1.view.bounds];
    
    if (image1 == nil || image2 == nil)
    {
//        EZGAssert(0);
        return;
    }
    
    UIImageView* imageview1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* imageview2 = [[UIImageView alloc] initWithImage:image2];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    CGRect rectV1 = [v1.view convertRect:v1.view.bounds toView:window];
    //    CGRect rectV2 = [v2.view convertRect:v1.view.bounds toView:window];
    
    //set possion
    imageview1.frame = rectV1;
    imageview2.frame = rectV1;
    
    [window addSubview:imageview1];
    [window addSubview:imageview2];
    
    window.userInteractionEnabled = NO;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (direction == UISwipeGestureRecognizerDirectionLeft)
    {
        //to left
        imageview2.center = CGPointMake(imageview1.center.x + screenWidth, imageview1.center.y);
    }
    else
    {
        //to right
        imageview2.center = CGPointMake(imageview1.center.x - screenWidth, imageview1.center.y);
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        if (direction == UISwipeGestureRecognizerDirectionLeft){
            //to left
            imageview1.center = CGPointMake(imageview1.center.x - screenWidth, imageview1.center.y);
            imageview2.center = CGPointMake(imageview2.center.x - screenWidth, imageview1.center.y);
            
        }else{
            //to right
            imageview1.center = CGPointMake(imageview1.center.x + screenWidth, imageview1.center.y);
            imageview2.center = CGPointMake(imageview2.center.x + screenWidth, imageview1.center.y);
        }
        
        
    } completion:^(BOOL finished)
     {
         [imageview1 removeFromSuperview];
         [imageview2 removeFromSuperview];
         window.userInteractionEnabled = YES;
     }];
    
    
}
@end
