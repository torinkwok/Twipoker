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

#import <Cocoa/Cocoa.h>

#import "TWPTimelineTableView.h"

@interface TWPViewController : NSViewController
    <TWPTimelineTableViewDataSource, TWPTimelineTableViewDelegate>
    {
@protected
    NSMutableArray __strong* _tweets;

    BOOL _isLoadingOlderTweets;
    NSUInteger _numberOfTweetsWillBeLoadedOnce;

    SInt64 _sinceID;
    SInt64 _maxID;
    }

@property ( weak ) IBOutlet TWPTimelineTableView* timelineTableView;

#pragma mark Conforms to <TWPTimelineTableViewDataSource>
@property ( assign, readwrite ) BOOL isLoadingOlderTweets;
@property ( assign, readwrite ) NSUInteger numberOfTweetsWillBeLoadedOnce;

#pragma mark Conforms to <TWPTimelineTableViewDelegate>
- ( void ) tableViewDataSourceShouldLoadOlderTweets: ( NSNotification* )_Notif;
- ( void ) tableViewDataSourceShouldLoadLaterTweets: ( NSNotification* )_Notif;

- ( void ) fetchTweetsWithSTTwitterAPI: ( SEL )_FetchAPISelector
                            parameters: ( NSArray* )_Arguments
                          successBlock: ( void (^)( NSArray* ) )_SuccessBlock
                            errorBlock: ( void (^)( NSError* ) )_ErrorBlock
                                target: ( id )_Target;

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