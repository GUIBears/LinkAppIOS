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
@synthesize timeString, m, time, textColor, bgColor, classBus;

-(Time*)initWithTime:(NSString*)_timeString andM:(NSString*)_m{
    
    //initialize with the parameters passed in. take the time string and create an actual iOS time object (NSDate object)
    self = [super init];
    self.m=_m;
    //original bg color
    self.bgColor=[UIColor colorWithRed:0.5 green:0.71 blue:0.71 alpha:1.0];
    self.textColor=[UIColor whiteColor];
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
    UIColor *green = [UIColor colorWithRed:72.0f/255.0f green:141.0f/255.0f blue:151.0f/255.0f alpha:1.0];
    UIColor *red = [UIColor colorWithRed:216.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
    //if there is a * in front of the time, that means its the first bus. if its a # that means its the last bus
    if([timeString rangeOfString:@"*" ].location != NSNotFound){
       // NSLog(@"*");
        timeString =[timeString substringFromIndex:1];
        self.bgColor=green ;
        classBus = true;//  textColor=  [UIColor colorWithRed:0.01 green:0.1 blue:0.8 alpha:1.0];
       // textColor = [UIColor redColor];
        
    }
    else if([timeString rangeOfString:@"#" ].location != NSNotFound){
       
           // NSLog(@"#");
            timeString =[timeString substringFromIndex:1];
        self.bgColor=red;
        classBus = true;
       // textColor = [UIColor redColor];

         //   textColor=[UIColor blackColor];
    }

    else if([timeString rangeOfString:@"&" ].location != NSNotFound){
    
    // NSLog(@"#");
    timeString =[timeString substringFromIndex:1];
   // textColor=  [UIColor colorWithRed:0.3 green:0.9 blue:0.3 alpha:1.0];
        self.bgColor=green;
    }
    else if ([timeString rangeOfString:@"%" ].location != NSNotFound){
    
        // NSLog(@"#");
        timeString =[timeString substringFromIndex:1];
        self.bgColor=red;
     //   textColor=[UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1.0];
    }
}

@end
