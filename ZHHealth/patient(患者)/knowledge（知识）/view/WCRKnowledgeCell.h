//
//  WCRKnowledgeCell.h
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#define kWCRKnowledgeCellHeight 80

#import <UIKit/UIKit.h>

#import "BZArticleListModel.h"

@interface WCRKnowledgeCell : UITableViewCell

@property (nonatomic, strong) BZArticleListModel *knowledge;

@end
