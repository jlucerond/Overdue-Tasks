//
//  Task.m
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//

#import "Task.h"
#import "PrefixHeader.pch"

@implementation Task

- (instancetype)init {
    return [self initWith:nil :nil :nil :false];
}

- (instancetype) initWith :(NSString *) title :(NSDate *) date : (NSString *) notes : (BOOL) completed {
    self.title = title;
    self.dueDate = date;
    self.notes = notes;
    self.completed = completed;
    return self;
}

- (NSDictionary *) transformSelfIntoDictionary {
    NSMutableDictionary *taskAsDictionary = [[NSMutableDictionary alloc] init];
    [taskAsDictionary setObject:self.title forKey:TASK_TITLE];
    [taskAsDictionary setObject:self.dueDate forKey:TASK_DUEDATE];
    [taskAsDictionary setObject:self.notes forKey:TASK_NOTES];
    [taskAsDictionary setObject:[self turnBoolIntoString] forKey:TASK_COMPLETED];
    return taskAsDictionary;
}

- (NSString *) turnBoolIntoString {
    if (self.completed) return @"1";
    else return @"0";
}


@end
