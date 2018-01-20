//
//  SearchViewController.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewControler.h>

@interface SearchViewController : BaseViewControler
@property (nonatomic,copy)  NSString *keys;
@property (nonatomic,strong)  NSMutableArray *doctorModelArray;
@property (nonatomic,assign)  BOOL *isformSearch;
@end
