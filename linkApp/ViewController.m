//
//  ViewController.m
//  linkApp
//
//  Created by Ryan Mord on 3/14/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseAccess.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *location = [self.label.text lowercaseString];
    self.times = [DatabaseAccess getTimesbyLocation:location];
    NSLog(location);
    int y = 50;
    
    for(int i =0;i<[self.times count];i++){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.times objectAtIndex:i] forState:UIControlStateNormal];
         button.frame     = CGRectMake(30, y, 100,25  );
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(createnotification:)];
        
        [button addGestureRecognizer:tap];
        [ self.scrollView addSubview:button];
        y+= 50;
        self.scrollView.contentSize = CGSizeMake(200, y);

    }
    	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createnotification:(UIGestureRecognizer*)gestureRecognizer  //call this function to produce a local notification even if your app is running in background.

{
    NSString *dateandtime = @"17:24";//((UIButton*)gestureRecognizer.view).titleLabel.text;
    NSLog(@"%@", dateandtime);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm"];
    
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-18000]];
    
    NSDate *alerttime = [formatter dateFromString:dateandtime];
    
    UIApplication * app = [UIApplication sharedApplication];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (notification)
        
    {
        
        notification.fireDate = alerttime;
        
        //notification.timeZone = [NSTimeZone defaultTimeZone];
        
        notification.repeatInterval = 0;
        
       // notification.alertBody = message;
        
        [app scheduleLocalNotification:notification];
        
        [app presentLocalNotificationNow:notification];
        NSLog(@"SET");
        
    }
    
}

//the notifications will go to the function given below if your app is running in forground

-(void)application:(UIApplication *)application didRecieveLocalnotification:(UILocalNotification *)notification

{
    
    NSLog(@"Notification Received");
    
}
@end
