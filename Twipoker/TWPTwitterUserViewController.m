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

#import "TWPTwitterUserViewController.h"
#import "TWPTwitterUserView.h"
#import "TWPLoginUsersManager.h"

@implementation TWPTwitterUserViewController

@synthesize twitterUser = _twitterUser;

@dynamic twitterUserView;

- ( void ) setTwitterUserView: ( TWPTwitterUserView* )_TwitterUserView
    {
    [ self setView: _TwitterUserView ];
    }

- ( TWPTwitterUserView* ) twitterUserView
    {
    return ( TWPTwitterUserView* )self.view;
    }

#pragma mark Initialization
+ ( instancetype ) twitterUserViewControllerWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    if ( !_TwitterUser )
        return nil;

    if ( self = [ super initWithNibName: @"TWPTwitterUserView" bundle: [ NSBundle mainBundle ] ] )
        {
        self->_twitterUser = _TwitterUser;

        [ [ TWPBrain wiseBrain ] registerLimb: self forUserIDs: @[ _TwitterUser.IDString ] brainSignal: TWPBrainSignalTypeNewTweetMask | TWPBrainSignalTypeTweetDeletionMask ];

        [ self.twitterUserView setTwitterUser: _TwitterUser ];
        [ self.twitterAPI getUserTimelineWithScreenName: self.twitterUserView.twitterUser.screenName
                                                  count: self.numberOfTweetsWillBeLoadedOnce
                                           successBlock:
            ^( NSArray* _TweetObjects )
                {
                for ( NSDictionary* _TweetObject in _TweetObjects )
                    [ self->_data addObject: [ OTCTweet tweetWithJSON: _TweetObject ] ];

                self->_sinceID = [ ( OTCTweet* )self->_data.firstObject tweetID ];
                self->_maxID = [ ( OTCTweet* )self->_data.lastObject tweetID ];

                [ self.timelineTableView reloadData ];
                } errorBlock: ^( NSError* _Error )
                                {
                                [ self presentError: _Error ];
                                } ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do view setup here.
    }

- ( void ) dealloc
    {
//    [ [ TWPBrain wiseBrain ] removeLimb: self forUserID: self->_twitterUser.IDString brainSignal: TWPBrainSignalTypeNewTweetMask | TWPBrainSignalTypeTweetDeletionMask ];
    }

#pragma mark Conforms to <TWPTimelineScrollViewDelegate>
- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchOlderTweets: ( NSClipView* )_ClipView
    {
    if ( !self.isLoadingOlderTweets )
        {
        self.isLoadingOlderTweets = YES;
        NSLog( @"%s", __PRETTY_FUNCTION__ );

        [ self.twitterAPI getStatusesUserTimelineForUserID: self.twitterUserView.twitterUser.IDString
                                                screenName: nil
                                                   sinceID: nil
                                                     count: @( self.numberOfTweetsWillBeLoadedOnce ).stringValue
                                                     maxID: @( self->_maxID - 1 ).stringValue
                                                  trimUser: @NO
                                            excludeReplies: @0
                                        contributorDetails: @YES
                                           includeRetweets: @YES
                                              successBlock:
            ^( NSArray* _TweetObjects )
                {
                for ( NSDictionary* _TweetObject in _TweetObjects )
                    {
                    OTCTweet* tweet = [ OTCTweet tweetWithJSON: _TweetObject ];

                    // Duplicate tweet? Get out of here!
                    if ( ![ self->_data containsObject: tweet ] )
                        [ self->_data addObject: tweet ];
                    }

                self->_maxID = [ ( OTCTweet* )self->_data.lastObject tweetID ];
                [ self.timelineTableView reloadData ];

                // Data source did finish loading older tweets
                self.isLoadingOlderTweets = NO;
                } errorBlock: ^( NSError* _Error )
                                {
                                // Data source did finish loading older tweets due to the error occured
                                self.isLoadingOlderTweets = NO;
                                [ self presentError: _Error ];
                                } ];
        }
    }

#pragma mark Conforms to <TWPLimb> protocol
- ( void ) brain: ( TWPBrain* )_Brain didReceiveTweet: ( OTCTweet* )_Tweet
    {
    [ self->_data insertObject: _Tweet atIndex: 0 ];
    [ self.timelineTableView reloadData ];
    }

- ( void )            brain: ( TWPBrain* )_Brain
    didReceiveTweetDeletion: ( NSString* )_DeletedTweetID
                     byUser: ( NSString* )_UserID
                         on: ( NSDate* )_DeletionDate
    {
    for ( OTCTweet* tweet in self->_data )
        {
        if ( [ tweet.tweetIDString isEqualToString: _DeletedTweetID ] )
            {
            [ self->_data removeObject: tweet ];
            [ self.timelineTableView reloadData ];
            break;
            }
        }
    }

@end

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