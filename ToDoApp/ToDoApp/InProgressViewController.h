//
//  InProgressViewController.h
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
//@property (strong, nonatomic) NSMutableArray<Task *> *tasksArray;
@property Task *savedTask;
@property Task *high;
@property Task *madium;
@property Task *low;
@property BOOL isFiltered;


@end

NS_ASSUME_NONNULL_END
