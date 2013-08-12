//
//  TimesTableViewController.h
//  linkApp
//
//  Created by Bernard Ferguson on 8/3/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimesTableViewController : UITableViewController
@property (nonatomic,retain) NSString* location;
@property (nonatomic, retain) NSMutableArray *times;
-(id)initWithLocation:(NSString*)location;
@end
