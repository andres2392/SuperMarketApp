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

@end

@implementation ItemsCatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CATEGORY: %@", self.category);
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    self.find = NO;
    
    [self findRecord];
    
    if (!self.find) {
        
    }
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
    cell.txtQuantity.text = [key valueForKey:@"quantity"];
    
    return cell;
}


-(void)findRecord{
    
    //**********
   
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(category = %@)", self.category];
    NSLog(@"PREDICATE %@", pred);
    [request setPredicate:pred];
    
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Items"];
    
    NSLog(@"PREDICATE %@", request);
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count]==0){
        NSLog(@"Error fetching Items objects: %@\n%@", [error localizedDescription], [error userInfo]);
        
    }else {
        self.myItemsDisp = objects;
        NSLog(@"COUNT %lu ",[self.myItemsDisp count] );
        NSLog(@"ITEMS FOUND %@", self.myItemsDisp);
        
        self.find = YES;
    }
}
@end
