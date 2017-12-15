//
//  DoneItemsTableViewController.h
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/15/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DoneItemsTableViewController : UITableViewController
{
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;
    
}
@property (nonatomic, strong) NSString *date;
@end
