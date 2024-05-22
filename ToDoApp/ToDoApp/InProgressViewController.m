//
//  InProgressViewController.m
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import "InProgressViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"
#import "EditTaskViewController.h"
#import "DetalisViewController.h"

@interface InProgressViewController ()

@property (strong, nonatomic) NSMutableArray<Task *> *inProgressTasksArray;
@property (strong, nonatomic) NSMutableArray<Task *> *inProgressTasksArrayHigh;
@property (strong, nonatomic) NSMutableArray<Task *> *inProgressTasksArrayMedium;
@property (strong, nonatomic) NSMutableArray<Task *> *inProgressTasksArrayLow;

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *filterImage = [UIImage imageNamed:@"selection"];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(filterTasks)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    [self.tableView2 registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell2"];
    self.inProgressTasksArray = [NSMutableArray array];
    self.inProgressTasksArrayHigh = [NSMutableArray array];
    self.inProgressTasksArrayMedium = [NSMutableArray array];
    self.inProgressTasksArrayLow = [NSMutableArray array];
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    [self.tableView2 reloadData];
    [self configureEmptyState];
}

- (void)loadData {
    [self.inProgressTasksArray removeAllObjects];
    NSArray<Task *> *savedTasks = [self retrieveSavedTasks];
    for (Task *task in savedTasks) {
        if (task.status == 1) {
            [self.inProgressTasksArray addObject:task];
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
    [self.tableView2 reloadData];
    [self configureEmptyState];
}

- (void)filterTasksByPriority {
    [self.inProgressTasksArrayHigh removeAllObjects];
    [self.inProgressTasksArrayMedium removeAllObjects];
    [self.inProgressTasksArrayLow removeAllObjects];
    
    for (Task *task in self.inProgressTasksArray) {
        switch (task.priority) {
            case 0:
                [self.inProgressTasksArrayHigh addObject:task];
                break;
            case 1:
                [self.inProgressTasksArrayMedium addObject:task];
                break;
            case 2:
                [self.inProgressTasksArrayLow addObject:task];
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
                return self.inProgressTasksArrayHigh.count;
            case 1:
                return self.inProgressTasksArrayMedium.count;
            case 2:
                return self.inProgressTasksArrayLow.count;
            default:
                return 0;
        }
    } else {
        return self.inProgressTasksArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    Task *task;
    
    if (self.isFiltered) {
        switch (indexPath.section) {
            case 0:
                task = self.inProgressTasksArrayHigh[indexPath.row];
                break;
            case 1:
                task = self.inProgressTasksArrayMedium[indexPath.row];
                break;
            case 2:
                task = self.inProgressTasksArrayLow[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        task = self.inProgressTasksArray[indexPath.row];
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
                selectedTask = self.inProgressTasksArrayHigh[indexPath.row];
                break;
            case 1:
                selectedTask = self.inProgressTasksArrayMedium[indexPath.row];
                break;
            case 2:
                selectedTask = self.inProgressTasksArrayLow[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        selectedTask = self.inProgressTasksArray[indexPath.row];
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
                    self.inProgressTasksArrayHigh[indexPath.row] = editedTask;
                    break;
                case 1:
                    self.inProgressTasksArrayMedium[indexPath.row] = editedTask;
                    break;
                case 2:
                    self.inProgressTasksArrayLow[indexPath.row] = editedTask;
                    break;
                default:
                    break;
            }
        } else {
            self.inProgressTasksArray[indexPath.row] = editedTask;
        }
        [self.tableView2 reloadData];
    };
    
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFiltered) {
        switch (indexPath.section) {
            case 0:
                [self.inProgressTasksArrayHigh removeObjectAtIndex:indexPath.row];
                break;
            case 1:
                [self.inProgressTasksArrayMedium removeObjectAtIndex:indexPath.row];
                break;
            case 2:
                [self.inProgressTasksArrayLow removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
    } else {
        [self.inProgressTasksArray removeObjectAtIndex:indexPath.row];
    }
    [self updateUserDefaultsAfterTaskDeletion];
    [self.tableView2 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self configureEmptyState];
    [self.tableView2 reloadData];

}
- (void)updateUserDefaultsAfterTaskDeletion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:self.inProgressTasksArray];
    [defaults setObject:encodedTasks forKey:@"SavedTasks"];
    [defaults synchronize];
}
- (void)configureEmptyState {
    if (self.inProgressTasksArray.count == 0) {
        UIView *emptyStateView = [[UIView alloc] initWithFrame:self.tableView2.bounds];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"todo"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = CGPointMake(CGRectGetMidX(emptyStateView.bounds), CGRectGetMidY(emptyStateView.bounds));
        [emptyStateView addSubview:imageView];
        
        self.tableView2.backgroundView = emptyStateView;
    } else {
        self.tableView2.backgroundView = nil;
    }
}

@end
