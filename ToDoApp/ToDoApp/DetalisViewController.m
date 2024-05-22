//
//  DetalisViewController.m
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import "DetalisViewController.h"
#import "Task.h"

@interface DetalisViewController ()

@end

@implementation DetalisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.taskData) {
        self.titleText.text = self.taskData.title;
        self.descriptionText.text = self.taskData.desc;
        self.priority.selectedSegmentIndex = self.taskData.priority;
        self.status.selectedSegmentIndex = self.taskData.status;
        self.date.date = self.taskData.date;
        
        switch (self.taskData.status) {
            case 1:
                [self.status setEnabled:NO forSegmentAtIndex:0];
                break;
            case 2:
                self.titleText.enabled = NO;
                self.descriptionText.userInteractionEnabled = NO;
                self.status.userInteractionEnabled = NO;
                self.priority.userInteractionEnabled = NO;
                break;
            default:
                break;
        }
    }
    
    self.date.datePickerMode = UIDatePickerModeDateAndTime;
    self.date.minimumDate = [NSDate date];
    self.date.maximumDate = [NSDate distantFuture];
}


- (void)printTaskSavedMessage:(Task *)task {
    NSLog(@"Task saved successfully:");
    NSLog(@"Title: %@", task.title);
    NSLog(@"Description: %@", task.desc);
    NSLog(@"Priority: %d", task.priority);
    NSLog(@"Status: %d", task.status);
    NSLog(@"Date: %@", task.date);
}
- (NSMutableArray<Task *> *)retrieveSavedTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTasks = [defaults objectForKey:@"SavedTasks"];
    if (encodedTasks) {
        NSArray<Task *> *savedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasks];
        if (savedTasks) {
            return [savedTasks mutableCopy];
        }
    }
    return [NSMutableArray array];
}

- (IBAction)saveTask:(UIBarButtonItem *)sender {
    if ([self.titleText.text isEqualToString:@""] || [self.descriptionText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Title and description cannot be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    Task *task = [Task new];
    task.title = self.titleText.text;
    task.desc = self.descriptionText.text;
    task.priority = (int)self.priority.selectedSegmentIndex;
    task.date = self.date.date;
    task.status = (int)self.status.selectedSegmentIndex;
    
    // Retrieve existing tasks
    NSMutableArray<Task *> *savedTasks = [self retrieveSavedTasks];
    if (!savedTasks) {
        savedTasks = [NSMutableArray array];
    }
    // Add the new task to the array
    [savedTasks addObject:task];
    
    // Encode and save the updated array
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:savedTasks];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedTasks forKey:@"SavedTasks"];
    [defaults synchronize];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Task Saved"
                                                                   message:@"Your task has been saved successfully."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    [alert addAction:okAction];
    [self navigateToTab];
    [self presentViewController:alert animated:YES completion:nil];
    [self printTaskSavedMessage:task];
}


- (void)navigateToTab {
    switch (self.status.selectedSegmentIndex) {
        case 0:
            [self navigateToTabIndex:0];
            break;
        case 1:
            [self navigateToTabIndex:1];
            break;
        case 2:
            [self navigateToTabIndex:2];
            break;
        default:
            break;
    }
}


- (void)navigateToTabIndex:(NSInteger)index {
    UITabBarController *tabBarController = self.tabBarController;
    if (tabBarController && index < tabBarController.viewControllers.count) {
        [tabBarController setSelectedIndex:index];
    }
}




@end
