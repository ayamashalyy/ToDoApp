//
//  ViewController.h
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface ViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Task *> *tasksArray;
@property (nonatomic, strong) NSMutableArray<Task *> *filteredTasksArray;
@property (nonatomic, strong) UISearchController *searchController;
@property Task *savedTask;



@end

