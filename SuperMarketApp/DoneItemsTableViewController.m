//
//  DoneItemsTableViewController.m
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/15/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import "DoneItemsTableViewController.h"
#import "DoneItemsTableViewCell.h"
#import "Items+CoreDataClass.h"

@interface DoneItemsTableViewController ()
@property (nonatomic,strong) NSMutableArray *dateItems;

@end

@implementation DoneItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    [self findRecords];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.dateItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DoneItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemsDoneCell" forIndexPath:indexPath];
    
    // populate cells with data
    NSString *key = [self.dateItems objectAtIndex:indexPath.row];
    cell.txtName.text = [key valueForKey:@"name"];
    cell.txtQuantity.text = [key valueForKey:@"quantity"];
    cell.txtCategory.text = [key valueForKey:@"category"];
    
    return cell;
}




-(void)findRecords{
    
    //**********
    
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSString *done = @"YES";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@)", self.date];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(done = %@)", done];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred, predicate1]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count]==0){
        NSLog(@"Error fetching Items objects: %@\n%@", [error localizedDescription], [error userInfo]);
        
    }else {
        self.dateItems = objects;
        //NSLog(@"COUNT %lu ",[self.myItemsDisp count] );
        //NSLog(@"ITEMS FOUND %@", self.dateItems);
        
    }
}



@end
