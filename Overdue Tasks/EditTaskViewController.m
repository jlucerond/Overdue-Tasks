//
//  EditTaskViewController.m
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *taskNameTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDueDateDP;
@property (weak, nonatomic) IBOutlet UITextView *taskNotesTV;


@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.taskNameTF.delegate = self;
    self.taskNotesTV.delegate = self;
    
    if (self.didComeFromTaskInfoVC){
        self.taskNameTF.text = self.task.title;
        self.taskDueDateDP.date = self.task.dueDate;
        self.taskNotesTV.text = self.task.notes;
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma  mark- UIButtons Pushed

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    [self.delegate userDidCreateANewTask:self.taskNameTF.text :self.taskDueDateDP.date :self.taskNotesTV.text :self.task.completed];
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - TextView & TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [self dismissKeyboard];
        //[self.taskNotesTV resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) dismissKeyboard {
    [self.taskNameTF resignFirstResponder];
    [self.taskNotesTV resignFirstResponder];
}


@end
