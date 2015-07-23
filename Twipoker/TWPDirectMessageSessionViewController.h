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

#import "TWPViewController.h"
#import "TWPDirectMessagesCoordinator.h"

@class TWPDirectMessageSession;
@class TWPDirectMessageSessionView;
@class TWPDirectMessageInputBox;

/*  TWPDirectMessageSessionViewController class
    View (frozen in TWPDirectMessagesSessionView.xib) controlled by this class:

    ┌──────────────────────────────────────────────────┐
    │                                                  │
    │   ┌─────────────────────────┐                    │
    │   │                         │               #0   │
    │   │                         │                    │
    │   └─────────────────────────┘                    │
    │   ┌─────────────────────────┐                    │
    │   │                         │                    │
    │   │                         │                    │
    │   └─────────────────────────┘                    │
    │                                                  │
    │                     ┌─────────────────────────┐  │
    │                     │                         │  │
    │                     │                         │  │
    │                     └─────────────────────────┘  │
    │                     ┌─────────────────────────┐  │
    │                     │                         │  │
    │                     │                         │  │
    │                     └─────────────────────────┘  │
    ├────────────────────────#1────────────────────────┤
    │┌────┐┌────────────────────────────────────┐┌────┐│
    ││ #2 ││                 #3                 ││ #4 ││
    │└────┘└────────────────────────────────────┘└────┘│
    └──────────────────────────────────────────────────┘
 */
@interface TWPDirectMessageSessionViewController : TWPViewController
    < NSTableViewDataSource, NSTableViewDelegate
    , NSTextViewDelegate, TWPDirectMessagesCoordinatorObserver >
    {
@private
    TWPDirectMessageSession __strong* _session;
    }

@property ( weak ) IBOutlet NSTableView* sessionTableView;      // #0
@property ( weak ) IBOutlet TWPDirectMessageInputBox* inputBox; // #1

#pragma mark Initializations
+ ( instancetype ) sessionViewControllerWithSession: ( TWPDirectMessageSession* )_DMSession withTotemContent: ( id )_TotemContent;
- ( instancetype ) initWithSession: ( TWPDirectMessageSession* )_DMSession withTotemContent: ( id )_TotemContent;

@end // TWPDirectMessageSessionViewController class

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