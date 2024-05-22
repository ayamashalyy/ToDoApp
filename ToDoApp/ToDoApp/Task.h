//
//  Task.h
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding>
@property NSString *title;
@property NSString *desc;
@property int priority;
@property int status;
@property NSDate *date;

@end

NS_ASSUME_NONNULL_END
