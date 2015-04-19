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
NSString* const TWPUserDefaultsKeyCurrentUser = @"home.bedroom.TongGuo.Twipoker.UserDefaults.CurrentUser";
NSString* const TWPUserDefaultsKeyAllUsers = @"home.bedroom.TongGuo.Twipoker.UserDefaults.AllUsers";

// Notification Names
NSString* const TWPTwipokerDidFinishLoginNotification = @"home.bedroom.TongGuo.Twipoker.Notif.DidFinishLogin";

// Notification User Info Keys
NSString* const TWPNewUserUserInfoKey = @"home.bedroom.TongGuo.Twipoker.UserInfoKeys.NewUser";

@implementation TWPLoginUsersManager
    {
    NSMutableDictionary* _loginUsers;

    // An array of `NSDictionary` objects
    // @[ ID, ID, ID, ID, ... ]
    NSMutableArray __strong* _usersIDsInMemory;

    NSString __strong* _userIDInMemoryOfCurrentUser;
    TWPLoginUser __strong* _currentUser;
    }

@dynamic currentUser;

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
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];

            // Instantiate self->_usersInMemory from user defaults.
            // Create an empty array for it if the contents stored in user defaults can't be parsed into an mutable array
            if ( !( self->_usersIDsInMemory = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: TWPUserDefaultsKeyAllUsers ] mutableCopy ] ) )
                self->_usersIDsInMemory = [ NSMutableArray array ];

            self->_userIDInMemoryOfCurrentUser = [ [ NSUserDefaults standardUserDefaults ] objectForKey: TWPUserDefaultsKeyCurrentUser ];

            if ( self->_userIDInMemoryOfCurrentUser )
                {
                if ( !( self->_currentUser = [ self retrieveUserWithUserID: self->_userIDInMemoryOfCurrentUser ] ) )
                    {
                    self->_userIDInMemoryOfCurrentUser = nil;
                    [ [ NSUserDefaults standardUserDefaults ] removeObjectForKey: TWPUserDefaultsKeyCurrentUser ];
                    }
                }

            sSharedManager = self;
            }
        }

    return sSharedManager;
    }

#pragma mark Handling Users
- ( TWPLoginUser* ) currentUser
    {
    return self->_currentUser;
    }

- ( void ) setCurrentUser: ( TWPLoginUser* )_User
    {
    // TODO;
    }

- ( TWPLoginUser* ) retrieveUserWithUserID: ( NSString* )_UserID
    {
    TWPLoginUser* loginUser = nil;

    // TODO:

    return loginUser;
    }

- ( TWPLoginUser* ) createUserWithUserName: ( NSString* )_UserName
                               userID: ( NSString* )_UserID
                           OAuthToken: ( NSString* )_OAuthToken
                     OAuthTokenSecret: ( NSString* )_OAuthTokenSecret
    {
    TWPLoginUser* loginUser = nil;

    // TODO:

    return loginUser;
    }

- ( BOOL ) _appendUserToUserDefaults: ( TWPLoginUser* )_User
    {
    BOOL isSuccess = NO;

    // TODO:

    return isSuccess;
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