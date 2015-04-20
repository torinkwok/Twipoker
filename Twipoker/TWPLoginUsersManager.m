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

#import <objc/message.h>

#import "TWPLoginUsersManager.h"
#import "TWPLogin+TWPLoginUsersManager.h"

// User Defauls Keys
NSString* const TWPUserDefaultsKeyCurrentLoginUser = @"home.bedroom.TongGuo.Twipoker.UserDefaults.CurrentLoginUser";
NSString* const TWPUserDefaultsKeyAllLoginUsers = @"home.bedroom.TongGuo.Twipoker.UserDefaults.AllLoginUsers";

// Notification Names
NSString* const TWPTwipokerDidFinishLoginNotification = @"home.bedroom.TongGuo.Twipoker.Notif.DidFinishLogin";

// Notification User Info Keys
NSString* const TWPNewLoginUserUserInfoKey = @"home.bedroom.TongGuo.Twipoker.UserInfoKeys.NewLoginUser";

@implementation TWPLoginUsersManager
    {
    NSMutableArray __strong* _allLoginUserIDs;
    NSMutableArray __strong* _allLoginUsers;

    NSString       __strong* _currentLoginUserID;
    TWPLoginUser   __strong* _currentLoginUser;
    }

@dynamic currentLoginUser;

#pragma mark Initialization
// Returns the shared user manager object for the process.
+ ( instancetype ) sharedManager
    {
    return [ [ [ self class ] alloc ] init ];
    }

TWPLoginUsersManager static __strong* sSharedManager = nil;
- ( instancetype ) init
    {
    if ( !sSharedManager )
        {
        if ( self = [ super init ] )
            {
            // Awake from user defaults database
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];

            // Retrieve the IDs of all login users.
            if ( !( self->_allLoginUserIDs = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: TWPUserDefaultsKeyAllLoginUsers ] mutableCopy ] ) )
                // self->_allLoginUserIDs should not be nil
                self->_allLoginUserIDs = [ NSMutableArray array ];

            // self->_allLoginUsers should not be nil, either
            self->_allLoginUsers = [ NSMutableArray array ];
            NSMutableArray* invalidIDs = [ NSMutableArray array ];
            for ( NSString* _UserID in self->_allLoginUserIDs )
                {
                NSError* error = nil;
                TWPLoginUser* loginUser = [ TWPLoginUser _loginUserWithUserID: _UserID error: &error ];

                if ( loginUser )
                    [ self->_allLoginUsers addObject: loginUser ];
                else
                    {
                    [ invalidIDs addObject: _UserID ];
                    TWPPrintNSErrorForLog( error );
                    }
                }

            if ( invalidIDs.count > 0 )
                {
                [ self->_allLoginUserIDs removeObjectsInArray: invalidIDs ];
                [ [ NSUserDefaults standardUserDefaults ] setObject: self->_allLoginUserIDs forKey: TWPUserDefaultsKeyAllLoginUsers ];
                }

            if ( ( self->_currentLoginUserID = [ [ NSUserDefaults standardUserDefaults ] objectForKey: TWPUserDefaultsKeyCurrentLoginUser ] ) )
                {
                if ( !( self->_currentLoginUser = [ self retrieveUserWithUserID: self->_currentLoginUserID ] ) )
                    {
                    self->_currentLoginUserID = nil;
                    [ [ NSUserDefaults standardUserDefaults ] removeObjectForKey: TWPUserDefaultsKeyCurrentLoginUser ];
                    }
                }

            sSharedManager = self;
            }
        }

    return sSharedManager;
    }

#pragma mark Handling Users
// Get the current login user.
- ( TWPLoginUser* ) currentLoginUser
    {
    return self->_currentLoginUser;
    }

// Set the current login user.
- ( void ) setCurrentLoginUser: ( TWPLoginUser* )_User
    {
    if ( _User && ![ _User isEqualToLoginUser: self->_currentLoginUser ] )
        {
        self->_currentLoginUserID = _User.userID;
        self->_currentLoginUser = _User;

        [ [ NSUserDefaults standardUserDefaults ] setObject: self->_currentLoginUserID forKey: TWPUserDefaultsKeyCurrentLoginUser ];
        }
    }

// Create a login user by retrieving OAuth token pair from current default keychain
// based on the given user id (_UserID is used for account name).
- ( TWPLoginUser* ) retrieveUserWithUserID: ( NSString* )_UserID
    {
    TWPLoginUser* matchedLoginUser = nil;

    for ( TWPLoginUser* _LoginUser in self->_allLoginUsers )
        if ( [ _LoginUser.userID isEqualToString: _UserID ] )
            matchedLoginUser = _LoginUser;

    return matchedLoginUser;
    }

- ( STTwitterAPI* ) createUserByFetchingPIN: ( NSString* )_ScreenName
                                      error: ( NSError** )_Error;
    {
    NSError __strong __block* error = nil;
    STTwitterAPI* newTwitterAPI = [ STTwitterAPI twitterAPIWithOAuthConsumerName: TWPConsumerName
                                                                     consumerKey: TWPConsumerKey
                                                                  consumerSecret: TWPConsumerSecret ];
    // TODO: Waiting for handle the boundary conditions
    [ newTwitterAPI postTokenRequest:
        ^( NSURL* _URL, NSString* _OAuthToken )
            {
            [ [ NSWorkspace sharedWorkspace ] openURL: _URL ];
            }
      authenticateInsteadOfAuthorize: NO
                          forceLogin: @YES
                          screenName: _ScreenName
                       oauthCallback: @"oob"
                          errorBlock: ^( NSError* _Error )
                                        {
                                        error = _Error;
                                        } ];
    if ( _Error && error )
        *_Error = [ error copy ];

    return newTwitterAPI;
    }

- ( TWPLoginUser* ) createUserWithPIN: ( NSString* )_PIN
                uncompletedTwitterAPI: ( STTwitterAPI* )_UncompletedTwitterAPI
                                error: ( NSError** )_Error
    {
    NSError      __strong __block* error = nil;
    TWPLoginUser __strong __block* newLoginUser = nil;

    [ _UncompletedTwitterAPI postAccessTokenRequestWithPIN: _PIN
                                              successBlock:
        ^( NSString* _OAuthToken, NSString* _OAuthTokenSecret, NSString* _UserID, NSString* _ScreenName )
            {
            newLoginUser = [ [ TWPLoginUsersManager sharedManager ]
                createUserWithUserID: _UserID userName: _ScreenName OAuthToken: _OAuthToken OAuthTokenSecret: _OAuthTokenSecret ];
            }
                                                errorBlock: ^( NSError* _Error )
                                                                {
                                                                error = _Error;
                                                                } ];
    if ( newLoginUser )
        [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerDidFinishLoginNotification
                                                               object: nil
                                                             userInfo: @{ TWPNewLoginUserUserInfoKey : newLoginUser } ];
    if ( _Error && error )
        *_Error = [ error copy ];

    return newLoginUser;
    }

// Create a login user with given _UserID, _UserName, _OAuthToken,_OAuthTokenSecret.
// This method will not access the current default keychain automatically.
- ( TWPLoginUser* ) createUserWithUserID: ( NSString* )_UserID
                                userName: ( NSString* )_UserName
                              OAuthToken: ( NSString* )_OAuthToken
                        OAuthTokenSecret: ( NSString* )_OAuthTokenSecret
    {
    NSError* error = nil;
    TWPLoginUser* newLoginUser = nil;

    if ( ![ self->_allLoginUserIDs containsObject: _UserID ] )
        {
        newLoginUser = [ TWPLoginUser _loginUserWithUserID: _UserID
                                                  userName: _UserName
                                          OAuthAccessToken: _OAuthToken
                                    OAuthAccessTokenSecret: _OAuthTokenSecret ];
        if ( newLoginUser )
            {
            [ self->_allLoginUserIDs addObject: _UserID ];
            [ self->_allLoginUsers addObject: newLoginUser ];

            [ [ NSUserDefaults standardUserDefaults ] setObject: self->_allLoginUserIDs forKey: TWPUserDefaultsKeyAllLoginUsers ];

            [ newLoginUser _permanentSecret: &error ];
            TWPPrintNSErrorForLog( error );
            }
        }
    else
        newLoginUser = [ self retrieveUserWithUserID: _UserID ];

    if ( !self->_currentLoginUserID || !self->_currentLoginUser )
        self.currentLoginUser = newLoginUser;

    return newLoginUser;
    }

// Create a login user with given _UserID, _OAuthToken,_OAuthTokenSecret.
// This method will not access the current default keychain automatically.
- ( TWPLoginUser* ) createUserWithUserID: ( NSString* )_UserID
                              OAuthToken: ( NSString* )_OAuthToken
                        OAuthTokenSecret: ( NSString* )_OAuthTokenSecret
    {
    return [ self createUserWithUserID: _UserID
                              userName: nil
                            OAuthToken: _OAuthToken
                      OAuthTokenSecret: _OAuthTokenSecret ];
    }

// Get the copies of all login users.
- ( NSArray* ) copiesOfAllLoginUsers
    {
    NSMutableArray* copiedAllUsers = [ NSMutableArray array ];

    TWPLoginUser* copy = nil;
    for ( TWPLoginUser* _LoginUser in self->_allLoginUsers )
        if ( ( copy = [ _LoginUser copy ] ) )
            [ copiedAllUsers addObject: copy ];

    return [ copiedAllUsers copy ];
    }

// Remove all login users.
- ( void ) removeAllLoginUsers
    {
    [ self->_allLoginUsers removeAllObjects ];
    [ self->_allLoginUserIDs removeAllObjects ];
    [ [ NSUserDefaults standardUserDefaults ] setObject: self->_allLoginUserIDs forKey: TWPUserDefaultsKeyAllLoginUsers ];

    self->_currentLoginUser = nil;
    self->_currentLoginUserID = nil;
    [ [ NSUserDefaults standardUserDefaults ] removeObjectForKey: TWPUserDefaultsKeyCurrentLoginUser ];
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