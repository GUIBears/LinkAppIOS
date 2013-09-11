//
//  Time.m
//  linkApp
//
//  Created by Bernard Ferguson on 8/3/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import "Time.h"

//this is the time object. it stores a date, string, whether am or pm and a color.

@implementation Time
@synthesize timeString, m, time, color;

-(Time*)initWithTime:(NSString*)_timeString andM:(NSString*)_m{
    //initialize with the parameters passed in. take the time string and create an actual iOS time object (NSDate object)
    self = [super init];
    self.m=_m;
    self.color=[UIColor colorWithRed:0.5 green:0.71 blue:0.71 alpha:1.0];
    self.timeString = _timeString;
    [self convertTimeString];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"hh:mm"];
    self.time = [df dateFromString:self.timeString];
    if([self.m isEqualToString:@"pm"]){
        NSTimeInterval twelveHours = 12*60*60;
        self.time = [self.time dateByAddingTimeInterval:twelveHours];
    }
    return self;
}


-(void)convertTimeString{
    //if there is a * in front of the time, that means its the first bus. if its a # that means its the last bus
    NSRange range;
    range=[timeString rangeOfString:@"*"];
    if(range.location != NSNotFound){
       // NSLog(@"*");
        timeString =[timeString substringFromIndex:1];
        color= [UIColor colorWithRed:0.5 green:0.91 blue:0.81 alpha:1.0];
    }
    else{
        range=[timeString rangeOfString:@"#"];
        if(range.location != NSNotFound){
           // NSLog(@"#");
            timeString =[timeString substringFromIndex:1];
            color = [UIColor colorWithRed:0.9 green:0.2 blue:0.2 alpha:1.0];
        }
    }

}
@end
