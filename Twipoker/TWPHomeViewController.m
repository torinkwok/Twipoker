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
#import "TWPTweetOperationsNotificationNames.h"

@interface TWPHomeViewController ()

@end

@implementation TWPHomeViewController

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPHomeView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ [ TWPBrain wiseBrain ] registerLimb: self forUserIDs: nil brainSignal:
            TWPBrainSignalTypeNewTweetMask | TWPBrainSignalTypeTweetDeletionMask
                | TWPBrainSignalTypeTimelineEventMask | TWPBrainSignalTypeRetweetMask ];

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

#pragma makr Conforms to <TWPTimelineScrollViewDataSource>
- ( void ) tweetOperationShouldBeUnretweeted: ( NSNotification* )_Notif
    {
    NSLog( @"%@", _Notif );

    OTCTweet* originalTweetShouldBeUnretweeted = _Notif.userInfo[ kOriginalTweet ];
    OTCTweet* tweetShouldBeDestroyed = nil;
    for ( OTCTweet* _Tweet in self->_data )
        {
        if ( _Tweet.type == OTCTweetTypeRetweet
                && [ _Tweet.originalTweet isEqualToTweet: originalTweetShouldBeUnretweeted ]
                && [ _Tweet.author.IDString isEqualToString: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID ] )
            {
            tweetShouldBeDestroyed = _Tweet;
            break;
            }
        }

    if ( tweetShouldBeDestroyed )
        {
        [ [ TWPBrain wiseBrain ] destroyTweet: tweetShouldBeDestroyed
                                 successBlock:
                ^( OTCTweet* _DestroyedTweet )
                    {
                #if DEBUG
                    NSLog( @"Just destroyed Tweet: %@", _DestroyedTweet );
                #endif
                    } errorBlock: ^( NSError* _Error )
                                    {
                                    NSLog( @"%@", _Error );
                                    } ];
        }
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
- ( void )    brain: ( TWPBrain* )_Brain
    didReceiveTweet: ( OTCTweet* )_Tweet
    {
    [ self->_data insertObject: _Tweet atIndex: 0 ];
    [ self.timelineTableView reloadData ];
    }

- ( void )      brain: ( TWPBrain* )_Brain
    didReceiveRetweet: ( OTCTweet* )_Retweet
    {
    NSLog( @"Retweet: %@", _Retweet );

    OTCTweet* originalTweet = _Retweet.originalTweet;
    NSNumber* originalAuthorID = @( _Retweet.originalTweet.author.ID );

    // If the original author has been already followed by me...
    if ( ![ [ TWPBrain wiseBrain ].friendsList containsObject: originalAuthorID ] )
        {
        if ( originalAuthorID.longLongValue != [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID.longLongValue )
            {
            // or it's myself (i.e. someone retweeted my own Tweet)
            [ self->_data insertObject: _Retweet atIndex: 0 ];
            [ self.timelineTableView reloadData ];
            }
        }

    if ( [ _Retweet.author.IDString isEqualToString: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID ] )
        // Cache this Retweet for querying the nested original Tweet
        [ self->_data insertObject: _Retweet atIndex: 0 ];

    NSUInteger favedTweetIndex = [ self->_data indexOfObject: originalTweet ];
    if ( favedTweetIndex != NSNotFound )
        {
        // Retweeted was created, so the original Tweet has been retweeted
        [ self->_data[ favedTweetIndex ] setRetweetedByMe: YES ];
        [ self.timelineTableView reloadData ];
        }
    }

- ( void )            brain: ( TWPBrain* )_Brain
    didReceiveTweetDeletion: ( NSString* )_DeletedTweetID
                     byUser: ( NSString* )_UserID
                         on: ( NSDate* )_DeletionDate
    {
    // Handling Tweet deletion/unretweet
    for ( OTCTweet* tweet in self->_data )
        {
        // The deleted Tweet was indeed cached in self->_data
        if ( [ tweet.tweetIDString isEqualToString: _DeletedTweetID ] )
            {
            // Determining if the deleted tweet was representing a retweet,
            // that means this delete action is actually an unretweet action
            if ( tweet.type == OTCTweetTypeRetweet )
                {
                // Find out the original Tweet nested in deleted Tweet
                NSUInteger favedTweetIndex = [ self->_data indexOfObject: tweet.originalTweet ];

                if ( favedTweetIndex != NSNotFound )
                    // Retweet was deleted, so the original Tweet has been unretweeted
                    [ self->_data[ favedTweetIndex ] setRetweetedByMe: NO ];
                }

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

            if ( favedTweetIndex != NSNotFound )
                {
                [ self->_data[ favedTweetIndex ] setFavoritedByMe: YES ];
                [ self.timelineTableView reloadData ];
                }
            else
                NSLog( @"Failed to find this target object" );
            } break;

        case OTCStreamingEventTypeUnfavorite:
            {
            NSUInteger unfavedTweetIndex = [ self->_data indexOfObject: targetObject ];

            if ( unfavedTweetIndex != NSNotFound )
                {
                [ self->_data[ unfavedTweetIndex ] setFavoritedByMe: NO ];
                [ self.timelineTableView reloadData ];
                }
            else
                NSLog( @"Failed to find this target object" );                
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