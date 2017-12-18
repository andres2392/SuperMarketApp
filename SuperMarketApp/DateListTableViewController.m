//
//  DateListTableViewController.m
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/15/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import "DateListTableViewController.h"
#import "Items+CoreDataClass.h"
#import "DateListTableViewCell.h"
#import "DoneItemsTableViewController.h"

@interface DateListTableViewController ()

@property (nonatomic, strong) NSMutableArray *myDatesDisp;
@property (nonatomic, strong) NSArray *arrayWithoutDuplicates;
@end

@implementation DateListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    [self findRecord];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"];
    [refresh addTarget:self action:@selector(refresh)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
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
    return [self.arrayWithoutDuplicates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"DateListCell";
    DateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // populate cells with data
    NSString *key = [self.arrayWithoutDuplicates objectAtIndex:indexPath.row];
    cell.txtName.text = [key valueForKey:@"date"];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]isEqualToString:@"showDoneItems"]){
        
        DoneItemsTableViewController  *destinationViewController = [segue destinationViewController];
        // get the selection
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        NSManagedObjectModel *key = [self.arrayWithoutDuplicates objectAtIndex:myIndexPath.row];
        // Pass the selected object to the new view controller.

        //NSLog(@"DATE KEY %@", [key valueForKey:@"date"]);
        destinationViewController.title =[key valueForKey:@"date"];
        destinationViewController.date = [key valueForKey:@"date"];
    }
}


-(void)findRecord{
    
    //**********
    
   
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSString *done = @"YES";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(done = %@)", done];
    
    [request setPredicate:predicate1];
    
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Items"];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count]==0){
        NSLog(@"Error fetching Items objects: %@\n%@", [error localizedDescription], [error userInfo]);
        
    }else {
        self.myDatesDisp = objects;
       // NSLog(@"COUNT %lu ",[self.myDatesDisp count] );
       //NSLog(@"ITEMS FOUND %@", self.myDatesDisp);
        
        NSMutableArray *unique = [NSMutableArray array];
        
        for (id obj in _myDatesDisp){
            
            if (![[unique valueForKey:@"date"] containsObject:[obj valueForKey:@"date"]]) {
                [unique addObject:obj];
            }
        }
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:unique];
        self.arrayWithoutDuplicates = [orderedSet array];
        NSLog(@"DATES : %@", self.arrayWithoutDuplicates );
    }
}

- (void)stopRefresh

{
    [self.refreshControl endRefreshing];
    
}

- (void)refresh{

    [self findRecord];
    [self viewDidLoad];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
    
}

-(void) viewDidAppear:(BOOL)animated{
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]  initWithEntityName:@"Items"];
    //self.itemsCategories = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    [self.tableView reloadData];
}
@end
