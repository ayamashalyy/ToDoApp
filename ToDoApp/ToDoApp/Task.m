//
//  Task.m
//  ToDoApp
//
//  Created by aya on 21/04/2024.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.desc = [coder decodeObjectForKey:@"desc"];
        self.priority = [coder decodeIntForKey:@"priority"];
        self.status = [coder decodeIntForKey:@"status"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeInt:self.priority forKey:@"priority"];
    [coder encodeInt:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
}

@end
