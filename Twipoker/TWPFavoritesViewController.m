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

#import "TWPFavoritesViewController.h"
#import "TWPLoginUsersManager.h"

@interface TWPFavoritesViewController ()

@end

@implementation TWPFavoritesViewController

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPTimeline" bundle: [ NSBundle mainBundle ] ] )
        {
//        NSString* userID = [ self.twitterAPI.oauthAccessToken componentsSeparatedByString: @"-" ].firstObject;
//        [ [ TWPBrain wiseBrain ] registerLimb: self forUserID: userID brainSignal: TWPBrainSignalTypeEventMask ];

        [ [ TWPBrain wiseBrain ] registerLimb: self forUserIDs: nil brainSignal: TWPBrainSignalTypeTimelineEventMask ];

        [ self.twitterAPI getFavoritesListWithSuccessBlock:
            ^( NSArray* _TweetObjects )
                {
                for ( NSDictionary* _TweetObject in _TweetObjects )
                    [ self->_data addObject: [ OTCTweet tweetWithJSON: _TweetObject ] ];

                self->_sinceID = [ ( OTCTweet* )self->_data.firstObject tweetID ];
                self->_maxID = [ ( OTCTweet* )self->_data.lastObject tweetID ];

//                [ self.twitterAPI fetchUserStreamIncludeMessagesFromFollowedAccounts: @NO
//                                                                      includeReplies: @YES
//                                                                     keywordsToTrack: nil
//                                                               locationBoundingBoxes: nil ];
                [ self.timelineTableView reloadData ];
                } errorBlock: ^( NSError* _Error )
                                {
                                [ self presentError: _Error ];
                                } ];

        [ self setTotemContent: [ NSImage imageNamed: @"fav-tab" ] ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do view setup here.
    }

#pragma mark Conforms to <TWPTimelineScrollViewDelegate>
- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchOlderTweets: ( NSClipView* )_ClipView
    {
    if ( !self.isLoadingOlderTweets )
        {
        self.isLoadingOlderTweets = YES;
        NSLog( @"%s", __PRETTY_FUNCTION__ );

        STTwitterAPI __weak* twitterAPI = self.twitterAPI;
        [ twitterAPI getFavoritesListWithUserID: twitterAPI.userID
                                   orScreenName: nil
                                          count: @( self.numberOfTweetsWillBeLoadedOnce ).stringValue
                                        sinceID: nil
                                          maxID: @( self->_maxID ).stringValue
                                includeEntities: @YES
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

#pragma mark Conforms to <TWPLimb>
- ( void ) brain: ( TWPBrain* )_Brain didReceiveEvent: ( OTCStreamingEvent* )_DetectedEvent
    {
    if ( _DetectedEvent.eventType == OTCStreamingEventTypeFavorite )
        {
        if ( [ _DetectedEvent.sourceUser.IDString isEqualToString: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID ] )
            {
            OTCTweet* targetTweet = ( OTCTweet* )_DetectedEvent.targetObject;

            if ( targetTweet )
                {
                [ self->_data insertObject: targetTweet atIndex: 0 ];
                [ self.timelineTableView reloadData ];
                }
            }
        }

    else if ( _DetectedEvent.eventType == OTCStreamingEventTypeUnfavorite )
        {
        if ( [ _DetectedEvent.sourceUser.IDString isEqualToString: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID ] )
            {
            [ self->_data removeObject: _DetectedEvent.targetObject ];
            [ self.timelineTableView reloadData ];
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