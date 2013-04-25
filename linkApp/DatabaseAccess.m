//
//  DatabaseAccess.m
//  linkApp
//
//  Created by Bernard Ferguson on 4/25/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import "DatabaseAccess.h"

@implementation DatabaseAccess

+ (FMDatabase*)setUp{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"bustimes.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    return db;
    
}

+(NSMutableArray*) getTimesbyLocation: (NSString*) location{
    NSMutableArray *times = [[NSMutableArray alloc] init];
    FMDatabase* db= [self setUp];
    [db open];
    FMResultSet* results= [db executeQueryWithFormat:@"select time from BusTimes where place = (%@)", location];
   
    
    while([results next]){
        [times addObject:[results stringForColumn:@"time"]];
        NSLog(@"%@", [results stringForColumn:@"time"]);
    }
   
    
    return times;
}

@end
