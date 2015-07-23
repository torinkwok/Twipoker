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

#import "TWPBrain.h"

@class TWPDirectMessagesPreviewViewController;
@class TWPDirectMessageSession;

@protocol TWPDirectMessagesCoordinatorObserver;

// TWPDirectMessagesCoordinator class
@interface TWPDirectMessagesCoordinator : NSObject <TWPLimb>
    {
@private
    // The ivar storing the direct messages sent to/received by current authenticating user
    NSMutableArray __strong* _allDMs;
    NSMutableArray __strong* _allDirectMessageSessions;

    STTwitterAPI __strong* _twitterAPI;

    /* @[ @[ OTCTwitterUser (Other Side User), id <TWPDirectMessagesCoordinatorObserver> (Observer) ]
        , @[ OTCTwitterUser (Other Side User), id <TWPDirectMessagesCoordinatorObserver> (Observer) ]
        , @[ OTCTwitterUser (Other Side User), id <TWPDirectMessagesCoordinatorObserver> (Observer) ]
        , ...
        ] */
    NSMutableArray __strong* _dispatchTable;
    }

@property ( weak ) IBOutlet TWPDirectMessagesPreviewViewController* DMPreviewViewContorller;

@property ( strong, readonly ) NSArray* allDMs;

// @[ TWPDirectMessageSession, TWPDirectMessageSession, ... ]
@property ( strong, readonly ) NSArray* allDirectMessageSessions;

#pragma mark Initialization
+ ( instancetype ) defaultCenter;

#pragma mark Observer Registration
// Adds an entry to the receiver’s dispatch table with an observer, an other side user object.
// Once the `_OtherSideUser` sent direct message to the current authenticating user, `_NewObserver` will be notified.
- ( void ) registerObserver: ( id <TWPDirectMessagesCoordinatorObserver> )_NewObserver
              otherSideUser: ( OTCTwitterUser* )_OtherSideUser;

// Removes all the entries specifying a given observer from the receiver’s dispatch table.
- ( void ) removeObserver: ( id )_Observer;

// Removes matching entries from the receiver’s dispatch table.
- ( void ) removeObserver: ( id )_Observer otherSideUser: ( OTCTwitterUser* )_OtherSideUser;

@end // TWPDirectMessagesCoordinator class

// <TWPDirectMessagesCoordinatorObserver> protocol
@protocol TWPDirectMessagesCoordinatorObserver <NSObject>

@optional
- ( void ) coordinator: ( TWPDirectMessagesCoordinator* )_Coordinator didAddNewSessionWithUser: ( OTCTwitterUser* )_OtherSideUser;

@required
- ( void ) coordinator: ( TWPDirectMessagesCoordinator* )_Coordinator didUpdateSessionWithUser: ( OTCTwitterUser* )_OtherSideUser;

@end // <TWPDirectMessagesCoordinatorObserver> protocol

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