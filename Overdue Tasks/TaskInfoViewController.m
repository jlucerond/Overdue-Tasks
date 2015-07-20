//
//  TaskInfoViewController.m
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//



#import "TaskInfoViewController.h"
#import "EditTaskViewController.h"
#import "MainPageTableViewController.h"

@interface TaskInfoViewController () <EditTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TaskInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    if (self.shouldImmediatelyGoToEditScreen) [self performSegueWithIdentifier:@"editTask" sender:self];
    self.textView.text = [self convertTaskForTextView];
    [self.textView setFont:[UIFont boldSystemFontOfSize:20]];
    NSLog(@"%ld", self.taskNumberInArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[EditTaskViewController class]]){
        EditTaskViewController *nextVC = segue.destinationViewController;
        nextVC.didComeFromTaskInfoVC = true;
        nextVC.task = self.task;
        nextVC.delegate = self;
    }
    else {
        NSLog(@"change");
    }
}

#pragma mark- Helper Methods

- (NSString *) convertTaskForTextView {
    NSString *textForTextView = [NSString stringWithString:self.task.title];
    
    if (self.task.dueDate){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd, yyyy"];
        NSString *stringWithDate = [NSString stringWithFormat:@"\n\n%@", [formatter stringFromDate:self.task.dueDate]];
        textForTextView = [textForTextView stringByAppendingString:stringWithDate];
    }
    
    if (self.task.notes){
        NSString *stringWithNotes = [NSString stringWithFormat:@"\n\n%@", self.task.notes];
        textForTextView = [textForTextView stringByAppendingString:stringWithNotes];
    }
    
    return textForTextView;
}

#pragma mark - EditTaskViewControllerDelegate Methods

- (void) userDidCreateANewTask:(NSString *)title :(NSDate *)date :(NSString *)notes :(BOOL)completed {
    Task *newTask = [[Task alloc] initWith:title :date :notes :completed];
    self.task = newTask;
    self.textView.text = [self convertTaskForTextView];
    
    // save it to user defaults
    // this is all for permanent storage
    NSMutableArray *arrayOfTasksAsDictionaries = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS_ARRAY_KEY_FOR_NSSTANDUSERSDEFAULTS] mutableCopy];

    [arrayOfTasksAsDictionaries replaceObjectAtIndex:self.taskNumberInArray withObject:[newTask transformSelfIntoDictionary]];
    [[NSUserDefaults standardUserDefaults]  setObject:arrayOfTasksAsDictionaries forKey:TASKS_ARRAY_KEY_FOR_NSSTANDUSERSDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
