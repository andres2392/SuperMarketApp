//
//  TodoListTableViewController.m
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/13/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import "TodoListTableViewController.h"
#import "ToDoListTableViewCell.h"
#import "ItemsCatTableViewController.h"
#import "Items+CoreDataClass.h"
#import "AddNewItemViewController.h"

@interface TodoListTableViewController ()
@property (nonatomic, strong) NSArray *itemsCategories;
@property (nonatomic, strong) Items *myItems;
@property (nonatomic, strong) NSMutableArray *myItemsDisp;
@property (nonatomic, assign ) BOOL find;


@end

@implementation TodoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    self.find = NO;
    
    self.itemsCategories = [[NSArray alloc]init];
    self.itemsCategories = @[ @"Flour",@"Rice",@"Drinks",@"Pasta",@"Sauces"];
    
    AddNewItemViewController *addNewViewController = [[AddNewItemViewController alloc]init];
    addNewViewController.itemsCategories = self.itemsCategories;
    
    /*
    Items *item1 = [[Items alloc]initWithContext:context];
    [item1 setValue:@"Rice" forKey:@"category"];
    [item1 setValue:@"21" forKey:@"quantity"];
    [item1 setValue:@"Rice" forKey:@"name"];
    
    
    Items *item2 = [[Items alloc]initWithContext:context];
    [item2 setValue:@"Rice" forKey:@"category"];
    [item2 setValue:@"21" forKey:@"quantity"];
    [item2 setValue:@"Perico" forKey:@"name"];
    
    Items *item3 = [[Items alloc]initWithContext:context];
    [item3 setValue:@"Pasta" forKey:@"category"];
    [item3 setValue:@"21" forKey:@"quantity"];
    [item3 setValue:@"pasta" forKey:@"name"];
    */
    

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
    return [self.itemsCategories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"TodoListCategoriesCell";
    ToDoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // populate cells with data
    cell.txtName.text = [self.itemsCategories objectAtIndex:indexPath.row];
    NSInteger categorieSize = [self findCategoriesSizes:[self.itemsCategories objectAtIndex:indexPath.row]];
    
    cell.txtCount.text = [NSString stringWithFormat:@"(%ld)",categorieSize ];
    
   
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier]isEqualToString:@"showItems"]){
        ItemsCatTableViewController *destinationViewController = [segue destinationViewController];
        // get the selection
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        NSString *key = [self.itemsCategories objectAtIndex:myIndexPath.row];
        NSLog(@"CATEGORY: %@", key);
        // Pass the selected object to the new view controller.
        destinationViewController.category = key;
    }
}

- (NSInteger)findCategoriesSizes:(NSString *)category {
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(category = %@)", category];
    [request setPredicate:pred];
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    return [objects count];
}

@end
