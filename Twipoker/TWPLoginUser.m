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

#import "TWPLoginUser.h"
#import "TWPLogin+TWPLoginUsersManager.h"

#pragma mark TWPLoginUser class
@implementation TWPLoginUser

@synthesize userName = _userName;
@synthesize userID = _userID;
@synthesize OAuthToken = _OAuthToken;
@synthesize OAuthTokenSecret = _OAuthTokenSecret;

@dynamic twitterAPI;

#pragma mark Overrides
- ( NSString* ) description
    {
    return [ @{ @"User Name" : ( self->_userName ?: [ NSNull null ] )
              , @"User ID" : ( self->_userID ?: [ NSNull null ] )
              , @"OAuth Token" : ( self->_OAuthToken ?: [ NSNull null ] )
              , @"OAuth Token Secret" : ( self->_OAuthTokenSecret ?: [ NSNull null ] )
              } description ];
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( _Object == self )
        return YES;

    if ( [ _Object isKindOfClass: [ TWPLoginUser class ] ] )
        return [ self isEqualToLoginUser: ( TWPLoginUser* )_Object ];

    return [ super isEqual: _Object ];
    }

#pragma mark Accessors
- ( STTwitterAPI* ) twitterAPI
    {
    STTwitterAPI* newAPI = [ STTwitterAPI twitterAPIWithOAuthConsumerName: TWPConsumerName
                                                              consumerKey: TWPConsumerKey
                                                           consumerSecret: TWPConsumerSecret
                                                               oauthToken: self->_OAuthToken
                                                         oauthTokenSecret: self->_OAuthTokenSecret ];
    [ newAPI setUserName: self->_userName ];

    return newAPI;
    }

#pragma mark Comparing
- ( BOOL ) isEqualToLoginUser: ( TWPLoginUser* )_AnotherLoginUser
    {
    if ( _AnotherLoginUser == self )
        return YES;

    return [ self.userID isEqualToString: _AnotherLoginUser.userID ]
                && [ self.OAuthToken isEqualToString: _AnotherLoginUser.OAuthToken ]
                && [ self.OAuthTokenSecret isEqualToString: _AnotherLoginUser.OAuthTokenSecret ];
    }

#pragma mark Conforms to <NSCopying>
- ( instancetype ) copyWithZone: ( NSZone* )_Zone
    {
    TWPLoginUser* newLoginUser = [ TWPLoginUser _loginUserWithUserID: [ self->_userID copy ]
                                                            userName: [ self->_userName copy ]
                                                    OAuthAccessToken: [ self->_OAuthToken copy ]
                                              OAuthAccessTokenSecret: [ self->_OAuthTokenSecret copy ] ];
    return newLoginUser;
    }

@end // TWPLoginUser class

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