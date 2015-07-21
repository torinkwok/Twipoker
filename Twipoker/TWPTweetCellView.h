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

@import Cocoa;

@class OTCTweet;
@class OTCTwitterUser;
@class TWPUserAvatarWell;
@class TWPTimelineUserNameButton;
@class TWPTweetTextView;
@class TWPTweetOperationsPanelView;
@class TWPDateIndicatorView;
@class TWPTweetMediaWell;

@class TWPTweetCellRepController;
@class TWPTweetClearCellRepController;


typedef NS_ENUM( NSUInteger, TWPTweetCellViewStyle )
    { TWPTweetCellViewStyleClear = 0
    // TODO: Waiting for other styles
    };

// Notification Names
NSString extern* const TWPTweetCellViewShouldDisplayDetailOfTweet;

// User Info Keys
NSString extern* const TWPTweetCellViewTweetUserInfoKey;

// TWPTweetCellView class
@interface TWPTweetCellView : NSTableCellView
    {
@private
    OTCTweet __strong* _tweet;

    TWPTweetCellViewStyle _style;

    // Lazy evaluation
    TWPTweetClearCellRepController __strong* _clearCellRepController;
    }

@property ( strong, readwrite ) OTCTweet* tweet;
@property ( strong, readonly ) OTCTwitterUser* author;

@property ( strong, readonly ) TWPTweetCellRepController* currentTweetCellRepController;

#pragma mark Size
- ( CGFloat ) dynamicHeightAccordingToTweetTextBlockHeight: ( CGFloat )_TweetTextBlockHeight;

#pragma mrak Time
- ( void ) updateTime;

#pragma mark Initialization
+ ( instancetype ) tweetCellViewWithTweet: ( OTCTweet* )_Tweet;
- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet;

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