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

#import "TWPTwitterUserProfileView.h"

#import "TWPCuttingLineView.h"
#import "TWPUserAvatarWell.h"
#import "TWPUserProfileCountButton.h"

#import "NSView+TwipokerAutoLayout.h"

@implementation TWPTwitterUserProfileView

@synthesize hideButton;
@synthesize cuttingLineView;

@synthesize userAvatar;
@synthesize userDisplayNameField;
@synthesize userScreenNameField;
@synthesize bioField;
@synthesize locationField;
@synthesize websiteField;

@synthesize tweetsCountButton;
@synthesize followersCountButton;
@synthesize followingCountButton;

@synthesize tweetToUserButton;
@synthesize sendADirectMessageButton;
@synthesize addOrRemoveFromListsButton;

@synthesize iDoNotLikeThisGuyButton;

@dynamic twitterUser;

- ( void ) awakeFromNib
    {
    [ self.tweetsCountButton setCountButtonType: TWPUserProfileCountButtonTypeTweets ];
    [ self.followersCountButton setCountButtonType: TWPUserProfileCountButtonTypeFollowers ];
    [ self.followingCountButton setCountButtonType: TWPUserProfileCountButtonTypeFollowing ];

    [ self setMinimumSizeInNib: self.frame.size ];
    [ self setTranslatesAutoresizingMaskIntoConstraints: NO ];
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
        [ self.websiteField setStringValue: self->_twitterUser.website.displayText ?: @"" ];

        [ self.tweetsCountButton setTwitterUser: self->_twitterUser ];
        [ self.followersCountButton setTwitterUser: self->_twitterUser ];
        [ self.followingCountButton setTwitterUser: self->_twitterUser ];

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