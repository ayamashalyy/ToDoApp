//
//  ViewController.m
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"
#import "EditTaskViewController.h"
#import "DetalisViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray<Task *> *ToDoTasksArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomTableViewCell"];
    self.tasksArray = [NSMutableArray array];
    self.filteredTasksArray = [NSMutableArray arrayWithArray:self.tasksArray];
    self.ToDoTasksArray = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search";
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self.ToDoTasksArray removeAllObjects];
    NSMutableArray<Task *> *retTasks = [self retrieveSavedTasks];
    for (Task *task in retTasks) {
        if (task.status == 0) {
            [self.ToDoTasksArray addObject:task];
        }
    }
        [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        return self.filteredTasksArray.count;
    } else {
        return self.ToDoTasksArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell" forIndexPath:indexPath];
    Task *task;
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        task = self.filteredTasksArray[indexPath.row];
    } else {
        task = self.ToDoTasksArray[indexPath.row];
    }
    
    switch (task.priority) {
        case 0:
            cell.firestImage.image = [UIImage imageNamed:@"h"];
            break;
        case 1:
            cell.firestImage.image = [UIImage imageNamed:@"m"];
            break;
        case 2:
            cell.firestImage.image = [UIImage imageNamed:@"l"];
            break;
        default:
            cell.secondImage.image = nil;
            break;
    }
    cell.title.text = task.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *selectedTask;
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        selectedTask = self.filteredTasksArray[indexPath.row];
    } else {
        selectedTask = self.ToDoTasksArray[indexPath.row];
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
        self.ToDoTasksArray[indexPath.row] = editedTask;
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {
    Task *deletedTask;
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        deletedTask = self.filteredTasksArray[indexPath.row];
        [self.filteredTasksArray removeObjectAtIndex:indexPath.row];
    } else {
        deletedTask = self.ToDoTasksArray[indexPath.row];
        [self.ToDoTasksArray removeObjectAtIndex:indexPath.row];
    }
    
    [self updateUserDefaultsAfterTaskDeletion]; 
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)updateUserDefaultsAfterTaskDeletion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:self.tasksArray];
    [defaults setObject:encodedTasks forKey:@"SavedTasks"];
    [defaults synchronize];
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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length == 0) {
        self.filteredTasksArray = [self.ToDoTasksArray mutableCopy];
    } else {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
        self.filteredTasksArray = [[self.tasksArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    }
    [self.tableView reloadData];
}

@end
