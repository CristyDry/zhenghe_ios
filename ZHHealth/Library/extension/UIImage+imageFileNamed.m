//
//  UIImage+imageFileNamed.m
//  ImageStretch
//
//  Created by HM on 13-10-11.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#define resourcesPath [[NSBundle mainBundle] resourcePath]
#import "UIImage+imageFileNamed.h"

@implementation UIImage (imageFileNamed)

+ (UIImage *)imageFileNamed:(NSString *)imageName andType:(BOOL)isPng
{
    UIImage * tempImage = nil;
    NSString * imagePath = nil;
    
    if (isPng) {
        if ([imageName hasSuffix:@"png"]) {
            imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        }else {
            imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        }
        
    }else {
        
        if ([imageName hasSuffix:@"jpg"]) {
            imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        }else {
            imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        }
        
    }
    
    tempImage = [[UIImage alloc] initWithContentsOfFile:imagePath];

    return tempImage ;
}

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

- (CGFloat)InProportionAtWidth:(CGFloat)width
{
    return  width / (self.size.width / self.size.height);
}

- (CGFloat)InProportionAtHeight:(CGFloat)height
{
    return height * (self.size.width / self.size.height);
}


@end
