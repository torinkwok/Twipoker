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
#import "TWPActionNotifications.h"

// Private Interfaces
@interface TWPTwitterUserProfileViewController ()
- ( TWPTwitterUserProfileView* ) _profileView;
@end // Private Interfaces

// TWPTwitterUserProfileViewController class
@implementation TWPTwitterUserProfileViewController

@dynamic refNavBarController;
@dynamic twitterUser;

#pragma mark Initializations
+ ( instancetype ) prifileViewControllerWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                                   consultNavigationBar: ( TWPNavigationBarController* )_NavBarController
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser consultNavigationBar: _NavBarController ];
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    return [ self initWithTwitterUser: nil consultNavigationBar: nil ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                  consultNavigationBar: ( TWPNavigationBarController* )_NavBarController
    {
    if ( self = [ super initWithNibName: @"TWPTwitterUserProfileView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ [ self _profileView ] setTwitterUser: _TwitterUser ];
        [ [ self _profileView ] setRefNavBarController: _NavBarController ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

#pragma mark Dynamic Accessors
- ( void ) setRefNavBarController: ( TWPNavigationBarController* )_NavBarController
    {
    [ [ self _profileView ] setRefNavBarController: _NavBarController ];
    }

- ( TWPNavigationBarController* ) refNavBarController
    {
    return [ [ self _profileView ] refNavBarController ];
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

#pragma mark IBActions
- ( IBAction ) hideUserProfileButtonClicked: ( id )_Sender
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldHideUserProfile
                                                           object: self ];
    }

- ( IBAction ) showTweetsButtonClicked: ( id )_Sender
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldShowUserTweets
                                                           object: self
                                                         userInfo: @{ kTwitterUser : self.twitterUser } ];
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