//
//  TRSettingsViewController.m
//  TRx
//
//  Created by Mark Bellott on 1/2/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRSettingsViewController.h"
#import "TRCustomButton.h"


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
    
    //convert dictionary to Core Data objects
    [self persistData:jsonData];
}

#pragma mark - Configuration Methods

//
//  -- John --
//  Write your configuration methods here,
//  Call them From configureButtonPressed, above.
// Thanks! -John

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
    
    NSArray *surgeries = jsonData[@"surgeries"];
    if (!surgeries || [surgeries count] == 0) {
        NSLog(@"Error: No surgeries provided");
        return false;
    }
    NSEntityDescription *list = [NSEntityDescription insertNewObjectForEntityForName:itemListName inManagedObjectContext:context];
    list.name = @"surgeries";
    
    for (NSString *surgery in surgeries) {
        NSEntityDescription *s = [NSEntityDescription insertNewObjectForEntityForName:itemName inManagedObjectContext:context];
        s.name = surgery;
        //list.items = s;
        //list.relationshipsByName
        //[list relationshipsByName][@"items"] = s;
    }
    
    return true;
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
