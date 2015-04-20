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

#import "TWPAppDelegate.h"
#import "TWPLoginPanel.h"
#import "TWPLoginPanelController.h"
#import "TWPMainWindowController.h"
#import "TWPLoginUsersManager.h"

@implementation TWPAppDelegate

#pragma mark Initialization & Deallocation
- ( void ) awakeFromNib
    {
    self.loginPanelController = [ TWPLoginPanelController loginPanelController ];
    self.mainWindowController = [ TWPMainWindowController mainWindowController ];
    }

- ( void ) applicationWillFinishLaunching: ( NSNotification* )_Notif
    {
    if ( [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ] )
        [ self.mainWindowController showWindow: self ];
    else
        {
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( twipokerDidFinishLogin: )
                                                        name: TWPTwipokerDidFinishLoginNotification
                                                      object: nil ];
        // If there is no current user,
        // we have to prompt user for authorization by showing them a beautiful login panel.
        [ self.loginPanelController showWindow: self ];
        }
    }

#pragma mark Conforms to <TWPUesrManagerDelegate>
// Sent by the default notification center immediately after a successful login
- ( void ) twipokerDidFinishLogin: ( NSNotification* )_Notif
    {
    [ self.loginPanelController close ];
    [ self.mainWindowController showWindow: self ];
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