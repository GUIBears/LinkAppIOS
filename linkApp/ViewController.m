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
NSString* alertButtonText= @"Set Alert"; //text to be use for pop up
bool pm=false, am=false; //whether it's currently am or pm
UIFont* font; //font used
UIColor* cellTextColor; //color of text
NSRange range; //used for string comparison


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the notification number on app to 0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //get database times based on the title label of the view selected
    /*the returned times are set up as a 2d array. The first entry in the array is another array of times that represent times for sunday. the second entry in the array is another array of times that represent monday. and so forth. 
     
        thus the entries at index 0,1,2,3,4,5,6 of the array are all arrays of sunday,monday,tuesday,wednesday,thursday,friday,saturday all respectively.
     */
    
    self.times=[DatabaseAccess getTimesForTableByLocation:[self.label.text lowercaseString]];
    //set the table of times
    self.timesTable.backgroundView = nil;
    self.timesTable.backgroundColor = [UIColor clearColor];
    self.timesTable.separatorColor = [UIColor whiteColor];
    
    [self.timesTable setRowHeight:30];
    self.backButton.backgroundColor=
    self.nextBus.backgroundColor=[UIColor colorWithRed:0.5 green:0.71 blue:0.71 alpha:1.0];
  //  [self.nextBusField setEnabled:false];
    
    //create a shadow for the table view 
    [self.shadowContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.shadowContainer.layer setShadowOffset:CGSizeMake(2.0f,0.0f)];
    [self.shadowContainer.layer setShadowOpacity:(1.0f)];
    self.shadowContainer.clipsToBounds= NO;
    self.shadowContainer.layer.masksToBounds = NO;
   self.shadowContainer.layer.shadowRadius = 7.0f;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //scroll to the next time as soon as the view opens.
    [self scrollToNextTime];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   //number of different sections in the table, i.e. days of the week
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   //number of the amount of rows (i. e. times) for each section ( i. e. day)
    return [[self.times objectAtIndex:section] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //set up the alphabet on the right of the table to allow quick scrolling
    return [[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //also sets up the alphabet on the right of the table to allow quick scrolling
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //set up titles in table, which correspond to each day. 0 is sunday and 6 is saturday.
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
    //change background color on cell (for first and last buses) 
    NSInteger day = [indexPath section];
    NSInteger currentTime = [indexPath row];
    Time* cTime = [[times objectAtIndex:day]objectAtIndex:currentTime];
    cell.backgroundColor=cTime.bgColor;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Takes the list of objects in self.times and returns a cell for the table.
    
    //find a used cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    //get the selected day index
    NSInteger day = [indexPath section];
    
    //get selected time index
    NSInteger currentTime = [indexPath row];
    
    //get the proper time that corresponds to the selected entry from the array of times in self.times
    Time* cTime = [[times objectAtIndex:day]objectAtIndex:currentTime];
  
    //set the cell font and text color
    cellTextColor = [UIColor whiteColor];
    font = [UIFont fontWithName:@"Avenir Next" size:20];
  
    cell.textLabel.font = font;
    cell.textLabel.textColor =  cTime.textColor;
   
    //add on am or pm
    NSString* cellText = cTime.timeString;
    if([cTime.m isEqualToString:@"am"]){
        cellText =[cellText stringByAppendingString:@" am"];
    }
    if([cTime.m isEqualToString:@"pm"]){
        cellText =[cellText stringByAppendingString:@" pm"];
    }
    if(cTime.classBus ==true){
        cellText = [cellText stringByAppendingString:@"*"];
    }
    cell.textLabel.text=cellText;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //get the current time selected
    Time* curTime=[[times objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] ];
    
    //create a calendar object to get current day number on the calendar of the iPhone
    NSCalendar * calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* timeComp = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:curTime.time];
    NSInteger dayNumber = [indexPath section];
    dayNumber = dayNumber+1;
    
    //if today isnt the selected day, do math to figure out how far in the future it is. 
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
    //create a new time that includes the proper day difference. that is, if its, saturday(day 6) and monday is selecte(day 1), make sure the alert is set 2 days in the future
    NSDateComponents* finalTimeComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [finalTimeComp setHour:timeComp.hour];
    [finalTimeComp setMinute:timeComp.minute];
    
    selectedTime = [calendar dateFromComponents:finalTimeComp];
    selectedTime = [selectedTime dateByAddingTimeInterval:dayDifference*24*60*60];
    
    //subtract 5 minutes from time
    selectedTime = [selectedTime dateByAddingTimeInterval:-(5*60)];
    
    //create alert text
    NSString* alertText = @"Set Alert for 5 minutes before ";
    alertText = [alertText stringByAppendingString:curTime.timeString];
    alertText = [alertText stringByAppendingString:curTime.m];
    alertText = [alertText stringByAppendingString:@" on "];
    NSString* selectedDay = [self tableView:tableView titleForHeaderInSection:[indexPath section]];
    alertText = [alertText stringByAppendingString:selectedDay];
    alertText = [alertText stringByAppendingString:@"?"];
    
    //show alert
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:alertText delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:alertButtonText, nil];
    [sheet showInView:self.view];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   //if the user agrees, create the notification.
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
        //give the proper parameters to the notification
        if (notification)
        {
        notification.fireDate = selectedTime;
        notification.timeZone = [NSTimeZone localTimeZone];
        NSString* alertBody = @"The Link leaves ";
        alertBody = [alertBody stringByAppendingString:self.label.text];
        alertBody = [alertBody stringByAppendingString:@" in 5 minutes"];
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"View Details", nil);
            //do not repeat
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
    //find out what day number it is
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    return weekday;
}

-(void)scrollToNextTime{
    //scroll to the next bus
    //get today's number
    int today = [self getDayNumber]-1;
    int nextBusIndex = 0;
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    //get the list of times for the current day
    NSMutableArray* todaysTimes = [self.times objectAtIndex:today];
    
    ///get only hour and minute from current time on device
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate* timeNow = [calendar dateFromComponents:components ];
    bool found=false;
    NSDate* curTime;
    for(int i=0;i<[todaysTimes count];i++){
        //loop through the times for today and find which time is next
        Time* thisTime = [todaysTimes objectAtIndex:i];
        components = [calendar components:flags fromDate:thisTime.time];
        curTime = [calendar dateFromComponents:components];
     
        //if the time being compared is greater than the time on the device, then thats the new time
        if([timeNow compare:curTime]==NSOrderedAscending){
            nextBusIndex = i;
            NSString* nextBusString=thisTime.timeString;
            nextBusString = [nextBusString stringByAppendingString:thisTime.m];
            
            [self.nextBus setText:[self.nextBus.text stringByAppendingString:nextBusString]];
            found=true;
            break;
        }
    }
    //if no time was found, then increase the day number. this has not been used yet.
    if(!found){
        today= [self increaseDay:today];
    }
    
    //scroll table to the next found time
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
