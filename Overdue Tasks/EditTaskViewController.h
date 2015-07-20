//
//  EditTaskViewController.h
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol EditTaskViewControllerDelegate <NSObject>

@required

- (void) userDidCreateANewTask :(NSString *) title :(NSDate *) date : (NSString *) notes : (BOOL) completed;

@end

@interface EditTaskViewController : UIViewController

@property (weak, nonatomic) id <EditTaskViewControllerDelegate> delegate;
@property (nonatomic) BOOL didComeFromTaskInfoVC;
@property (weak, nonatomic) Task *task;

@end
