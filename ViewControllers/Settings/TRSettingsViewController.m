//
//  TRSettingsViewController.m
//  TRx
//
//  Created by Mark Bellott on 1/2/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRSettingsViewController.h"
#import "TRCustomButton.h"
#import "TRManagedObjectContext.h"
#import "CDItem.h"
#import "CDItemList.h"
#import "CDChainList.h"
#import "CDQuestion.h"
#import "CDQuestionList.h"
#import "CDOption.h"
#import "CDPatient.h"
#import "CDImage.h"

@interface TRSettingsViewController ()

@property (nonatomic, strong) TRManagedObjectContext  *managedObjectContext;

@end

@implementation TRSettingsViewController{
    UILabel *_configureLabel;
    UILabel *_exportLabel;
    UILabel *_deleteLabel;
    
    TRCustomButton *_configureButton;
    TRCustomButton *_deleteButton;
    TRCustomButton *_exportButton;
    
    NSMutableArray *_exportData;
    NSInteger attachmentCount;
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
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
}

- (void)viewWillAppear:(BOOL)animated{
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)initialSetup{
    [self loadLabels];
    [self loadButtons];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadLabels{
    _configureLabel = [[UILabel alloc] init];
    _configureLabel.font = [UIFont systemFontOfSize:17];
    _configureLabel.text = @"Configure local data, required immediately after installation.";
    
    _exportLabel = [[UILabel alloc] init];
    _exportLabel.font = [UIFont systemFontOfSize:17];
    _exportLabel.text = @"Export local data by email.";
    
    _deleteLabel = [[UILabel alloc] init];
    _deleteLabel.font = [UIFont systemFontOfSize:17];
    _deleteLabel.text = @"Delete all local patient data. This can't be undone!";
    
    [self.view addSubview:_configureLabel];
    [self.view addSubview:_exportLabel];
    [self.view addSubview:_deleteLabel];
}

- (void)loadButtons{
    _configureButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_configureButton addTarget:self action:@selector(configureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_configureButton setTitle:@"Configure" forState:UIControlStateNormal];
    [_configureButton drawButtonWithDefaultStyle];
    
    _exportButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_exportButton addTarget:self action:@selector(exportPressed) forControlEvents:UIControlEventTouchUpInside];
    [_exportButton setTitle:@"Export Data" forState:UIControlStateNormal];
    [_exportButton drawButtonWithDefaultStyle];
    
    _deleteButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_deleteButton addTarget:self action:@selector(deletePressed) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setTitle:@"Delete Data" forState:UIControlStateNormal];
    [_deleteButton drawButtonWithCancelStlye];
    
    [self.view addSubview:_configureButton];
    [self.view addSubview:_exportButton];
    [self.view addSubview:_deleteButton];
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
    
    //Patient Test Data
    [self patientTestData];
    
    //save context
    [self.managedObjectContext saveContext];
    
    /* Hey, Mark. This is how you can retrieve the Surgeries and the Doctors lists */
    /* the trickyish part is making sure that the controller has a managedObjectContext that is
        instantiated in the ViewDidLoad method by calling [MyManagedObjectContext mainThreadContext]
        as shown above */
    
    //test that objects are created and can retrieve them
    //NSLog(@"Listing doctors: ");
    NSOrderedSet *docs = [CDItemList getList:@"DoctorList" inContext:[self managedObjectContext]];
    for (CDItem *doc in docs) {
        //NSLog(@"%@", doc.value);
    }
    
    //NSLog(@"Listing Surgeries: ");
    NSOrderedSet *surgeries = [CDItemList getList:@"SurgeryList" inContext:[self managedObjectContext]];
    for (CDItem *surgery in surgeries) {
        //NSLog(@"%@", surgery.value);
    }
 
    //test retrieving questions
    /*
     
     I apologize for not being better at naming things.
     
     ChainList      -- a list of question chains. 
                    -- There are two ChainLists, stack_questions and branch_questions. 
                    -- To grab them from CoreData, use the Fetch Requests "StackList" and "BranchList" as seen below
     
        --once you have a ChainList, you can follow the relations down, as shown below
            -- each group has a to-many relationship with the items below it. That is, ChainList hasMany QuestionLists which can be reached by using the relationship property. A to-many relationship returns an NSOrderedSet of NSManagedObjects of whatever type. A to-one relationship just returns an NSManagedObject.
                ChainList -- has-many --> QuestionList -- has-many --> Question --has-many--> Option
                Option --has-one --> Question --has-one--> QuestionList --has-one --> ChainList
     
     

     You can retrieve the ChainList object that holds the mandatory stack
     
     NSOrderedSet *stack_chains = [CDChainList getChainsForRequestName:@"StackList" fromContext:[self managedObjectContext]];
     
     Sort these by stack_index, and then pop the questions onto the stack
     
     Branching could be done in different ways. Maybe the best would be to, at the end of configuration, to set up branch links between options and the QuestionLists they link to
     
     
     I'm not sure if that made anything clearer...
     
     */
    
    NSOrderedSet *stack_chains = [CDChainList getChainsForRequestName:@"StackList" fromContext:[self managedObjectContext]];
    for (CDQuestionList *qList in stack_chains) {
        
        NSLog(@"stack_index: %@", qList.stack_index);
        
        NSSet *questions = qList.questions;
        for (CDQuestion *q in questions) {
            NSLog(@"question: %@", q.question_text);
            
            NSOrderedSet *options = q.options;
            for (CDOption *o in options) {
                NSLog(@"option: %@", o.text);
            }
        }
        
        
        //NSLog(@"%@", qList);
    }
}

- (void)deletePressed{
    NSLog(@"DELETE!!!");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"This can not be undone!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I'm Sure", nil];
    [alertView show];
}

- (void)exportPressed{
    _exportData = [[NSMutableArray alloc] init];
    attachmentCount = 0;
    
    NSData *jsonData = [self getJSONOfRecordsOnApp];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [_exportData addObject:string];
    
    NSArray *shareArray = [[NSArray alloc] initWithArray:_exportData];
    
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    
    [self presentViewController:shareSheet animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self clearPatientData];
    }
}

#pragma mark - Configuration Methods

- (void)patientTestData{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    //Mark
    
    CDPatient *patient = [NSEntityDescription insertNewObjectForEntityForName:@"CDPatient"
                                                       inManagedObjectContext:self.managedObjectContext];
    patient.firstName = @"Mark";
    patient.lastName = @"Bellott";
    patient.surgeryType = @"Cataract";
    patient.doctor = @"Unknown";
    patient.birthday = [formatter dateFromString:@"September 17, 1990"];
    
    CDImage *profileImage = [NSEntityDescription insertNewObjectForEntityForName:@"CDImage"
                                                          inManagedObjectContext:self.managedObjectContext];
    profileImage.data = UIImagePNGRepresentation([UIImage imageNamed:@"mark.png"]);
    profileImage.belongsTo = patient;
    profileImage.belongsToProfile = patient;
    
    //Willie
    
    patient = [NSEntityDescription insertNewObjectForEntityForName:@"CDPatient"
                                                        inManagedObjectContext:self.managedObjectContext];
    patient.firstName = @"Willie";
    patient.lastName = @"Flaherty";
    patient.surgeryType = @"Hernia";
    patient.doctor = @"Unknown";
    patient.birthday = [formatter dateFromString:@"January 18, 1989"];
    
    profileImage = [NSEntityDescription insertNewObjectForEntityForName:@"CDImage"
                                                          inManagedObjectContext:self.managedObjectContext];
    profileImage.data = UIImagePNGRepresentation([UIImage imageNamed:@"willie.png"]);
    profileImage.belongsTo = patient;
    profileImage.belongsToProfile = patient;
    
    //Mischa
    
    patient = [NSEntityDescription insertNewObjectForEntityForName:@"CDPatient"
                                                        inManagedObjectContext:self.managedObjectContext];
    patient.firstName = @"Mischa";
    patient.lastName = @"Buckler";
    patient.surgeryType = @"Cataract";
    patient.doctor = @"Unknown";
    patient.birthday = [formatter dateFromString:@"April 13, 1991"];
    
    profileImage = [NSEntityDescription insertNewObjectForEntityForName:@"CDImage"
                                                 inManagedObjectContext:self.managedObjectContext];
    profileImage.data = UIImagePNGRepresentation([UIImage imageNamed:@"mischa.png"]);
    profileImage.belongsTo = patient;
    profileImage.belongsToProfile = patient;
    
}

- (NSData *)getConfigContents{
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"configure" ofType:@"json"];
    
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
    
    NSString *itemName = @"CDItem";
    NSString *itemListName = @"CDItemList";
    
    //retrieve doctor data from json file
    NSArray *doctors = jsonData[@"doctors"];
    if (!doctors || [doctors count] == 0) {
        [self alertConfigFailure:@"doctors"];
        return false;
    }
    
    //create list entity for doctors
    CDItemList *list = [NSEntityDescription
            insertNewObjectForEntityForName:itemListName
            inManagedObjectContext:context];
    list.name = @"doctors";
    
    //create item for each name and relate it to doctor list entity
    for (NSDictionary *doctor in doctors) {
        CDItem *d = [NSEntityDescription
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
        CDItem *s = [NSEntityDescription
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
    
    //set branches
    
    //get all chains in an array
    NSOrderedSet *stack_chains = [CDChainList getChainsForRequestName:@"StackList" fromContext:[self managedObjectContext]];
    NSOrderedSet *branch_chains = [CDChainList getChainsForRequestName:@"BranchList" fromContext:[self managedObjectContext]];
    NSMutableArray *chainsArray = [[NSMutableArray alloc] init];
    
    for (CDQuestionList *qList in stack_chains) {
        [chainsArray addObject:qList];
    }
    
    for (CDQuestionList *qList in branch_chains) {
        [chainsArray addObject:qList];
    }
    
    //get all options.
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDOption" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *optionsArray = [context executeFetchRequest:fetchRequest error:&error];
    if (optionsArray == nil) {
        NSLog(@"Error retrieving %@ list: %@", @"OptionList", error);
        return false;
    }
    
    //for every option, get the branch_id
    for (CDOption *o in optionsArray) {
        //find matching branch_id in chain and set link
        for (CDQuestionList *qList in chainsArray) {
            if (qList.branch_id == o.branch_id) {
                o.branchTo = qList;
            }
        }
    }
    return true;
}

-(BOOL)persistQuestions:(NSDictionary *)jsonData forQuestionKey:(NSString *)key {
    TRManagedObjectContext *context = self.managedObjectContext;
    //retrieve stack question chains from json file
    NSArray *list = jsonData[key];       //NSArray of dictionaries
    if (!list || [list count] == 0) {
        [self alertConfigFailure:key];
        return false;
    }
    
    //create ChainList entity that will store the question chains in order
    CDChainList *cList = [NSEntityDescription
                        insertNewObjectForEntityForName:@"CDChainList"
                        inManagedObjectContext:self.managedObjectContext];
    cList.name = key;
    
    //get each chain within the list
    for (NSDictionary *chainDic in list) {
        NSArray *questions = chainDic[@"questions"];
        CDQuestionList *qList = [NSEntityDescription insertNewObjectForEntityForName:@"CDQuestionList" inManagedObjectContext:context];
        
        //get each question in the chain
        for (NSDictionary *question in questions) {
            CDQuestion *q = [NSEntityDescription insertNewObjectForEntityForName:@"CDQuestion"inManagedObjectContext:context];
            
            //get each option in the question
            NSArray *options = question[@"options"];
            for (NSDictionary *option in options) {
                CDOption *o = [NSEntityDescription insertNewObjectForEntityForName:@"CDOption" inManagedObjectContext:context];
                [self packOption:o intoQuestion:q withData:option];
            }
            [self packQuestion:q intoQuestionList:qList withData:question];
        }
        [self packQuestionList:qList intoChainList:cList withData:chainDic];
        
    } 
    return true;
}


// 3 methods for packing up questions when parsing the json
-(void)packQuestionList:(CDQuestionList *)qList intoChainList:(CDChainList *)cList withData:(NSDictionary *)dic {
    qList.stack_index = dic[@"stack_index"];
    qList.branch_id = dic[@"id"];
    qList.list = cList;
}

-(void)packQuestion:(CDQuestion *)q intoQuestionList:(CDQuestionList *)qList withData:(NSDictionary *)dic {
    q.list_index = dic[@"chain_index"];
    q.display_group = dic[@"display_group"];
    q.display_text = dic[@"display_text"];
    q.question_text = dic[@"question_text"];
    q.question_type = dic[@"question_type"];
    q.list = qList;
}

-(void)packOption:(CDOption *)o intoQuestion:(CDQuestion *)q withData:(NSDictionary *)dic {
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


-(void)clearTables {
    NSLog(@"Clearing tables");
    [self deleteAllObjects:@"CDItem"];
    [self deleteAllObjects:@"CDItemList"];
    [self deleteAllObjects:@"CDOption"];
    [self deleteAllObjects:@"CDQuestion"];
    [self deleteAllObjects:@"CDQuestionList"];
    [self deleteAllObjects:@"CDChainList"];
    NSLog(@"Tables cleared");
}

- (void) clearPatientData{
    [self deleteAllObjects:@"CDPatient"];
    [self deleteAllObjects:@"CDImage"];
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	//NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

#pragma mark - Get JSON of patient records on app

- (NSData *)getJSONOfRecordsOnApp{
    
    //get patients and put in array
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPatient" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *patientArray = [context executeFetchRequest:fetchRequest error:&error];
    if (patientArray == nil) {
        NSLog(@"Error retrieving %@ list: %@", @"PatientList", error);
    }

    NSMutableArray *patientDicArray = [[NSMutableArray alloc] init];
    
    //properties returns a dictionary for each patient. add each dic to an array
    for (CDPatient *patient in patientArray) {
        [patientDicArray addObject:[self propertiesDictionary:entity forObject:patient atLevel:0]];
    }
    
    //now put the array in JSON format and test it
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:patientDicArray options:kNilOptions error:&error];
    
    NSString *testToString = [[NSString alloc] initWithData:JSONData encoding:NSJSONWritingPrettyPrinted];
    NSLog(@"%@", testToString);
    return JSONData;
}

- (NSDictionary *)propertiesDictionary:(NSEntityDescription *)entity forObject:(NSManagedObject *)object atLevel:(int)level
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *e;
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    for (id property in [entity properties])
    {
        if ([property isKindOfClass:[NSAttributeDescription class]])
        {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
            NSString *name = [attributeDescription name];
            NSString *val = [object valueForKey:name];

            if ([name isEqualToString:@"birthday"]) {
                val = [NSDateFormatter localizedStringFromDate:(NSDate *)val
                                                     dateStyle:NSDateFormatterShortStyle
                                                     timeStyle:NSDateFormatterNoStyle];
            }
            
            if ([name isEqualToString:@"data"]) {
                attachmentCount++;
                
                UIImage *exportImage = [UIImage imageWithData:(NSData*)[object valueForKey:name]];
                [_exportData addObject:UIImageJPEGRepresentation(exportImage, 0.5)];
                
                val = [[@"Attachment-" stringByAppendingString:
                        [NSString stringWithFormat:@"%ld",(long)attachmentCount]]
                       stringByAppendingString:@".jpeg"];;
            }

            [properties setValue:val forKey:name];
        }
        
        if ([property isKindOfClass:[NSRelationshipDescription class]] && level < 1)
        {
            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
            NSString *name = [relationshipDescription name];
            level++;
            //NSLog(@"****************** LEVEL: %d", level);
            if ([relationshipDescription isToMany])
            {
                NSMutableArray *arr = [properties valueForKey:name];
                if (!arr)
                {
                    arr = [[NSMutableArray alloc] init];
                    [properties setValue:arr forKey:name];
                }
                //recursive calls for many related child objects
                for (NSManagedObject *o in [object mutableSetValueForKey:name]) {
                    e = [NSEntityDescription entityForName:NSStringFromClass([o class]) inManagedObjectContext:context];
                    [arr addObject:[self propertiesDictionary:e forObject:o atLevel:level]];
                }
            }
            else
            {
                //one recursive call for related child
                NSManagedObject *o = [object valueForKey:name];
                e = [NSEntityDescription entityForName:NSStringFromClass([o class]) inManagedObjectContext:context];
                [properties setValue:[self propertiesDictionary:e forObject:o atLevel:level] forKey:name];
            }
        }
    }
    
    return properties;
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
    _configureButton.frame = CGRectMake(309, 240, 150, 50);
    _deleteButton.frame = CGRectMake(309, 472, 150, 50);
    _exportButton.frame = CGRectMake(309, 356, 150, 50);
    _configureLabel.frame = CGRectMake(157, 211, 455, 21);
    _exportLabel.frame = CGRectMake(282, 327, 204, 21);
    _deleteLabel.frame = CGRectMake(193, 443, 383, 21);
}

- (void)resizeFramesForLandscape{
    _configureButton.frame = CGRectMake(437, 138, 150, 50);
    _deleteButton.frame = CGRectMake(437, 370, 150, 50);
    _exportButton.frame = CGRectMake(437, 254, 150, 50);
    _configureLabel.frame = CGRectMake(285, 109, 455, 21);
    _exportLabel.frame = CGRectMake(410, 225, 204, 21);
    _deleteLabel.frame = CGRectMake(321, 341, 383, 21);

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
