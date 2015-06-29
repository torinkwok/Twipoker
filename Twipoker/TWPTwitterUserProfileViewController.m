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
#import "TWPTwitterUserProfileView.h"
#import "TWPActionNotifications.h"

@interface TWPTwitterUserProfileViewController ()

@end

// TWPTwitterUserProfileViewController class
@implementation TWPTwitterUserProfileViewController

#pragma mark Initializations
+ ( instancetype ) profileViewControllerWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                                       withTotemContent: ( id )_TotemContent
    {
    return [ [ self alloc ] initWithTwitterUser: _TwitterUser withTotemContent: _TotemContent ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                      withTotemContent: ( id )_TotemContent
    {
    if ( self = [ super initWithNibName: @"TWPTwitterUserProfileView" bundle: [ NSBundle mainBundle ] ] )
        {
        self->_twitterUser = _TwitterUser;

        [ ( TWPTwitterUserProfileView* )( self.view ) setTwitterUser: _TwitterUser ];
        [ self setTotemContent: _TotemContent ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

#pragma mark IBActions
- ( IBAction ) showTweetsButtonClicked: ( id )_Sender
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldShowUserTweets
                                                           object: self
                                                         userInfo: @{ kTwitterUser : self->_twitterUser ?: [ NSNull null ] } ];
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