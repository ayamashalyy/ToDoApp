//
//  DoneViewController.m
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import "DoneViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"
#import "EditTaskViewController.h"
#import "DetalisViewController.h"

@interface DoneViewController ()
@property (strong, nonatomic) NSMutableArray<Task *> *inDoneTasksArray;
@property (strong, nonatomic) NSMutableArray<Task *> *inDoneTasksArrayHigh;
@property (strong, nonatomic) NSMutableArray<Task *> *inDoneTasksArrayMedium;
@property (strong, nonatomic) NSMutableArray<Task *> *inDoneTasksArrayLow;
@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *filterImage = [UIImage imageNamed:@"selection"];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(filterTasks)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
   
    
    [self.tableView3 registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell3"];
    self.inDoneTasksArray = [NSMutableArray array];
    self.inDoneTasksArrayHigh = [NSMutableArray array];
    self.inDoneTasksArrayMedium = [NSMutableArray array];
    self.inDoneTasksArrayLow = [NSMutableArray array];
    self.tableView3.dataSource = self;
    self.tableView3.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    [self.tableView3 reloadData];
    [self configureEmptyState];
}

- (void)loadData {
    [self.inDoneTasksArray removeAllObjects];
    NSArray<Task *> *savedTasks = [self retrieveSavedTasks];
    for (Task *task in savedTasks) {
        if (task.status == 2) {
            [self.inDoneTasksArray addObject:task];
        }
    }
}

- (NSMutableArray<Task *> *)retrieveSavedTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTasks = [defaults objectForKey:@"SavedTasks"];
    if (encodedTasks) {
        NSArray<Task *> *savedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasks];
        return [savedTasks mutableCopy];
    }
    return [NSMutableArray array];
}



- (void)filterTasks {
    self.isFiltered = !self.isFiltered;
    if (self.isFiltered) {
        [self filterTasksByPriority];
    } else {
        [self loadData];
    }
    [self.tableView3 reloadData];
    [self configureEmptyState];
}


- (void)filterTasksByPriority {
    [self.inDoneTasksArrayHigh removeAllObjects];
    [self.inDoneTasksArrayMedium removeAllObjects];
    [self.inDoneTasksArrayLow removeAllObjects];
    
    for (Task *task in self.inDoneTasksArray) {
        switch (task.priority) {
            case 0:
                [self.inDoneTasksArrayHigh addObject:task];
                break;
            case 1:
                [self.inDoneTasksArrayMedium addObject:task];
                break;
            case 2:
                [self.inDoneTasksArrayLow addObject:task];
                break;
            default:
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isFiltered) {
        return 3;
    } else {
        return 1;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isFiltered) {
        switch (section) {
            case 0:
                return @"High Priority";
            case 1:
                return @"Medium Priority";
            case 2:
                return @"Low Priority";
            default:
                return nil;
        }
    } else {
        return nil;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFiltered) {
        switch (section) {
            case 0:
                return self.inDoneTasksArrayHigh.count;
            case 1:
                return self.inDoneTasksArrayMedium.count;
            case 2:
                return self.inDoneTasksArrayLow.count;
            default:
                return 0;
        }
    } else {
        return self.inDoneTasksArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    Task *task;
    if (self.isFiltered) {
        switch (indexPath.section) {
            case 0:
                task = self.inDoneTasksArrayHigh[indexPath.row];
                break;
            case 1:
                task = self.inDoneTasksArrayMedium[indexPath.row];
                break;
            case 2:
                task = self.inDoneTasksArrayLow[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        task = self.inDoneTasksArray[indexPath.row];
    }
    
    UILabel *title = (UILabel *)[cell viewWithTag:0];
    title.text = task.title;
    
    switch (task.priority) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"h"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"m"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"l"];
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *selectedTask;
    if (self.isFiltered) {
        switch (indexPath.section) {
            case 0:
                selectedTask = self.inDoneTasksArrayHigh[indexPath.row];
                break;
            case 1:
                selectedTask = self.inDoneTasksArrayMedium[indexPath.row];
                break;
            case 2:
                selectedTask = self.inDoneTasksArrayLow[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        selectedTask = self.inDoneTasksArray[indexPath.row];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit or Delete Task" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editTask:selectedTask atIndexPath:indexPath];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteTaskAtIndexPath:indexPath];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:editAction];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)editTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetalisViewController *editViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetalisViewController"];
    
    editViewController.taskData = task;
    editViewController.completionHandler = ^(Task *editedTask) {
        if (self.isFiltered) {
            switch (editedTask.priority) {
                case 0:
                    self.inDoneTasksArrayHigh[indexPath.row] = editedTask;
                    break;
                case 1:
                    self.inDoneTasksArrayMedium[indexPath.row] = editedTask;
                    break;
                case 2:
                    self.inDoneTasksArrayLow[indexPath.row] = editedTask;
                    break;
                default:
                    break;
            }
        } else {
            self.inDoneTasksArray[indexPath.row] = editedTask;
        }
        [self.tableView3 reloadData];
    };
    
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFiltered) {
        switch (indexPath.section) {
            case 0:
                [self.inDoneTasksArrayHigh removeObjectAtIndex:indexPath.row];
                break;
            case 1:
                [self.inDoneTasksArrayMedium removeObjectAtIndex:indexPath.row];
                break;
            case 2:
                [self.inDoneTasksArrayLow removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
    } else {
        [self.inDoneTasksArray removeObjectAtIndex:indexPath.row];
    }
    
    [self.tableView3 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self configureEmptyState];
    [self.tableView3 reloadData];

}


- (void)updateUserDefaultsAfterTaskDeletion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self updateUserDefaultsAfterTaskDeletion];
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:self.inDoneTasksArray];
    [defaults setObject:encodedTasks forKey:@"SavedTasks"];
    [defaults synchronize];
}

- (void)configureEmptyState {
    if (self.inDoneTasksArray.count == 0) {
        UIView *emptyStateView = [[UIView alloc] initWithFrame:self.tableView3.bounds];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tasks"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = CGPointMake(CGRectGetMidX(emptyStateView.bounds), CGRectGetMidY(emptyStateView.bounds));
        [emptyStateView addSubview:imageView];
        
        self.tableView3.backgroundView = emptyStateView;
    } else {
        self.tableView3.backgroundView = nil;
    }
}

@end
