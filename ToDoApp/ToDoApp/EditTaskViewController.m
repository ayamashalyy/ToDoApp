//
//  EditTaskViewController.m
//  ToDoApp
//
//  Created by aya on 22/04/2024.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextField.text = self.task.title;
    self.descriptionTextField.text = self.task.desc;
    self.prioritySegmentedControl.selectedSegmentIndex = self.task.priority;
    self.statusSegmentedControl.selectedSegmentIndex = self.task.status;
    self.datePicker.date = self.task.date;
}

- (IBAction)saveButtonTapped:(id)sender {
    self.task.title = self.titleTextField.text;
    self.task.desc = self.descriptionTextField.text;
    self.task.priority = (int)self.prioritySegmentedControl.selectedSegmentIndex;
    self.task.status = (int)self.statusSegmentedControl.selectedSegmentIndex;
    self.task.date = self.datePicker.date;
    
    if (self.completionHandler) {
        self.completionHandler(self.task);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
