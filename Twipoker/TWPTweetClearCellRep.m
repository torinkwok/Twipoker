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

#import "TWPTweetClearCellRep.h"

#import "TWPTweetTextView.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPTweetOperationsPanelView.h"
#import "TWPDateIndicatorView.h"

// TWPTweetClearCellRep class
@implementation TWPTweetClearCellRep

#pragma mark Height
- ( CGFloat ) heightWithTweetTextBlockHeight: ( CGFloat )_TweetTextBlockHeight
    {
    CGFloat constraintHeight0 = self.userNameLabelTop_equal_cellViewTop_constraint.constant;
    CGFloat constraintHeight1 = self.tweetTextViewTop_equal_userNameLabelBottom_constraint.constant;
    CGFloat constraintHeight2 = self.dateIndicatorTop_equal_tweetTextViewBottom_constraint.constant;
    CGFloat constraintHeight3 = self.tweetOperationsPanelViewTop_equal_dateIndicatorBottom_constraint.constant;
    CGFloat constraintHeight4 = self.cellViewBottom_equal_tweetOperationsPanelView_constraint.constant;

    CGFloat tweetTextViewHeight = ( _TweetTextBlockHeight > [ TWPTweetTextView defaultSize ].height ) ? _TweetTextBlockHeight : [ TWPTweetTextView defaultSize ].height;
    CGFloat userNameLabelHeight = NSHeight( self.userNameLabel.frame );
    CGFloat dateIndicatorHeight = NSHeight( self.dateIndicatorView.frame );
    CGFloat tweetOperationsPanelViewHeight = NSHeight( self.tweetOperationsPanelView.frame );

    return constraintHeight0 + constraintHeight1 + constraintHeight2 + constraintHeight3 + constraintHeight4
                + tweetTextViewHeight + userNameLabelHeight + dateIndicatorHeight + tweetOperationsPanelViewHeight;
    }

@end // TWPTweetClearCellRep class

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