//
//  TWPTweetMediaCellRep.m
//  Twipoker
//
//  Created by Tong G. on 7/21/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import "TWPTweetMediaCellRep.h"

#import "TWPTweetTextView.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPTweetOperationsPanelView.h"
#import "TWPDateIndicatorView.h"
#import "TWPTweetMediaWell.h"

@implementation TWPTweetMediaCellRep

#pragma mark Height
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    [ super setTweet: _Tweet ];

    [ self.tweetMediaWell setTweet: _Tweet ];
    }

// Overrides
- ( CGFloat ) heightWithTweetTextBlockHeight: ( CGFloat )_TweetTextBlockHeight
    {
    CGFloat constraintHeight0 = self.userNameLabelTop_equal_cellViewTop_constraint.constant;
    CGFloat constraintHeight1 = self.tweetTextViewTop_equal_userNameLabelBottom_constraint.constant;
    CGFloat constraintHeight2 = self.tweetMediaWellTop_equal_tweetTextViewBottom_constraint.constant;
    CGFloat constraintHeight3 = self.tweetOperationsPanelViewTop_equal_dateIndicatorBottom_constraint.constant;
    CGFloat constraintHeight4 = self.cellViewBottom_equal_tweetOperationsPanelView_constraint.constant;
    CGFloat constraintHeight5 = self.dateIndicatorViewTop_equal_tweetMediaWellBottom_constraint.constant;

    CGFloat tweetTextViewHeight = ( _TweetTextBlockHeight > [ TWPTweetTextView defaultSize ].height ) ? _TweetTextBlockHeight : [ TWPTweetTextView defaultSize ].height;
    CGFloat userNameLabelHeight = NSHeight( self.userNameLabel.frame );
    CGFloat dateIndicatorHeight = NSHeight( self.dateIndicatorView.frame );
    CGFloat tweetOperationsPanelViewHeight = NSHeight( self.tweetOperationsPanelView.frame );
    CGFloat tweetMediaWellHeight = NSHeight( self.tweetMediaWell.frame );
    NSLog( @"%g", tweetMediaWellHeight );

    return constraintHeight0 + constraintHeight1 + constraintHeight2 + constraintHeight3 + constraintHeight4 + constraintHeight5
                + tweetTextViewHeight + userNameLabelHeight + dateIndicatorHeight + tweetOperationsPanelViewHeight + tweetMediaWellHeight;
    }

@end
