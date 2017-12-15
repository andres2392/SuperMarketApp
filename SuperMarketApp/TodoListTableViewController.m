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
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"];
    [refresh addTarget:self action:@selector(refresh)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    Items *item1 = [[Items alloc]initWithContext:context];
    [item1 setValue:@"Rice" forKey:@"category"];
    [item1 setValue:@"21" forKey:@"quantity"];
    [item1 setValue:@"PUERCO" forKey:@"name"];
    [item1 setValue:@"NO" forKey:@"done"];
    [item1 setValue:@"11/11/2017" forKey:@"date"];
    
    Items *item2 = [[Items alloc]initWithContext:context];
    [item2 setValue:@"Rice" forKey:@"category"];
    [item2 setValue:@"21" forKey:@"quantity"];
    [item2 setValue:@"Perico" forKey:@"name"];
    [item2 setValue:@"NO" forKey:@"done"];
    [item2 setValue:@"11/13/2017" forKey:@"date"];
    
    Items *item3 = [[Items alloc]initWithContext:context];
    [item3 setValue:@"Pasta" forKey:@"category"];
    [item3 setValue:@"21" forKey:@"quantity"];
    [item3 setValue:@"pasta" forKey:@"name"];
    [item3 setValue:@"NO" forKey:@"done"];
    [item3 setValue:@"11/11/2017" forKey:@"date"];
    
    
    //DONE OBJECTS
    Items *item4 = [[Items alloc]initWithContext:context];
    [item4 setValue:@"Drinks" forKey:@"category"];
    [item4 setValue:@"21" forKey:@"quantity"];
    [item4 setValue:@"Toyota" forKey:@"name"];
    [item4 setValue:@"YES" forKey:@"done"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [item4 setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
    
    Items *item5 = [[Items alloc]initWithContext:context];
    [item5 setValue:@"Sauces" forKey:@"category"];
    [item5 setValue:@"21" forKey:@"quantity"];
    [item5 setValue:@"Salsa" forKey:@"name"];
    [item5 setValue:@"YES" forKey:@"done"];
    [item5 setValue:@"11/14/2016" forKey:@"date"];
    
    Items *item6 = [[Items alloc]initWithContext:context];
    [item6 setValue:@"Sauces" forKey:@"category"];
    [item6 setValue:@"21" forKey:@"quantity"];
    [item6 setValue:@"Salsa" forKey:@"name"];
    [item6 setValue:@"YES" forKey:@"done"];
    [item6 setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
    
    Items *item7 = [[Items alloc]initWithContext:context];
    [item7 setValue:@"Sauces" forKey:@"category"];
    [item7 setValue:@"21" forKey:@"quantity"];
    [item7 setValue:@"Salsa" forKey:@"name"];
    [item7 setValue:@"YES" forKey:@"done"];
    [item7 setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
    
    
   // NSLog(@"ITEMS %@ %@ %@ ", item1, item2, item3);

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
        // Pass the selected object to the new view controller.
        destinationViewController.category = key;
    }
}

- (NSInteger)findCategoriesSizes:(NSString *)category {
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    NSString *notDone = @"NO";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(category = %@)", category];
   NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(done = %@)", notDone];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred, predicate1]];
   
    [request setPredicate:predicate];
    //NSLog(@"PREDICATE %@", predicate);
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    if ([objects count]== 0) {
        return 0;
    }else{
        //NSLog(@"ARRAY SIZE %lu", [objects count]);
        //NSLog(@"ITEMS %@ &@", objects[0], objects[1]);
        return [objects count];
    }
    
}

- (void)stopRefresh

{
    [self.refreshControl endRefreshing];
    
}

- (void)refresh{
    
    [self viewDidLoad];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
    
}

@end
