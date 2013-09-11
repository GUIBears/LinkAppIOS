//
//  ViewController.h
//  linkApp
//
//  Created by Ryan Mord on 3/14/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "TimesTableViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) FMResultSet* results;
@property (strong, nonatomic) NSMutableArray* times;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITableView *timesTable;

@property (strong, nonatomic) IBOutlet UILabel *nextBus;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIView *shadowContainer;

- (IBAction)doScroll:(id)sender;
- (IBAction)dissmissView:(id)sender;

@end
