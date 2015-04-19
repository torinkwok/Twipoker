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

#import "TWPLoginUser.h"

#pragma mark TWPLoginUser class
@implementation TWPLoginUser

@dynamic userName;
@dynamic userID;
@dynamic OAuthToken;
@dynamic OAuthTokenSecret;

@synthesize twitterAPI = _twitterAPI;

#pragma mark Overrides
- ( NSString* ) description
    {
    return [ @{ @"User Name" : ( self.userName ?: [ NSNull null ] )
              , @"User ID" : ( self.userID ?: [ NSNull null ] )
              , @"OAuth Token" : ( self.OAuthToken ?: [ NSNull null ] )
              , @"OAuth Token Secret" : ( self.OAuthTokenSecret ?: [ NSNull null ] )
              } description ];
    }

#pragma mark Accessors
// Screen name of current user, '@' has been excluded.
- ( NSString* ) userName
    {
    return self->_twitterAPI.userName;
    }

// The string representation of unique identifier for this user.
- ( NSString* ) userID
    {
    return self->_twitterAPI.userID;
    }

// OAuth access token of this user. (Used for creating `twitterAPI`)
- ( NSString* ) OAuthToken
    {
    return self->_twitterAPI.oauthAccessToken;
    }

// OAuth access token secret of this user. (Used for creating `twitterAPI`)
- ( NSString* ) OAuthTokenSecret
    {
    return self->_twitterAPI.oauthAccessTokenSecret;
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