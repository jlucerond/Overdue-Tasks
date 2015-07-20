//
//  MainPageTableViewController.m
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//

#import "MainPageTableViewController.h"
#import "Task.h"
#import "TaskInfoViewController.h"
#import "EditTaskViewController.h"

@interface MainPageTableViewController () <EditTaskViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tasks;

@end

@implementation MainPageTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [self convertArrayOfDictionariesFromNSUserDefaultsIntoTasksToBeDisplayed];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)tasks {
    if (!_tasks){
        _tasks = [[NSMutableArray alloc] init];
    }
    return _tasks;
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    
    Task *currentTaskForCell = self.tasks[indexPath.row];
    cell.textLabel.text = currentTaskForCell.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    cell.detailTextLabel.text = [formatter stringFromDate:currentTaskForCell.dueDate];
    if (currentTaskForCell.completed) {
        cell.textLabel.alpha = 0.5;
        cell.detailTextLabel.alpha = 0.5;
    }
    else{
        cell.textLabel.alpha = 1;
        cell.detailTextLabel.alpha = 1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *currentTaskForCell = self.tasks[indexPath.row];
    currentTaskForCell.completed = !currentTaskForCell.completed;
    [tableView reloadData];
    [self saveTableViewToNSUserDefaults];
}

#pragma mark - Helper Methods

- (void)createThreeSimpleTasks {
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    Task *task1 = [[Task alloc] init];
    task1.title = @"Do Dishes";
    task1.dueDate = [NSDate date];
    task1.notes = @"Do them pretty soon";
    task1.completed = true;
    
    Task *task2 = [[Task alloc] init];
    task2.title = @"Walk Dog";
    task2.dueDate = [NSDate date];
    task2.notes = @"He's going to run around";
    task2.completed = false;
    
    Task *task3 = [[Task alloc] init];
    task3.title = @"Make App";
    task3.dueDate = [NSDate date];
    task3.notes = @"Learning how to...";
    task3.completed = false;
    
    [self.tasks addObject:task1];
    [self.tasks addObject:task2];
    [self.tasks addObject:task3];
}

// this is for taking the saved tasks and displaying them
- (NSMutableArray *) convertArrayOfDictionariesFromNSUserDefaultsIntoTasksToBeDisplayed {
    NSMutableArray *arrayOfTasks = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfDictionaries = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_ARRAY_KEY_FOR_NSSTANDUSERSDEFAULTS] mutableCopy];
    
    for (NSDictionary *dictionaryOfTaskProperties in arrayOfDictionaries){
        
        BOOL isCompleted = 0;
        NSString *zeroOrOne = [dictionaryOfTaskProperties objectForKey:TASK_COMPLETED];
        if ([zeroOrOne isEqualToString:@"1"]) isCompleted = 1;
        
        Task *taskToBeAdded = [[Task alloc] initWith:[dictionaryOfTaskProperties objectForKey:TASK_TITLE] :[dictionaryOfTaskProperties objectForKey:TASK_DUEDATE] :[dictionaryOfTaskProperties objectForKey:TASK_NOTES] : isCompleted];
        [arrayOfTasks addObject:taskToBeAdded];
    }
    
    return arrayOfTasks;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TaskInfoViewController class]]){
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        TaskInfoViewController *nextVC = segue.destinationViewController;
        nextVC.task = self.tasks[path.row];
        nextVC.taskNumberInArray = path.row;
    }
    
    if ([segue.destinationViewController isKindOfClass:[EditTaskViewController class]]){
        EditTaskViewController *nextVC = segue.destinationViewController;
        nextVC.delegate = self;
        nextVC.didComeFromTaskInfoVC = false;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.tasks = [self convertArrayOfDictionariesFromNSUserDefaultsIntoTasksToBeDisplayed];
    [self.tableView reloadData];
}

#pragma mark - EditTaskViewControllerDelegate Methods

- (void)userDidCreateANewTask:(NSString *)title :(NSDate *)date :(NSString *)notes :(BOOL)completed {
    // add it to our table view
    // all of this is for viewing the table
    Task *newTask = [[Task alloc] initWith:title :date :notes :completed];
    [self.tasks addObject:newTask];
    [self.tableView reloadData];
    
    // save it to user defaults
    // this is all for permanent storage
//    NSMutableArray *arrayOfTasksAsDictionaries = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS_ARRAY_KEY_FOR_NSSTANDUSERSDEFAULTS] mutableCopy];
//    if (!arrayOfTasksAsDictionaries) arrayOfTasksAsDictionaries = [[NSMutableArray alloc] init];
//    [arrayOfTasksAsDictionaries addObject:[newTask transformSelfIntoDictionary]];
//    [[NSUserDefaults standardUserDefaults]  setObject:arrayOfTasksAsDictionaries forKey:TASKS_ARRAY_KEY_FOR_NSSTANDUSERSDEFAULTS];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self saveTableViewToNSUserDefaults];
    
}

- (void) saveTableViewToNSUserDefaults {
    NSMutableArray *arrayOfDictionariesToBeSaved = [[NSMutableArray alloc] init];
    for (Task *currentTask in self.tasks){
        [arrayOfDictionariesToBeSaved addObject:[currentTask transformSelfIntoDictionary]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrayOfDictionariesToBeSaved forKey:TASKS_ARRAY_KEY_FOR_NSSTANDUSERSDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark- TableView Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tasks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveTableViewToNSUserDefaults];
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
