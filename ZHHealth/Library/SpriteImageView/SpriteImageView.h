//
//  SpriteImageView.h
//  UCSDemo
//
//  Created by soso on 16/2/2.
//  Copyright © 2016年 UCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpriteImageView : UIView
{
    
}

@property (nonatomic , assign)NSInteger row;

@property (nonatomic , assign)NSInteger count;

@property (nonatomic , assign)CGSize imageSize;

@property (nonatomic , strong)NSArray *imageArray;

@property (nonatomic , strong)UIImage *contentImage;

@end
