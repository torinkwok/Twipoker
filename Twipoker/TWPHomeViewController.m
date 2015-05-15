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

#import "TWPHomeViewController.h"
#import "TWPLoginUsersManager.h"

@interface TWPHomeViewController ()

@end

@implementation TWPHomeViewController

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPHomeView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ self.twitterAPI getHomeTimelineSinceID: nil count: self.numberOfTweetsWillBeLoadedOnce successBlock:
            ^( NSArray* _TweetObjects )
                {
                for ( NSDictionary* _TweetObject in _TweetObjects )
                    [ self->_tweets addObject: [ OTCTweet tweetWithJSON: _TweetObject ] ];

                self->_sinceID = [ ( OTCTweet* )self->_tweets.firstObject tweetID ];
                self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

                [ self.twitterAPI fetchUserStreamIncludeMessagesFromFollowedAccounts: @NO
                                                                      includeReplies: @YES
                                                                     keywordsToTrack: nil
                                                               locationBoundingBoxes: nil ];
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

#pragma mark Conforms to <TWPTimelineScrollViewDelegate>
- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchOlderTweets: ( NSClipView* )_ClipView
    {
    if ( !self.isLoadingOlderTweets )
        {
        self.isLoadingOlderTweets = YES;
        NSLog( @"%s", __PRETTY_FUNCTION__ );

        [ self.twitterAPI getStatusesHomeTimelineWithCount: @( self.numberOfTweetsWillBeLoadedOnce).stringValue
                                                   sinceID: nil
                                                     maxID: @( self->_maxID - 1 ).stringValue
                                                  trimUser: @NO
                                            excludeReplies: @0
                                        contributorDetails: @YES
                                           includeEntities: @YES
                                              successBlock:
            ^( NSArray* _TweetObjects )
                {
                for ( NSDictionary* _TweetObject in _TweetObjects )
                    {
                    // Data source did finish loading older tweets
                    self.isLoadingOlderTweets = NO;

                    OTCTweet* tweet = [ OTCTweet tweetWithJSON: _TweetObject ];

                    // Duplicate tweet? Get out of here!
                    if ( ![ self->_tweets containsObject: tweet ] )
                        [ self->_tweets addObject: tweet ];
                    }

                self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

                [ self.timelineTableView reloadData ];
                } errorBlock: ^( NSError* _Error )
                                {
                                // Data source did finish loading older tweets due to the error occured
                                self.isLoadingOlderTweets = NO;
                                [ self presentError: _Error ];
                                } ];
        }
    }

- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchLaterTweets: ( NSClipView* )_ClipView
    {
    NSLog( @"%s", __PRETTY_FUNCTION__ );
    }

#pragma mark Conforms to <OTCTwitterStreamingAPIDelegate>
- ( void ) twitterAPI: ( STTwitterAPI* )_TwitterAPI
      didReceiveTweet: ( OTCTweet* )_ReceivedTweet
    {
    [ self->_tweets insertObject: _ReceivedTweet atIndex: 0 ];
    [ self.timelineTableView reloadData ];
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