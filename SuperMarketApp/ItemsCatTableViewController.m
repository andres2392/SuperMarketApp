//
//  ItemsCatTableViewController.m
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/13/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import "ItemsCatTableViewController.h"
#import "Items+CoreDataClass.h"
#import "ItemsCatTableViewCell.h"

@interface ItemsCatTableViewController ()
@property (nonatomic, strong) Items *myItems;
@property (nonatomic, strong) NSMutableArray *myItemsDisp;
@property (nonatomic, assign ) BOOL find;
@property (weak, nonatomic ) IBOutlet UILabel *patternLabel;

@end

@implementation ItemsCatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CATEGORY: %@", self.category);
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    self.find = NO;
    
    [self findRecord];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myItemsDisp count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemsCatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemsCatCell" forIndexPath:indexPath];
    
    // populate cells with data
    NSString *key = [self.myItemsDisp objectAtIndex:indexPath.row];
    cell.txtName.text = [key valueForKey:@"name"];
      cell.txtQuantity.text =[key valueForKey:@"quantity"];
    
    
    return cell;
}


// FIND RECORD
-(void)findRecord{
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSString *notDone = @"NO";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(category = %@)", self.category];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(done = %@)", notDone];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred, predicate1]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count]==0){
        NSLog(@"Error fetching Items objects: %@\n%@", [error localizedDescription], [error userInfo]);
        
    }else {
        self.myItemsDisp = objects;
        //NSLog(@"COUNT %lu ",[self.myItemsDisp count] );
        //NSLog(@"ITEMS FOUND %@", self.myItemsDisp);
        
        self.find = YES;
    }
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Done" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSString *doneItem = [self.myItemsDisp objectAtIndex:indexPath.row];
                                        
                                        [self passItem:doneItem];
                                        [self viewDidLoad];
                                        
                                        [tableView reloadData]; // tell table to refresh now
                                    }];
    button.backgroundColor = [UIColor greenColor]; //arbitrary color
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NSError *error = nil;
                                         [context deleteObject:[self.myItemsDisp objectAtIndex:indexPath.row]];
                                         [context save:&error];
                                         
                                         NSLog(@"Object deleted");
                                         [self viewDidLoad];
                                         
                                         [tableView reloadData]; // tell table to refresh now
                                     }];
    button2.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[button, button2]; //array with all the buttons you want. 1,2,3, etc...
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}

-(void)passItem: (Items*) item {
    
    Items *item6 = [[Items alloc]initWithContext:context];
    [item6 setValue: [item valueForKey:@"category"] forKey:@"category"];
    [item6 setValue:[item valueForKey:@"quantity"] forKey:@"quantity"];
    [item6 setValue:[item valueForKey:@"name"] forKey:@"name"];
    [item6 setValue:@"YES" forKey:@"done"];
    [item6 setValue:[item valueForKey:@"date"] forKey:@"date"];
    
    NSError *error = nil;
    [context deleteObject:item];
    [context save:&error];
    
    NSLog(@"Object deleted");
}



@end
