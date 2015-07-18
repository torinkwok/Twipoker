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

// Notification Names
NSString extern* const TWPTweetCellViewShouldDisplayDetailOfTweet;

// User Info Keys
NSString extern* const TWPTweetCellViewTweetUserInfoKey;

// TWPTweetCellView class
@interface TWPTweetCellView : NSTableCellView
    {
@private
    OTCTweet __strong* _tweet;
    CGFloat _refHeight;

    NSTrackingAreaOptions _trackingAreaOptions;
    NSTrackingArea __strong* _trackingArea;

    BOOL _isShowingTweetOperationsPanel;

    NSArray __strong* _expandButtonHorizontalConstraints;
    NSArray __strong* _expandButtonVerticalConstraints;

    TWPTweetMediaWell __strong* _tweetMediaWell;
    }

#pragma mark Outlets
@property ( weak ) IBOutlet TWPUserAvatarWell* authorAvatarWell;
@property ( weak ) IBOutlet TWPTimelineUserNameButton* userNameLabel;
@property ( weak ) IBOutlet TWPDateIndicatorView* dateIndicatorView;
@property ( weak ) IBOutlet TWPTweetTextView* tweetTextView;
@property ( strong, readonly ) TWPTweetMediaWell* tweetMediaWell;

@property ( strong, readwrite ) OTCTweet* tweet;
@property ( strong, readonly ) OTCTwitterUser* author;

@property ( weak ) IBOutlet NSLayoutConstraint* userNameLabelTop_equal_cellViewTop_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* tweetTextViewTop_equal_userNameLabelBottom_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* dateIndicatorTop_equal_tweetTextViewBottom_constraint;
@property ( weak ) IBOutlet NSLayoutConstraint* cellViewBottom_equal_dateIndicatorBottom_constraint;

@property ( weak ) IBOutlet NSLayoutConstraint* cellViewBottom_equal_tweetTextViewBottom_constraint;

#pragma mark Size
- ( CGFloat ) dynamicHeightAccordingToTweetTextBlockHeight: ( CGFloat )_TweetTextBlockHeight;

#pragma mark Initialization
+ ( instancetype ) tweetCellViewWithTweet: ( OTCTweet* )_Tweet;
- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet;

#pragma mark IBAction
- ( IBAction ) userNameLabelClickedAction: ( id )_Sender;
- ( IBAction ) userAvatarClickedAction: ( id )_Sender;

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