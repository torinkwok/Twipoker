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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

@import Cocoa;

@class TWPUserAvatarWell;
@class TWPTimelineUserNameButton;
@class TWPTweetTextView;
@class TWPTweetOperationsPanelView;
@class TWPDateIndicatorView;
@class TWPTweetMediaWell;

@interface TWPTweetCellRep : NSTableCellView
    {
@private
    OTCTweet __strong* _tweet;
    }

@property ( weak ) IBOutlet TWPUserAvatarWell* authorAvatarWell;
@property ( weak ) IBOutlet TWPTimelineUserNameButton* userNameLabel;
@property ( weak ) IBOutlet TWPTweetTextView* tweetTextView;
@property ( weak ) IBOutlet TWPDateIndicatorView* dateIndicatorView;
@property ( weak ) IBOutlet TWPTweetOperationsPanelView* tweetOperationsPanelView;

@property ( weak ) IBOutlet NSLayoutConstraint* userNameLabelTop_equal_cellViewTop_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* tweetTextViewTop_equal_userNameLabelBottom_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* tweetOperationsPanelViewTop_equal_dateIndicatorBottom_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* cellViewBottom_equal_tweetOperationsPanelView_constraint;

@property ( strong, readwrite ) OTCTweet* tweet;

#pragma mark Height
- ( CGFloat ) heightWithTweetTextBlockHeight: ( CGFloat )_TweetTextBlockHeight;

#pragma mark Time
- ( void ) updateTime;

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