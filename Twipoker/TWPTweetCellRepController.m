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

#pragma mark Dynamic Accessors
- ( TWPTweetCellRep* ) rep
    {
    __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD_;
    return nil;
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
