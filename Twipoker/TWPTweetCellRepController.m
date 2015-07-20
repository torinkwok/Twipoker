//
//  TWPTweetCellRepController.m
//  Twipoker
//
//  Created by Tong G. on 7/20/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import "TWPTweetCellRepController.h"

@interface TWPTweetCellRepController ()

@end

@implementation TWPTweetCellRepController

@dynamic tweet;
@dynamic rep;

#pragma mark Dynamic Accessors
- ( OTCTweet* ) tweet
    {
    return [ self rep ].tweet;
    }

- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    [ [ self rep ] setTweet: _Tweet ];
    }

- ( TWPTweetCellRep* ) rep
    {
    return ( TWPTweetCellRep* )( self.view );
    }

#pragma mark Initializations
+ ( instancetype ) repControllerWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super initWithNibName: @"TWPTweetClearCellRep" bundle: [ NSBundle mainBundle ] ] )
        ;

    return self;
    }

@end
