//
//  SelectPhotosTools.h
//  Model
//
//  Created by ZhouZhenFu on 15/5/8.
//  Copyright (c) 2015年 优一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectPhotosTools : NSObject<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,weak) id controler;

@property (nonatomic,copy) void(^imageBlock)(UIImage *image);

//+(id)defaultSelsctPhotosTool;

+(void)showAtController:(UIViewController *)controler backImage:(void (^)(UIImage *image))imageBlock;

@end
