//
//  UIImage+imageFileNamed.h
//  ImageStretch
//
//  Created by HM on 13-10-11.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageFileNamed)

/**
 *  根据文件名加载图片
 *
 *  @param imageName 文件名
 *  @param isPng     YES:PNG   NO:JPG
 *
 *  @return image
 */
+ (UIImage *)imageFileNamed:(NSString *)imageName andType:(BOOL)isPng;

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

/**
 *  按图片的比例，根据宽取得 按比例的高
 *
 *  @param width 宽
 *
 *  @return 高
 */
- (CGFloat)InProportionAtWidth:(CGFloat)width;

/**
 *  取图片的比例，根据高取得 按比例的宽
 *
 *  @param height 高
 *
 *  @return 宽
 */
- (CGFloat)InProportionAtHeight:(CGFloat)height;



@end
