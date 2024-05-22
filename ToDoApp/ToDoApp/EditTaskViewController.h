// EditTaskViewController.h

#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditTaskViewController : UIViewController

@property (nonatomic, strong) Task *task;
@property (nonatomic, copy) void (^completionHandler)(Task *editedTask);

@end
