//
//  TWPTweetMediaCellRep.h
//  Twipoker
//
//  Created by Tong G. on 7/21/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import "TWPTweetCellRep.h"

@class TWPTweetMediaWell;

@interface TWPTweetMediaCellRep : TWPTweetCellRep

@property ( weak ) IBOutlet TWPTweetMediaWell* tweetMediaWell;

@property ( weak ) IBOutlet NSLayoutConstraint* tweetMediaWellTop_equal_tweetTextViewBottom_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* dateIndicatorViewTop_equal_tweetMediaWellBottom_constraint;

@end
