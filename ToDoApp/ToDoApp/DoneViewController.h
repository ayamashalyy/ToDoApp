//
//  DoneViewController.h
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property Task *savedTask;
@property BOOL isFiltered;

@end

NS_ASSUME_NONNULL_END
