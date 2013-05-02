//
//  DatabaseAccess.h
//  linkApp
//
//  Created by Bernard Ferguson on 4/25/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface DatabaseAccess : NSObject

+(NSMutableArray*) getTimesbyLocation: (NSString*) location;
@end
