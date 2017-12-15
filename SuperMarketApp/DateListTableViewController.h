//
//  DateListTableViewController.h
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/15/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DateListTableViewController : UITableViewController
{
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;
    
}
@end
