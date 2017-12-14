//
//  AddNewItemViewController.h
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/13/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddNewItemViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;
    
}
@property (nonatomic, strong) NSArray *itemsCategories;
@end
