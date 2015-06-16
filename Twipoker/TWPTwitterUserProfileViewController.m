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

#import "TWPTwitterUserProfileViewController.h"
#import "TWPNavigationBarController.h"
#import "TWPTwitterUserProfileView.h"

// Private Interfaces
@interface TWPTwitterUserProfileViewController ()
- ( TWPTwitterUserProfileView* ) _profileView;
@end // Private Interfaces

// TWPTwitterUserProfileViewController class
@implementation TWPTwitterUserProfileViewController

@dynamic navigationBarController;
@dynamic twitterUser;

#pragma mark Initializations
+ ( instancetype ) prifileViewControllerWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                                   consultNavigationBar: ( TWPNavigationBarController* )_NavigationBarController
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser consultNavigationBar: _NavigationBarController ];
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    return [ self initWithTwitterUser: nil consultNavigationBar: nil ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                  consultNavigationBar: ( TWPNavigationBarController* )_NavigationBarController
    {
    if ( self = [ super initWithNibName: @"TWPTwitterUserProfileView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ [ self _profileView ] setTwitterUser: _TwitterUser ];
        [ [ self _profileView ] setNavigationBarController: _NavigationBarController ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

#pragma mark Dynamic Accessors
- ( void ) setNavigationBarController: ( TWPNavigationBarController* )_NavigationBarController
    {
    [ [ self _profileView ] setNavigationBarController: _NavigationBarController ];
    }

- ( TWPNavigationBarController* ) navigationBarController
    {
    return [ [ self _profileView ] navigationBarController ];
    }

- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    [ [ self _profileView ] setTwitterUser: _TwitterUser ];
    }

- ( OTCTwitterUser* ) twitterUser
    {
    return [ [ self _profileView ] twitterUser ];
    }

#pragma mark Private Interfaces
- ( TWPTwitterUserProfileView* ) _profileView
    {
    return ( TWPTwitterUserProfileView* )( self.view );
    }

@end // TWPTwitterUserProfileViewController class

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