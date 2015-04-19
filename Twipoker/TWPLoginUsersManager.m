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

//@synthesize allLoginUsers;
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
- ( TWPLoginUser* ) currentLoginUser
    {
    return self->_currentLoginUser;
    }

- ( void ) setCurrentLoginUser: ( TWPLoginUser* )_User
    {
    if ( _User && ![ _User isEqualToLoginUser: self->_currentLoginUser ] )
        {
        self->_currentLoginUserID = _User.userID;
        self->_currentLoginUser = _User;

        [ [ NSUserDefaults standardUserDefaults ] setObject: self->_currentLoginUserID forKey: TWPUserDefaultsKeyCurrentLoginUser ];
        }
    }

- ( TWPLoginUser* ) retrieveUserWithUserID: ( NSString* )_UserID
    {
    TWPLoginUser* matchedLoginUser = nil;

    for ( TWPLoginUser* _LoginUser in self->_allLoginUsers )
        if ( [ _LoginUser.userID isEqualToString: _UserID ] )
            matchedLoginUser = _LoginUser;

    return matchedLoginUser;
    }

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

- ( TWPLoginUser* ) createUserWithUserID: ( NSString* )_UserID
                              OAuthToken: ( NSString* )_OAuthToken
                        OAuthTokenSecret: ( NSString* )_OAuthTokenSecret
    {
    return [ self createUserWithUserID: _UserID
                              userName: nil
                            OAuthToken: _OAuthToken
                      OAuthTokenSecret: _OAuthTokenSecret ];
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