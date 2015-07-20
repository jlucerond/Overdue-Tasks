//
//  TaskInfoViewController.h
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskInfoViewController : UIViewController

@property (strong, nonatomic) Task *task;
//@property (nonatomic) BOOL shouldImmediatelyGoToEditScreen;
@property (nonatomic) NSUInteger taskNumberInArray;

@end

