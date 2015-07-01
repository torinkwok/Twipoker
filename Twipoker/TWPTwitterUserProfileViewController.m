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
    if ( self = [ self /* yep, it's "self" */ init ] )
        {
        self->_twitterUser = _TwitterUser;

        [ ( TWPTwitterUserProfileView* )( self.view ) setTwitterUser: _TwitterUser ];
        [ self setTotemContent: _TotemContent ];
        }

    return self;
    }

- ( instancetype ) initWithCoder:(NSCoder *)coder
    {
    return [ [ [ super class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPTwitterUserProfileView" bundle: [ NSBundle mainBundle ] ] )
        [ self setTotemContent: [ NSImage imageNamed: TWPArtworkMeTabGray ] ];

    return self;
    }

- ( void ) viewWillAppear
    {
    // If there is not any explicitly specified Twitter user,
    // use current Twitter user
    if ( !self->_twitterUser )
        {
        self->_twitterUser = [ [ TWPBrain wiseBrain ] currentTwitterUser ];
        [ ( TWPTwitterUserProfileView* )( self.view ) setTwitterUser: self->_twitterUser ];
        }
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