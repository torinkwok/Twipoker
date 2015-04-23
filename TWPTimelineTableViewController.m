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

#import "Objectwitter-C.h"

#import "TWPTimelineTableViewController.h"
#import "TWPTweetCellView.h"
#import "TWPLoginUser.h"
#import "TWPLoginUsersManager.h"
#import "TWPTimelineScrollView.h"

// Notification Names
NSString* const TWPTimelineTableViewDataSourceShouldLoadOlderTweets = @"TimelineTableViewDataSource.ShouldLoadOlderTweets";
NSString* const TWPTimelineTableViewDataSourceShouldLoadLaterTweets = @"TimelineTableViewDataSource.ShouldLoadLaterTweets";

@implementation TWPTimelineTableViewController

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->_tweets = [ NSMutableArray array ];

        [ [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI
            getHomeTimelineSinceID: nil count: 30 successBlock:
                ^( NSArray* _TweetObjects )
                    {
                    for ( NSDictionary* _TweetObject in _TweetObjects )
                        [ self->_tweets addObject: [ OTCTweet tweetWithJSON: _TweetObject ] ];

                    self->_sinceID = [ ( OTCTweet* )self->_tweets.firstObject tweetID ];
                    self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

                    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                                selector: @selector( tableViewDataSourceShoulLoadOlderTweets: )
                                                                    name: TWPTimelineTableViewDataSourceShouldLoadOlderTweets
                                                                  object: nil ];

                    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                                selector: @selector( tableViewDataSourceShoulLoadLaterTweets: )
                                                                    name: TWPTimelineTableViewDataSourceShouldLoadLaterTweets
                                                                  object: nil ];

                    [ ( NSTableView* )self.view reloadData ];
                    } errorBlock: ^( NSError* _Error )
                                    {
                                    [ self presentError: _Error ];
                                    } ];
        }

    return self;
    }

- ( void ) tableViewDataSourceShoulLoadOlderTweets: ( NSNotification* )_Notif
    {
    [ [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI
        getStatusesHomeTimelineWithCount: @"30"
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

                if ( ![ self->_tweets containsObject: tweet ] )
                    [ self->_tweets addObject: tweet ];
                }

            self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

            [ ( NSTableView* )self.view reloadData ];
            } errorBlock: ^( NSError* _Error )
                            {
                            [ self presentError: _Error ];
                            } ];
    }

- ( void ) tableViewDataSourceShoulLoadLaterTweets: ( NSNotification* )_Notif
    {
    NSLog( @"Later!" );
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_tweets.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: @"timeline" ] )
        result = self->_tweets[ _Row ];

    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    NSTableCellView* cellView = nil;

    OTCTweet* tweet = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    cellView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];
    [ ( TWPTweetCellView* )cellView setTweet: tweet ];

    return cellView;
    }

- ( BOOL ) tableView: ( NSTableView* )_TableView
     shouldSelectRow: ( NSInteger )_Row
    {
    return NO;
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