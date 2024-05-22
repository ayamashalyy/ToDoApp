//
//  DetalisViewController.h
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetalisViewController : UIViewController
- (IBAction)saveTask:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;


@property (nonatomic, strong) Task *task;
@property (nonatomic, copy) void (^completionHandler)(Task *editedTask);
@property (nonatomic, strong) Task *taskData;

@end

NS_ASSUME_NONNULL_END
