//
//  BZShoppingCartModelSelected.h
//  ZHHealth
//
//  Created by pbz on 16/1/4.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZShoppingCartModelSelected : NSObject
//@property (nonatomic,strong)  NSMutableArray *shoppingCartModelSelected;
// 归档
+ (void)encode:(NSMutableArray *) addressModelArray;
// 解档
+ (NSMutableArray *)decode;
@end
