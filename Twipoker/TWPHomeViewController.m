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
#import "TWPBrain.h"
#import "TWPLoginUsersManager.h"

@interface TWPHomeViewController ()

@end

@implementation TWPHomeViewController

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPHomeView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ [ TWPBrain wiseBrain ] registerLimb: self forUserIDs: nil brainSignal:
            TWPBrainSignalTypeNewTweetMask | TWPBrainSignalTypeTweetDeletionMask | TWPBrainSignalTypeTimelineEventMask ];

        [ self.twitterAPI getHomeTimelineSinceID: nil count: self.numberOfTweetsWillBeLoadedOnce successBlock:
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

- ( void )    brain: ( TWPBrain* )_Brain
    didReceiveEvent: ( OTCStreamingEvent* )_DetectedEvent
    {
    OTCStreamingEventType eventType = _DetectedEvent.eventType;
    id targetObject = _DetectedEvent.targetObject;

    switch ( eventType )
        {
        case OTCStreamingEventTypeFavorite:
            {
            NSUInteger favedTweetIndex = [ self->_data indexOfObject: targetObject ];
            [ self->_data[ favedTweetIndex ] setFavoritedByMe: YES ];
            [ self.timelineTableView reloadData ];
            } break;

        case OTCStreamingEventTypeUnfavorite:
            {
            NSUInteger unfavedTweetIndex = [ self->_data indexOfObject: targetObject ];
            [ self->_data[ unfavedTweetIndex ] setFavoritedByMe: NO ];
            [ self.timelineTableView reloadData ];
            } break;

        default: ;
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