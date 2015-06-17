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

#import "TWPTwitterUserProfileView.h"
#import "TWPNavigationBarController.h"
#import "TWPCuttingLineView.h"
#import "TWPUserAvatarWell.h"

@implementation TWPTwitterUserProfileView

@dynamic navigationBarController;

@synthesize hideButton;
@synthesize cuttingLineView;

@synthesize userAvatar;
@synthesize userDisplayNameField;
@synthesize userScreenNameField;
@synthesize bioField;
@synthesize locationField;
@synthesize homePageField;

@synthesize tweetsCountButton;
@synthesize followersCountButton;
@synthesize followingCountButton;

@synthesize tweetToUserButton;
@synthesize sendADirectMessageButton;
@synthesize addOrRemoveFromListsButton;

@synthesize iDoNotLikeThisGuyButton;

@dynamic twitterUser;

#pragma mark Dynamic Accessors
- ( void ) setNavigationBarController: ( TWPNavigationBarController* )_NavigationBarController
    {
    self->_navigationBarController = _NavigationBarController;

    NSRect newFrameOfCuttingLine = NSMakeRect( NSMinX( self.cuttingLineView.frame )
                                             , NSHeight( self->_navigationBarController.view.frame )
                                             , NSWidth( self.cuttingLineView.bounds )
                                             , NSHeight( self.cuttingLineView.bounds )
                                             );

    [ self.cuttingLineView setFrame: newFrameOfCuttingLine ];
    [ self addSubview: self.cuttingLineView ];
    }

- ( TWPNavigationBarController* ) navigationBarController
    {
    return self->_navigationBarController;
    }

- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    self->_twitterUser = _TwitterUser;

    if ( self->_twitterUser )
        {
        [ self.userDisplayNameField setStringValue: self->_twitterUser.displayName ];
        [ self.userScreenNameField setStringValue: self->_twitterUser.screenName ];

        [ self.bioField setStringValue: self->_twitterUser.bio ?: @"" ];
        [ self.locationField setStringValue: self->_twitterUser.location ?: @"" ];
        [ self.homePageField setStringValue: self->_twitterUser.website.displayText ?: @"" ];

        [ self.tweetToUserButton setTitle: [ NSString stringWithFormat: @"Tweet to %@", self->_twitterUser.screenName ] ];

        [ self.userAvatar setTwitterUser: self->_twitterUser ];
        }
    }

- ( OTCTwitterUser* ) twitterUser
    {
    return self->_twitterUser;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ [ NSColor whiteColor ] set ];
    NSRectFill( _DirtyRect );
    }

- ( BOOL ) isFlipped
    {
    return YES;
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