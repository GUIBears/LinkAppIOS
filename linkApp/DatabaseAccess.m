//
//  DatabaseAccess.m
//  linkApp
//
//  Created by Bernard Ferguson on 4/25/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import "DatabaseAccess.h"
#import "Time.h"

@implementation DatabaseAccess

+ (FMDatabase*)setUp{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"bustimes.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    return db;
    
}

+(NSMutableArray*) getTimesbyLocation: (NSString*) location {
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

+(FMResultSet*) getTimesbyLocationQuery:(NSString*) location{
    FMDatabase* db= [self setUp];
    [db open];
    FMResultSet* results= [db executeQueryWithFormat:@"select * from BusTimes where place = (%@)", location];
    return results;
}

+(NSMutableArray*) getTimesForTableByLocation:(NSString*)location{
    NSMutableArray* allTimes= [[NSMutableArray alloc]init];
    
    NSMutableArray* sunday = [[NSMutableArray alloc]init];
    NSMutableArray* monday = [[NSMutableArray alloc]init];
    NSMutableArray* tuesday = [[NSMutableArray alloc]init];
    NSMutableArray* wednesday = [[NSMutableArray alloc]init];
    NSMutableArray* thursday = [[NSMutableArray alloc]init];
    NSMutableArray* friday = [[NSMutableArray alloc]init];
    NSMutableArray* saturday = [[NSMutableArray alloc]init];
    
    FMDatabase* db= [self setUp];
    [db open];
    FMResultSet* results= [db executeQueryWithFormat:@"select * from BusTimes where place = (%@)", location];
    while([results next]){
        NSString* day = [results stringForColumn:@"day"];
        NSMutableArray* currentDay;
        
        
        if([self thisString:day hasString:@"S"] != -1) {
            currentDay = sunday;
            Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];

        }
        if([self thisString:day hasString:@"M"] != -1) {
            currentDay = monday;
            Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];
        }
        if([self thisString:day hasString:@"T"] != -1){
            currentDay = tuesday;
            Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];
        }
        if([self thisString:day hasString:@"W"] != -1){
            currentDay = wednesday;
            Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];
        }
        if([self thisString:day hasString:@"R"] != -1){
            currentDay = thursday;
            Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];
        }
        if([self thisString:day hasString:@"F"] != -1){
            currentDay = friday;
            Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];
        }
        if([self thisString:day hasString:@"Y"] != -1){
            currentDay = saturday; Time* currentTime = [[Time alloc]initWithTime:[results stringForColumn:@"time"] andM:[results stringForColumn:@"m"]];
            [currentDay addObject:currentTime];
        }
        
    }
    [allTimes addObject:sunday];
    [allTimes addObject:monday];
    [allTimes addObject:tuesday];
    [allTimes addObject:wednesday];
    [allTimes addObject:thursday];
    [allTimes addObject:friday];
    [allTimes addObject:saturday];
    
    return allTimes;
}
+(int)thisString:(NSString*)mainString hasString:(NSString*)subString{
   
    NSRange range=[mainString rangeOfString:subString];
    if(range.location == NSNotFound){
            return -1;
    }
    else{
        return range.location;
    }
}



@end
