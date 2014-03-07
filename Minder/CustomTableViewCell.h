//
//  CustomTableViewCell.h
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *quoteLabel;
@end
