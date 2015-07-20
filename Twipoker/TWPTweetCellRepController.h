//
//  TWPTweetCellRepController.h
//  Twipoker
//
//  Created by Tong G. on 7/20/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

@import Cocoa;

#import "TWPTweetCellRep.h"

@interface TWPTweetCellRepController : NSViewController

@property ( strong, readwrite ) OTCTweet* tweet;
@property ( strong, readonly ) TWPTweetCellRep* rep;

#pragma mark Initializations
+ ( instancetype ) repControllerWithTweet: ( OTCTweet* )_Tweet;
- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet;

@end
