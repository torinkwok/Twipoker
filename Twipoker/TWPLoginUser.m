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
#import "TWPLoginUsersManager.h"

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

#pragma mark TWPLoginUser + TWPLoginUsersManager
@implementation TWPLoginUser ( TWPLoginUsersManager )

+ ( instancetype ) _loginUserWithUserID: ( NSString* )_UserID
                                  error: ( NSError** )_Error;
    {
    return [ [ [ self class ] alloc ] initWithUserID: _UserID error: _Error ];
    }

+ ( instancetype ) _loginUserWithUserID: ( NSString* )_UserID
                               userName: ( NSString* )_UserName
                       OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
                 OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString
    {
    return [ [ [ self class ] alloc ] initWithUserID: _UserID
                                            userName: _UserName
                                    OAuthAccessToken: _OAuthAccessTokenString
                              OAuthAccessTokenSecret: _OAuthAccessTokenSecretString ];
    }

+ ( instancetype ) _loginUserWithUserID: ( NSString* )_UserID
                       OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
                 OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString
    {
    return [ [ [ self class ] alloc ] initWithUserID: _UserID
                                    OAuthAccessToken: _OAuthAccessTokenString
                              OAuthAccessTokenSecret: _OAuthAccessTokenSecretString ];
    }

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                            error: ( NSError** )_Error
    {
    TWPLoginUser* newLoginUser = nil;

    SecKeychainItemRef applicationPassphraseForGivenUserID =
        TWPFindApplicationPassphraseInDefaultKeychain( TwipokerAppID, _UserID, _Error );

    if ( applicationPassphraseForGivenUserID )
        {
        NSData* cocoaDataWrappingOAuthTokenPair = TWPGetPassphrase( applicationPassphraseForGivenUserID );
        if ( cocoaDataWrappingOAuthTokenPair )
            {
            NSString* OAuthTokenPair = [ [ NSString alloc ] initWithData: cocoaDataWrappingOAuthTokenPair encoding: NSUTF8StringEncoding ];
            NSArray* components = [ OAuthTokenPair componentsSeparatedByString: @"_" ];

            if ( components.count == 2 )
                newLoginUser = [ [ [ self class ] alloc ] initWithUserID: _UserID
                                                        OAuthAccessToken: components.firstObject
                                                  OAuthAccessTokenSecret: components.lastObject ];
            }

        CFRelease( applicationPassphraseForGivenUserID );
        }

    return newLoginUser;
    }

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                         userName: ( NSString* )_UserName
                 OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
           OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString
    {
    if ( !( _UserID.length > 0 && _OAuthAccessTokenString.length > 0 && _OAuthAccessTokenSecretString.length > 0 ) )
        return nil;

    if ( self = [ super init ] )
        {
        STTwitterAPI* newAPI = [ STTwitterAPI twitterAPIWithOAuthConsumerName: TWPConsumerName
                                                                  consumerKey: TWPConsumerKey
                                                               consumerSecret: TWPConsumerSecret
                                                                   oauthToken: _OAuthAccessTokenString
                                                             oauthTokenSecret: _OAuthAccessTokenSecretString ];
        self->_twitterAPI = newAPI;
        self->_twitterAPI.userName = _UserName;
        self->_twitterAPI.userID = _UserID;
        }

    return self;
    }

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                 OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
           OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString;
    {
    return [ self initWithUserID: _UserID
                        userName: nil
                OAuthAccessToken: _OAuthAccessTokenString
          OAuthAccessTokenSecret: _OAuthAccessTokenSecretString ];
    }

- ( BOOL ) _permanentSecret: ( NSError** )_Error
    {
    BOOL isSuccess = NO;

    SecKeychainItemRef secKeychainItem = NULL;
    if ( ( secKeychainItem = TWPAddApplicationPassphraseToDefaultKeychain
            ( TwipokerAppID
            , self.userID
            , [ NSString stringWithFormat: @"%@_%@", self.OAuthToken, self.OAuthTokenSecret ]
            , _Error
            ) ) )
        {
        CFRelease( secKeychainItem );
        isSuccess = YES;
        }

    return isSuccess;
    }

@end // TWPLoginUser + TWPLoginUsersManager

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