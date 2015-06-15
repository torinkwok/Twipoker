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
|                    _ _ _ _ _ ____   ___ | |  _ _____  ___x_| |                |██
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

#import "TWPTwitterListTimelineViewController.h"
#import "TWPTimelineScrollView.h"

@implementation TWPTwitterListTimelineViewController

+ ( instancetype ) twitterListViewControllerWithTwitterList: ( OTCList* )_TwitterList
    {
    return [ [ [ self class ] alloc ] initWithTwitterList: _TwitterList ];
    }

- ( instancetype ) initWithTwitterList: ( OTCList* )_TwitterList
    {
    if ( !_TwitterList )
        return nil;

    if ( self = [ super initWithNibName: @"TWPTimeline" bundle: [ NSBundle mainBundle ] ] )
        {
        self->_twitterList = _TwitterList;

        [ self.twitterAPI getListsStatusesForListID: [ NSString stringWithFormat: @"%@", self->_twitterList.IDString ]
                                            sinceID: nil
                                              maxID: nil
                                              count: [ NSString stringWithFormat: @"%lu", self.numberOfTweetsWillBeLoadedOnce ]
                                    includeEntities: @YES
                                    includeRetweets: @YES
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

- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchOlderTweets: ( NSClipView* )_ClipView
    {
    if ( !self.isLoadingOlderTweets )
        {
        self.isLoadingOlderTweets = YES;
        NSLog( @"%s", __PRETTY_FUNCTION__ );

        [ self.twitterAPI getListsStatusesForListID: self->_twitterList.IDString
                                            sinceID: nil
                                              maxID: @( self->_maxID - 1 ).stringValue
                                              count: @( self.numberOfTweetsWillBeLoadedOnce ).stringValue
                                    includeEntities: @YES
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