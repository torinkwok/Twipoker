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

#import "TWPCurrentLoginUserOperationsPopover.h"
#import "TWPCurrentLoginUserOperationsViewController.h"
#import "TWPCurrentLoginUserOperationsView.h"

// Private Interfaces
@interface TWPCurrentLoginUserOperationsPopover ()

- ( NSButton* ) _editProfileButton;
- ( NSButton* ) _switchAccountButton;
- ( NSButton* ) _logoutButton;

@end // Private Interfaces

// TWPCurrentLoginUserOperationsPopover class
@implementation TWPCurrentLoginUserOperationsPopover

@dynamic twitterUser;

#pragma mark Initializations
+ ( instancetype ) popoverWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                                 delegate: ( id <TWPCurrentLoginUserOperationsPopoverDelegate> )_Delegate
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser delegate: _Delegate ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                              delegate: ( id <TWPCurrentLoginUserOperationsPopoverDelegate> )_Delegate
    {
    if ( self = [ super init ] )
        {
        self->_twitterUser = _TwitterUser;

        TWPCurrentLoginUserOperationsViewController* operationsViewController = [ TWPCurrentLoginUserOperationsViewController operationsViewController ];
        [ self setContentViewController: operationsViewController ];
        [ self setDelegate: _Delegate ];
        [ self setBehavior: NSPopoverBehaviorTransient ];

        [ [ self _editProfileButton ] setTarget: self ];
        [ [ self _editProfileButton ] setAction: @selector( editProfileButtonClickedAction: ) ];

        [ [ self _switchAccountButton ] setTarget: self ];
        [ [ self _switchAccountButton ] setAction: @selector( switchAccountClickedAction: ) ];

        [ [ self _logoutButton ] setTarget: self ];
        [ [ self _logoutButton ] setAction: @selector( logoutClickedAction: ) ];
        }

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    self->_twitterUser = _TwitterUser;
    }

- ( OTCTwitterUser* ) twitterUser
    {
    return self->_twitterUser;
    }

#pragma mark IBActions
- ( IBAction ) editProfileButtonClickedAction: ( id )_Sender
    {
    NSLog( @"%s", __PRETTY_FUNCTION__ );
    
    // TODO:

    [ self performClose: self ];
    }

- ( IBAction ) switchAccountClickedAction: ( id )_Sender
    {
    NSLog( @"%s", __PRETTY_FUNCTION__ );

    // TODO:

    [ self performClose: self ];
    }

- ( IBAction ) logoutClickedAction: ( id )_Sender
    {
    NSLog( @"%s", __PRETTY_FUNCTION__ );

    // TODO:

    [ self performClose: self ];
    }

#pragma mark Private Interfaces
- ( NSButton* ) _editProfileButton
    {
    return [ ( TWPCurrentLoginUserOperationsView* )( self.contentViewController.view ) editProfileButton ];
    }

- ( NSButton* ) _switchAccountButton
    {
    return [ ( TWPCurrentLoginUserOperationsView* )( self.contentViewController.view ) switchAccountButton ];
    }

- ( NSButton* ) _logoutButton
    {
    return [ ( TWPCurrentLoginUserOperationsView* )( self.contentViewController.view ) logoutButton ];
    }

@end // TWPCurrentLoginUserOperationsPopover class

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