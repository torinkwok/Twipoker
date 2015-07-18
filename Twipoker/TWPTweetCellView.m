/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Guo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TWPTweetCellView.h"
#import "TWPTweetTextView.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPTweetOperationsPanelView.h"
#import "TWPDateIndicatorView.h"
#import "TWPSharedUIElements.h"
#import "TWPTweetMediaWell.h"

// Notification Names
NSString* const TWPTweetCellViewShouldDisplayDetailOfTweet = @"TweetCellView.Notif.ShouldDisplayDetailOfTweet";

// User Info Keys
NSString* const TWPTweetCellViewTweetUserInfoKey = @"TweetCellView.UserInfoKey.Tweet";

// Private Interfaces
@interface TWPTweetCellView ()

@property ( assign, readwrite, setter = setShowingTweetOperationsPanel: ) BOOL isShowingTweetOperationsPanel;
- ( void ) _postNotifForShowingUserProfile;

@end // Private Interfaces

// TWPTweetCellView class
@implementation TWPTweetCellView

@synthesize authorAvatarWell;
@synthesize userNameLabel;
@synthesize dateIndicatorView;
@synthesize tweetTextView;

@dynamic tweet;
@dynamic author;

#pragma mark Initialization
+ ( instancetype ) tweetCellViewWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super init ] )
        [ self setTweet: _Tweet ];

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;

    [ [ self authorAvatarWell ] setTwitterUser: self->_tweet.author ];
    [ [ self userNameLabel ] setTwitterUser: self->_tweet.author ];
    [ [ self tweetTextView ] setTweet: self->_tweet ];
    [ [ self dateIndicatorView ] setTweet: self->_tweet ];
    [ [ self tweetOperationsPanelView ] setTweet: self->_tweet ];

    if ( _Tweet.media )
        {
        if ( self->_tweetMediaWell )
            self->_tweetMediaWell = [ TWPTweetMediaWell tweetMediaWellWithTweet: _Tweet ];
        else
            self->_tweetMediaWell.tweet = _Tweet;
        }

    self.isShowingTweetOperationsPanel = NO;
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

- ( OTCTwitterUser* ) author
    {
    return self.tweet.author;
    }

- ( CGFloat ) dynamicHeightAccordingToTweetTextBlockHeight: ( CGFloat )_TweetTextBlockHeight
    {
    CGFloat height0 = self.userNameLabelTop_equal_cellViewTop_constraint.constant;
    CGFloat height1 = self.tweetTextViewTop_equal_userNameLabelBottom_constraint.constant;
    CGFloat height2 = self.dateIndicatorTop_equal_tweetTextViewBottom_constraint.constant;
    CGFloat height3 = self.tweetOperationsPanelViewTop_equal_dateIndicatorBottom_constraint.constant;
    CGFloat height4 = self.cellViewBottom_equal_tweetOperationsPanelView_constraint.constant;

    CGFloat tweetTextViewHeight = ( _TweetTextBlockHeight > [ TWPTweetTextView defaultSize ].height ) ? _TweetTextBlockHeight : [ TWPTweetTextView defaultSize ].height;
    CGFloat userNameLabelHeight = NSHeight( self.userNameLabel.frame );
    CGFloat dateIndicatorHeight = NSHeight( self.dateIndicatorView.frame );
    CGFloat tweetOperationsPanelViewHeight = NSHeight( self.tweetOperationsPanelView.frame );

    return height0 + height1 + height2 + height3 + height4
                + tweetTextViewHeight + userNameLabelHeight + dateIndicatorHeight + tweetOperationsPanelViewHeight;
    }

#pragma mark IBAction
- ( IBAction ) userNameLabelClickedAction: ( id )_Sender
    {
    [ self _postNotifForShowingUserProfile ];
    }

- ( IBAction ) userAvatarClickedAction: ( id )_Sender
    {
    [ self _postNotifForShowingUserProfile ];
    }

#pragma mark Private Interfaces
- ( void ) _postNotifForShowingUserProfile
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldShowUserProfile
                                                           object: self
                                                         userInfo: @{ kTwitterUser : self.author } ];
    }

@end // TWPTweetCellView class

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/