//
//  SpriteImageView.m
//  UCSDemo
//
//  Created by soso on 16/2/2.
//  Copyright © 2016年 UCS. All rights reserved.
//

#import "SpriteImageView.h"
#import "AFNetworking.h"

@implementation SpriteImageView


-(CGSize)imageSize
{
    if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        return CGSizeMake(60, 60);
    }
    
    return _imageSize;
}
-(NSInteger)row
{
    if (_row==0) {
        return 1;
    }
    return _row;
}

-(void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    self.count = imageArray.count;

    
    [self addUIimageViewByURLArray:imageArray];
    
}

-(void)addUIimageViewByURLArray:(NSArray *)urls
{
    NSInteger i = 0;
    
    for (UIView *volatiles in self.subviews) {
        [volatiles removeFromSuperview];
    }
    
    for (NSString *str in urls) {
        if ([str isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:str];
            
            UIImageView *imagev = [[UIImageView alloc]initWithFrame:(CGRect){i*50,0,50,50}];
            [imagev sd_setImageWithURL:url];
            
            [self addSubview:imagev];
        }
        
        i++;
    }
    
    
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect
{
    self.layer.contents = (__bridge id)image.CGImage;
    //scale contents to fit
    self.layer.contentsGravity = kCAGravityResizeAspect;
    //set contentsRect
    self.layer.contentsRect = rect;
}


@end
