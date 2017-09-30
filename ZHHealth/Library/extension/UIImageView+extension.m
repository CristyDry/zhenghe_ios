//
//  UIImageView+extension.m
//  Car
//
//  Created by U1KJ on 15/8/10.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import "UIImageView+extension.h"

@implementation UIImageView (extension)

-(void)imageViewWithImageName:(NSString *)imageName andModeScaleAspectFill:(BOOL)isAspectFill{
    self.image = [UIImage imageFileNamed:imageName andType:YES];
    self.backgroundColor = [UIColor clearColor];
    if (isAspectFill) {
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
}

-(void)imageViewWithImageName:(NSString *)imageName andModeScaleAspectFill:(BOOL)isAspectFill andCorner:(CGFloat)corner {
    self.image = [UIImage imageFileNamed:imageName andType:YES];
    self.backgroundColor = [UIColor clearColor];
    [self.layer setCornerRadius:corner];
    self.clipsToBounds = YES;
    if (isAspectFill) {
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
}


@end
