//
//  ViewController.m
//  linkApp
//
//  Created by Ryan Mord on 3/14/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import "ViewController.h"
#import "TimesTableViewController.h"
#import "Time.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize results, times, timesTable;
NSDate* selectedTime=nil;
NSString* alertButtonText= @"Set Alert";
bool pm=false, am=false;
UIFont* font;
UIColor* cellTextColor;
NSRange range;


- (void)viewDidLoad
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [super viewDidLoad];
    self.times=[DatabaseAccess getTimesForTableByLocation:[self.label.text lowercaseString]];
    self.timesTable.backgroundView = nil;
    self.timesTable.backgroundColor = [UIColor clearColor];
    self.timesTable.separatorColor = [UIColor whiteColor];
    font = [UIFont fontWithName:@"Avenir Next" size:20];
    [self.timesTable setRowHeight:30];
    self.backButton.backgroundColor=
    self.nextBus.backgroundColor=[UIColor colorWithRed:0.5 green:0.71 blue:0.71 alpha:1.0];
    [self.nextBusField setEnabled:false];
    [self.shadowContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.shadowContainer.layer setShadowOffset:CGSizeMake(2.0f,0.0f)];
    [self.shadowContainer.layer setShadowOpacity:(1.0f)];
    self.shadowContainer.clipsToBounds= NO;
    self.shadowContainer.layer.masksToBounds = NO;
   self.shadowContainer.layer.shadowRadius = 7.0f;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollToNextTime];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.times objectAtIndex:section] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* currentDay = @"";
    switch (section) {
        case 0:
            currentDay = @"Sunday";
            break;
        case 1:
            currentDay = @"Monday";
            break;
        case 2:
            currentDay = @"Tuesday";
            break;
        case 3:
            currentDay = @"Wednesday";
            break;
        case 4:
            currentDay = @"Thursday";
            break;
        case 5:
            currentDay = @"Friday";
            break;
        case 6:
            currentDay = @"Saturday";
            break;
    }
    return currentDay;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger day = [indexPath section];
    NSInteger currentTime = [indexPath row];
    Time* cTime = [[times objectAtIndex:day]objectAtIndex:currentTime];
    cell.backgroundColor=cTime.color;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    NSInteger day = [indexPath section];
    NSInteger currentTime = [indexPath row];
    Time* cTime = [[times objectAtIndex:day]objectAtIndex:currentTime];
  
    cellTextColor = [UIColor whiteColor];
    cell.textLabel.font = font;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString* cellText = cTime.timeString;
    if([cTime.m isEqualToString:@"am"]){
        cellText =[cellText stringByAppendingString:@" am"];
    }
    if([cTime.m isEqualToString:@"pm"]){
        cellText =[cellText stringByAppendingString:@" pm"];
    }
    cell.textLabel.text=cellText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Time* curTime=[[times objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] ];
    NSCalendar * calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* timeComp = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:curTime.time];
    NSInteger dayNumber = [indexPath section];
    dayNumber = dayNumber+1;
    int today = [self getDayNumber];
    int dayDifference = 0;
    if(today != dayNumber){
        if(today<dayNumber){
            dayDifference = dayNumber -today;
        }
        if(today>dayNumber){
            dayDifference = (7 - today) + dayNumber;
        }
    }
    NSDateComponents* finalTimeComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [finalTimeComp setHour:timeComp.hour];
    [finalTimeComp setMinute:timeComp.minute];
    
    selectedTime = [calendar dateFromComponents:finalTimeComp];
    selectedTime = [selectedTime dateByAddingTimeInterval:dayDifference*24*60*60];
    
    //subtract 5 minutes from time
    selectedTime = [selectedTime dateByAddingTimeInterval:-(5*60)];
    
    NSString* alertText = @"Set Alert for 5 minutes before ";
    alertText = [alertText stringByAppendingString:curTime.timeString];
    alertText = [alertText stringByAppendingString:curTime.m];
    alertText = [alertText stringByAppendingString:@" on "];
    NSString* selectedDay = [self tableView:tableView titleForHeaderInSection:[indexPath section]];
    alertText = [alertText stringByAppendingString:selectedDay];
    alertText = [alertText stringByAppendingString:@"?"];
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:alertText delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:alertButtonText, nil];
    [sheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:alertButtonText] ){
        [self createnotification];
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    selectedTime=nil;
}

-(void)createnotification
{
    if(selectedTime){
        UILocalNotification* notification = [[UILocalNotification alloc] init];
        
        if (notification)
        {
        notification.fireDate = selectedTime;
        notification.timeZone = [NSTimeZone localTimeZone];
        NSString* alertBody = @"The Link leaves ";
        alertBody = [alertBody stringByAppendingString:self.label.text];
        alertBody = [alertBody stringByAppendingString:@" in 5 minutes"];
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"T!",nil)];
        notification.alertAction = NSLocalizedString(@"View Details", nil);
        notification.repeatInterval = 0;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        selectedTime=nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Notification created"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
    }
    }
    
}

-(int)getDayNumber{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    return weekday;
}

-(void)scrollToNextTime{
    int today = [self getDayNumber]-1;
    int nextBusIndex = 0;
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSMutableArray* todaysTimes = [self.times objectAtIndex:today];
    
    ///get only hour and minute from current time on device
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate* timeNow = [calendar dateFromComponents:components ];
    bool found=false;
    NSDate* curTime;
    for(int i=0;i<[todaysTimes count];i++){
        Time* thisTime = [todaysTimes objectAtIndex:i];
        components = [calendar components:flags fromDate:thisTime.time];
        curTime = [calendar dateFromComponents:components];
        
        //forCommenting
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm"];
        components = [calendar components:flags fromDate:timeNow];
        NSLog(@" scroll to %@",[formatter stringFromDate:curTime]);
        if([timeNow compare:curTime]==NSOrderedAscending){
            nextBusIndex = i;
            [self.nextBus setText:[self.nextBus.text stringByAppendingString:thisTime.timeString]];
            found=true;
            break;
        }
    }
    if(!found){
        today= [self increaseDay:today];
    }
    
    NSIndexPath* scrollTo = [NSIndexPath indexPathForRow:nextBusIndex inSection:today];
    [self.timesTable scrollToRowAtIndexPath:scrollTo atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(void)application:(UIApplication *)application didRecieveLocalnotification:(UILocalNotification *)notification
{
    NSLog(@"Notification Received");
}
-(int)increaseDay:(int)dayNumber{
    int newDayNumber;
    if(dayNumber==6){
        newDayNumber=0;
    }
    else{
        newDayNumber= dayNumber+1;
    }
    return newDayNumber;
}
-(int)decreaseDay:(int)dayNumber{
    int newDayNumber;
    if(dayNumber==0){
        newDayNumber=6;
    }
    else{
        newDayNumber = dayNumber -1;
    }
    return newDayNumber;
}

- (IBAction)doScroll:(id)sender {
    [self scrollToNextTime];
}

- (IBAction)dissmissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
