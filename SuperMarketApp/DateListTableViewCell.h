//
//  DateListTableViewCell.h
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/15/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtCount;

@end
