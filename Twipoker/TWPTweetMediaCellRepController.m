//
//  TWPTweetMediaCellRepController.m
//  Twipoker
//
//  Created by Tong G. on 7/21/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import "TWPTweetMediaCellRepController.h"

@interface TWPTweetMediaCellRepController ()

@end

@implementation TWPTweetMediaCellRepController

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super initWithNibName: @"TWPTweetMediaCellRep" bundle: [ NSBundle mainBundle ] ] )
        ;

    return self;
    }

@end
