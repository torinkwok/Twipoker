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

#import "TWPTimelineTableView.h"
#import "TWPTweetCellView.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPDateIndicatorView.h"

// TWPTimelineTableView class
@implementation TWPTimelineTableView

- ( BOOL ) validateProposedFirstResponder: ( NSResponder* )_Responder
                                 forEvent: ( NSEvent* )_Event
    {
    if ( [ _Responder isKindOfClass: [ TWPTweetCellView class ] ]
            || [ _Responder isKindOfClass: [ TWPUserAvatarWell class ] ] )
        return YES;
    else
        return [ super validateProposedFirstResponder: _Responder forEvent: _Event ];
    }

- ( void ) awakeFromNib
    {
    [ [ TWPTimeServiceCenter defaultTimeServiceCenter ] addObserver: self ];
    }

#pragma mark Conforms to <TWPTimeServiceCenterObserver>
- ( void ) updateTime
    {
    [ self enumerateAvailableRowViewsUsingBlock:
        ^( NSTableRowView* _RowView, NSInteger _Row )
            {
            [ ( ( TWPTweetCellView* )[ _RowView viewAtColumn: 0 ] ).dateIndicatorView updateTime ];
            } ];
    }

@end // TWPTimelineTableView class

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