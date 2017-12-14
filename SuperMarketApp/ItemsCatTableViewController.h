//
//  ItemsCatTableViewController.h
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/13/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ItemsCatTableViewController : UITableViewController
{
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;

}
@property (nonatomic, strong) NSString *category;
@end
