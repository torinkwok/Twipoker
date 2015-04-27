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

#import "TWPViewController.h"
#import "TWPTweetCellView.h"
#import "TWPLoginUsersManager.h"

@implementation TWPViewController

@synthesize isLoadingOlderTweets = _isLoadingOlderTweets;
@synthesize numberOfTweetsWillBeLoadedOnce = _numberOfTweetsWillBeLoadedOnce;

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil
                            bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        {
        self->_tweets = [ NSMutableArray array ];

        self->_isLoadingOlderTweets = NO;
        self->_numberOfTweetsWillBeLoadedOnce = 20;
        }

    return self;
    }

#pragma mark Conforms to <TWPTimelineTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_tweets.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: @"home-timeline" ] )
        result = self->_tweets[ _Row ];

    return result;
    }

#pragma mark Conforms to <TWPTimelineTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    TWPTweetCellView* tweetCellView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    OTCTweet* tweet = self->_tweets[ _Row ];
    [ tweetCellView.userDisplayNameLabel setStringValue: tweet.author.displayName ];
    [ tweetCellView.userScreenNameLabel setStringValue: tweet.author.screenName ];
    [ tweetCellView.tweetTextLabel setStringValue: tweet.tweetText ];

    return tweetCellView;
    }

- ( void ) fetchTweetsWithSTTwitterAPI: ( SEL )_FetchAPISelector
                            parameters: ( NSArray* )_Arguments
                          successBlock: ( void (^)( NSArray* ) )_SuccessBlock
                            errorBlock: ( void (^)( NSError* ) )_ErrorBlock
                                target: ( id )_Target
    {
    NSMethodSignature* methodSignature = [ STTwitterAPI instanceMethodSignatureForSelector: _FetchAPISelector ];
    NSInvocation* twitterAPIInvocation = [ NSInvocation invocationWithMethodSignature: methodSignature ];

    [ twitterAPIInvocation setSelector: _FetchAPISelector ];

    NSInteger index = 2;
    for ( id _Arg in _Arguments )
        {
        if ( _Arg != [ NSNull null ] )
            {
            id argBuffer = _Arg;
            [ twitterAPIInvocation setArgument: &argBuffer atIndex: index ];
            }

        index++;
        }

    if ( _SuccessBlock )
        [ twitterAPIInvocation setArgument: ( __bridge void* )( [ _SuccessBlock copy ] ) atIndex: index++ ];
    else
        {
        void ( ^successBlock )( NSArray* ) =
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
                };

        successBlock = [ successBlock copy ];
        [ twitterAPIInvocation setArgument: &successBlock atIndex: index++ ];
        }

    if ( _ErrorBlock )
        [ twitterAPIInvocation setArgument: ( __bridge void* )( [ _ErrorBlock copy ] ) atIndex: index++ ];
    else
        {
        void ( ^errorBlock )( NSError* ) =
            ^( NSError* _Error )
                {
                [ self presentError: _Error ];
                };

        errorBlock = [ errorBlock copy ];
        [ twitterAPIInvocation setArgument: &errorBlock atIndex: index++ ];
        }

    [ twitterAPIInvocation invokeWithTarget: _Target ];
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