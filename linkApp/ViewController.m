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

@end
