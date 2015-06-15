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

@protocol TWPDashboardViewDelegate;

@class TWPDashboardTab;
@class TWPTweetBoxController;

// TWPDashboardView class
@interface TWPDashboardView : NSView

@property( weak ) IBOutlet TWPDashboardTab* homeTab;
@property( weak ) IBOutlet TWPDashboardTab* favoriteTab;
@property( weak ) IBOutlet TWPDashboardTab* listsTab;
@property( weak ) IBOutlet TWPDashboardTab* notificationTab;
@property( weak ) IBOutlet TWPDashboardTab* meTab;
@property( weak ) IBOutlet TWPDashboardTab* messagesTab;

@property ( weak, readwrite ) IBOutlet id <TWPDashboardViewDelegate> delegate;

@property ( strong, readwrite ) TWPTweetBoxController* tweetBoxController;

#pragma mark IBActions
- ( IBAction ) tabClickedAction: ( id )_Sender;
- ( IBAction ) tweetButtonClickedAction: ( id )_Sender;

@end // TWPDashboardView class

// TWPDashboardViewDelegate protocol
@protocol TWPDashboardViewDelegate <NSObject>

@required
- ( void ) dashboardView: ( TWPDashboardView* )_DashboardView
    selectedTabDidChange: ( TWPDashboardTab* )_NewSelectedTab;

@end // TWPDashboardViewDelegate protocol

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