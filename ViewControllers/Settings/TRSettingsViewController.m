//
//  TRSettingsViewController.m
//  TRx
//
//  Created by Mark Bellott on 1/2/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRSettingsViewController.h"
#import "TRCustomButton.h"
#import "Item.h"
#import "ItemList.h"


@interface TRSettingsViewController ()

@end

@implementation TRSettingsViewController{
    TRCustomButton *_configureButton;
}

#pragma mark Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self initialSetup];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.managedObjectContext = [MyManagedObjectContext mainThreadContext];
}

- (void)viewWillAppear:(BOOL)animated{
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)initialSetup{
    [self loadButtons];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadButtons{
    _configureButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_configureButton addTarget:self action:@selector(configureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_configureButton setTitle:@"Configure" forState:UIControlStateNormal];
    [_configureButton drawButtonWithColor:self.view.tintColor];
    
    [self.view addSubview:_configureButton];
}

#pragma mark - Button Methods

- (void)configureButtonPressed{
    NSLog(@"Configure Pressed");
    
    //retrieve data
    NSData *data = [self getConfigContents];
    if (!data) {
        NSLog(@"Error turning string to Data");
        return;
    }
    
    //parse JSON into dictionary
    NSError *err;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if (!jsonData) {
        NSLog(@"Error parsing JSON config file");
        return;
    }
    
    //clear tables
    [self clearTables];
    
    //convert dictionary to Core Data objects
    [self persistData:jsonData];
    
    //save context
    [self.managedObjectContext saveContext];
    
    /* Hey, Mark. This is how you can retrieve the Surgeries and the Doctors lists */
    /* the trickyish part is making sure that the controller has a managedObjectContext that is
        instantiated in the ViewDidLoad method by calling [MyManagedObjectContext mainThreadContext]
        as shown above */
    
    //test that objects are created and can retrieve them
    NSLog(@"Listing doctors: ");
    NSOrderedSet *docs = [ItemList getList:@"DoctorList" inContext:[self managedObjectContext]];
    for (Item *doc in docs) {
        NSLog(@"%@", doc.value);
    }
    
    NSLog(@"Listing Surgeries: ");
    NSOrderedSet *surgeries = [ItemList getList:@"SurgeryList" inContext:[self managedObjectContext]];
    for (Item *surgery in surgeries) {
        NSLog(@"%@", surgery.value);
    }
 
    //TODO: clear tables on new config press
}

#pragma mark - Configuration Methods

- (NSData *)getConfigContents{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    if (!data) {
        NSLog(@"error retrieving config file: %@", jsonPath);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Config error" message:@"File not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        return Nil;
    }
    
    return data;
}

//#TODO - delete data before creating new objects
-(BOOL)persistData:(NSDictionary *)jsonData{
    // Dictionary keys are known to be ["doctors", "branch_questions", "surgeries", and "stack_questions"]
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSString *itemName = @"Item";
    NSString *itemListName = @"ItemList";
    

    
    //persist doctors
    NSArray *doctors = jsonData[@"doctors"];
    if (!doctors || [doctors count] == 0) {
        NSLog(@"Error: No doctors provided");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Config error" message:@"No doctors provided in config file" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        return false;
    }
    
    ItemList *list2 = [NSEntityDescription
            insertNewObjectForEntityForName:itemListName
            inManagedObjectContext:context];
    list2.name = @"doctors";
    
    for (NSDictionary *doctor in doctors) {
        Item *d = [NSEntityDescription
                   insertNewObjectForEntityForName:itemName
                   inManagedObjectContext:context];
        d.value = doctor[@"doctor_name"];
        d.list = list2;
    }
    
    
    //persist surgeries
    NSArray *surgeries = jsonData[@"surgeries"];
    if (!surgeries || [surgeries count] == 0) {
        NSLog(@"Error: No surgeries provided");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Config error" message:@"No surgeries provided in config file" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        return false;
    }
    
    ItemList *list = [NSEntityDescription
                      insertNewObjectForEntityForName:itemListName
                      inManagedObjectContext:context];
    list.name = @"surgeries";
    
    
    for (NSDictionary *surgery in surgeries) {  //add each surgery to ItemList named 'surgeries'
        Item *s = [NSEntityDescription
                   insertNewObjectForEntityForName:itemName
                   inManagedObjectContext:context];
        
        s.value = surgery[@"surgery_name"];
        s.list = list;
    }
    
    return true;
}

-(void)clearTables {
    NSLog(@"Clearing tables");
    [self deleteAllObjects:@"Item"];
    [self deleteAllObjects:@"ItemList"];
    NSLog(@"Tables cleared");
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

#pragma mark - Orientation Handling Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

- (void)resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    
    if(newOrientation == UIInterfaceOrientationPortrait ||
       newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        [self resizeFramesForPortrait];
        
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft ||
            newOrientation == UIInterfaceOrientationLandscapeRight){
        
        [self resizeFramesForLandscape];
        
    }
}

#pragma mark - Frame Sizing Methods

- (void)resizeFramesForPortrait{
    _configureButton.frame = CGRectMake(309, 477, 150, 50);
}

- (void)resizeFramesForLandscape{
    _configureButton.frame = CGRectMake(437, 359, 150, 50);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
