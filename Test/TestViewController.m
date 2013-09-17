//
//  TestViewController.m
//  TRx
//
//  Created by Mark Bellott on 9/12/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import "TestViewController.h"
#import "TestEntity.h"
#import "TestEntityRelated.h"
#import "TRAppDelegate.h"

@interface TestViewController ()

@end

@implementation TestViewController{
    NSString *_textOne;
    NSString *_textTwo;
    NSString *_textThree;
    NSString *_textFour;
    
    UITextField *_textFieldOne;
    UITextField *_textFieldTwo;
    UITextField *_textFieldThree;
    UITextField *_textFieldFour;
    
    UIButton *_submitButton;

}
@synthesize managedObjectContext;

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadTextFields];
    [self loadButtons];
}

- (void) loadTextFields{
    _textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(104, 296, 200, 30)];
    _textFieldOne.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldOne.placeholder = @"TextFieldOne";
    _textFieldOne.delegate = self;
    [self.view addSubview:_textFieldOne];
    
    _textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(442, 296, 200, 30)];
    _textFieldTwo.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldTwo.placeholder = @"TextFieldTwo";
    _textFieldTwo.delegate = self;
    [self.view addSubview:_textFieldTwo];
    
    _textFieldThree = [[UITextField alloc] initWithFrame:CGRectMake(104, 372, 200, 30)];
    _textFieldThree.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldThree.placeholder = @"TextFieldThree";
    _textFieldThree.delegate = self;
    [self.view addSubview:_textFieldThree];
    
    _textFieldFour = [[UITextField alloc] initWithFrame:CGRectMake(442, 372, 200, 30)];
    _textFieldFour.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldFour.placeholder = @"TextFieldFour";
    _textFieldFour.delegate = self;
    [self.view addSubview:_textFieldFour];
}

- (void) loadButtons{
    _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setFrame: CGRectMake(284, 497, 200, 30)];
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
}

#pragma mark - UITextFiedDelegate Methods

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _textFieldOne){
        _textOne = _textFieldOne.text;
    }
    else if(textField == _textFieldTwo){
        _textTwo = _textFieldTwo.text;
    }
    else if(textField == _textFieldThree){
        _textThree = _textFieldThree.text;
    }
    else if(textField == _textFieldFour){
        _textFour = _textFieldFour.text;
    }
}

#pragma mark - Submit Methods

- (void) submitButtonPressed{
    
    //starting with fresh local store each time
    [self deletePersistentStore];
    NSLog(@"Submit Button Pressed.");
    [self saveToCoreData];
    [self fetchData];
    //[self sendToServer];
}

#pragma mark - Touch Handling Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_textFieldOne.isEditing){
        [_textFieldOne resignFirstResponder];
    }
    else if(_textFieldTwo.isEditing){
        [_textFieldTwo resignFirstResponder];
    }
    else if(_textFieldThree.isEditing){
        [_textFieldThree resignFirstResponder];
    }
    else if(_textFieldFour.isEditing){
        [_textFieldFour resignFirstResponder];
    }
}

#pragma mark - Memory Handling Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data Methods

- (void)saveToCoreData{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    TestEntity *testEntity      = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"TestEntity"
                                   inManagedObjectContext:context];
    
    testEntity.textFieldOne     = _textOne;
    testEntity.textFieldTwo     = _textTwo;
    testEntity.textFieldThree   = _textThree;
    
    TestEntityRelated *testEntityRelated = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"TestEntityRelated"
                                        inManagedObjectContext:context];
    testEntityRelated.textFieldFour = _textFour;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Unable to save: %@", [error localizedDescription]);
    }
}

- (void)fetchData{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TestEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (TestEntity *obj in fetchedObjects) {
        NSLog(@"Field One: %@", obj.textFieldOne);
        NSLog(@"Field Two: %@", obj.textFieldTwo);
        NSLog(@"Field Three: %@", obj.textFieldThree);
        NSLog(@"Field Four: %@", obj.relatedField.textFieldFour);
    }
    
    entity = [NSEntityDescription entityForName:@"TestEntityRelated" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (TestEntityRelated *obj in fetchedObjects) {
        NSLog(@"Manual Retrieval Field Four: %@", obj.textFieldFour);
    }
}

- (void)sendToServer{
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
}

/* in dev it will be handy to delete SQLite persistent store 
 * probably want a button for this
 * SO: http://stackoverflow.com/questions/2375888/how-do-i-delete-all-objects-from-my-persistent-store-in-core-data?lq=1
 */
- (void)deletePersistentStore{
    NSError *error;
    NSURL *storeURL = [[managedObjectContext persistentStoreCoordinator] URLForPersistentStore:
                        [[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] ];
    [managedObjectContext lock];    //lock context
    [managedObjectContext reset];   //drop pending changes
    
    if ([[managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error]) {
        //remove the data file
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the store
        [[managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    [managedObjectContext unlock];
}



@end





















