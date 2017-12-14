//
//  AddNewItemViewController.m
//  SuperMarketApp
//
//  Created by Andres Gonzalez on 12/13/17.
//  Copyright © 2017 Andres Gonzalez. All rights reserved.
//

#import "AddNewItemViewController.h"
#import "Items+CoreDataClass.h"

@interface AddNewItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eTxtName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCat;
@property (weak, nonatomic) IBOutlet UITextField *txtquantity;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end

@implementation AddNewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickerCat.delegate = self;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    self.itemsCategories = [[NSArray alloc]init];
    self.itemsCategories = @[ @"Flour",@"Rice",@"Drinks",@"Pasta",@"Sauces"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)Back:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addItem:(id)sender {
    
    Items *item = [[Items alloc]initWithContext:context];
    [item setValue:self.eTxtName.text forKey:@"name"];
    [item setValue:self.txtquantity.text forKey:@"quantity"];
    //row Selected
    NSInteger row = [self.pickerCat selectedRowInComponent:0];
    //fetch data
    NSString *selected = self.itemsCategories[row];
    [item setValue:selected forKey:@"category"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    [item setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
    
    // zero out the ui fields
    self.eTxtName.text = @"";
    self.txtquantity.text = @"";
    
    NSError *error;
    [context save:&error];
    
    self.lblStatus.text = @"Item Saved";
}


#pragma mark - Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.itemsCategories count];
}
#pragma mark - Picker Delegate Methods
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.itemsCategories [row];
}


@end
