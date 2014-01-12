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

//Persist Data for doctors, surgeries, and questions
//creates entities and saves them in CoreData
// jsonData keys are known to be ["doctors", "branch_questions", "surgeries", and "stack_questions"]
-(BOOL)persistData:(NSDictionary *)jsonData{
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSString *itemName = @"Item";
    NSString *itemListName = @"ItemList";
    
    //retrieve doctor data from json file
    NSArray *doctors = jsonData[@"doctors"];
    if (!doctors || [doctors count] == 0) {
        [self alertConfigFailure:@"doctors"];
        return false;
    }
    
    //create list entity for doctors
    ItemList *list = [NSEntityDescription
            insertNewObjectForEntityForName:itemListName
            inManagedObjectContext:context];
    list.name = @"doctors";
    
    //create item for each name and relate it to doctor list entity
    for (NSDictionary *doctor in doctors) {
        Item *d = [NSEntityDescription
                   insertNewObjectForEntityForName:itemName
                   inManagedObjectContext:context];
        d.value = doctor[@"doctor_name"];
        d.list = list;
    }
    
    
    //retrieve surgery names from json file
    NSArray *surgeries = jsonData[@"surgeries"];
    if (!surgeries || [surgeries count] == 0) {
        [self alertConfigFailure:@"surgeries"];
        return false;
    }
    
    //create list entity for surgeries
    list = [NSEntityDescription
                      insertNewObjectForEntityForName:itemListName
                      inManagedObjectContext:context];
    list.name = @"surgeries";
    
    //create item for each surgery and relate it to surgery list entity
    for (NSDictionary *surgery in surgeries) {
        Item *s = [NSEntityDescription
                   insertNewObjectForEntityForName:itemName
                   inManagedObjectContext:context];
        
        s.value = surgery[@"surgery_name"];
        s.list = list;
    }
    
    //persist questions
    if (![self persistQuestions:jsonData forQuestionKey:@"stack_questions"]) {
        [self alertConfigFailure:@"stack questions"];
        return false;
    }
    
    if (![self persistQuestions:jsonData forQuestionKey:@"branch_questions"]) {
        [self alertConfigFailure:@"branch questions"];
        return false;
    }
    
    return true;
}

-(BOOL)persistQuestions:(NSDictionary *)jsonData forQuestionKey:(NSString *)key {
    MyManagedObjectContext *context = self.managedObjectContext;
    //retrieve stack question chains from json file
    NSArray *list = jsonData[key];       //NSArray of dictionaries
    if (!list || [list count] == 0) {
        [self alertConfigFailure:key];
        return false;
    }
    
    //create ChainList entity that will store the question chains in order
    ChainList *cList = [NSEntityDescription
                        insertNewObjectForEntityForName:@"ChainList"
                        inManagedObjectContext:self.managedObjectContext];
    cList.name = key;
    
    //get each chain within the list
    for (NSDictionary *chainDic in list) {
        //NSInteger *chainID = chainDic[@"id"];
        //NSInteger *stack_index = chainDic[@"stack_index"];
        NSArray *questions = chainDic[@"questions"];
        QuestionList *qList = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionList" inManagedObjectContext:context];
        
        //get each question in the chain
        for (NSDictionary *question in questions) {
            Question *q = [NSEntityDescription insertNewObjectForEntityForName:@"Question"inManagedObjectContext:context];
            
            //get each option in the question
            NSArray *options = question[@"options"];
            for (NSDictionary *option in options) {
                Option *o = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:context];
                [self packOption:o intoQuestion:q withData:option];
            }
            [self packQuestion:q intoQuestionList:qList withData:question];
        }
        [self packQuestionList:qList intoChainList:cList withData:chainDic];
        
    } 
    return true;
}


// 3 methods for packing up questions when parsing the json
-(void)packQuestionList:(QuestionList *)qList intoChainList:(ChainList *)cList withData:(NSDictionary *)dic {
    qList.stack_index = dic[@"stack_index"];
    qList.branch_id = dic[@"id"];
    qList.list = cList;
}

-(void)packQuestion:(Question *)q intoQuestionList:(QuestionList *)qList withData:(NSDictionary *)dic {
    q.list_index = dic[@"chain_index"];
    q.display_group = dic[@"display_group"];
    q.display_text = dic[@"display_text"];
    q.question_text = dic[@"question_text"];
    q.question_type = dic[@"question_type"];
    q.list = qList;
}

-(void)packOption:(Option *)o intoQuestion:(Question *)q withData:(NSDictionary *)dic {
    NSNumber *branch_id = dic[@"branch_id"];
    if ([branch_id isEqual:[NSNull null]]) {
        branch_id = [NSNumber numberWithInt:-1];
    }
    o.branch_id = branch_id;
    
    NSString *translation = dic[@"translation"];
    if ([translation isEqual:[NSNull null]]) {
        translation = dic[@"text"];
    }
    o.translation = translation;
    o.text  = dic[@"text"];
    
    NSString *display_text = dic[@"display_text"]; //display empty string if none given
    if ([display_text isEqual:[NSNull null]]) {
        display_text = @"";
    }
    o.display_text = display_text;
    o.question = q;
}

// pop up alert and NSLog if config failure
-(void)alertConfigFailure:(NSString *)key {
    NSString *message = [NSString stringWithFormat:@"No %@ provided in config file", key];
    NSLog(@"%@", message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Config error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
    [alert show];
}

//not being used
//-(void)alertQuestionParsingFailure:(NSString *)key {
//    NSString *message = [NSString stringWithFormat:@"Error parsing json question data: %@", key];
//    NSLog(@"%@", message);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
//    [alert show];
//}

-(void)clearTables {
    NSLog(@"Clearing tables");
    [self deleteAllObjects:@"Item"];
    [self deleteAllObjects:@"ItemList"];
    [self deleteAllObjects:@"Option"];
    [self deleteAllObjects:@"Question"];
    [self deleteAllObjects:@"QuestionList"];
    [self deleteAllObjects:@"ChainList"];
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
