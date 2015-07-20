//
//  Task.h
//  Overdue Tasks
//
//  Created by Joe Lucero on 7/16/15.
//  Copyright (c) 2015 Joe Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *dueDate;
@property (strong, nonatomic) NSString *notes;
@property (nonatomic) BOOL completed;

// I need two methods here, one to turn a task into a property list and from a property list

- (NSDictionary *) transformSelfIntoDictionary;
- (instancetype) initWith :(NSString *) title :(NSDate *) date : (NSString *) notes : (BOOL) completed;

@end
