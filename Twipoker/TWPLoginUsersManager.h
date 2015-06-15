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

@import Foundation;

#import "TWPLoginUser.h"

@class TWPLoginUser;
@protocol TWPLoginUsersManagerDelegate;

/** The `TWPLoginUsersManager` class enables us to manage all of the Twipoker users.
  */
@interface TWPLoginUsersManager : NSObject
    {
@private
    STTwitterAPI __strong __block* _tmpTwitterAPI;
    }

#pragma mark Singleton Object
// Returns the shared user manager object for the process.
+ ( instancetype ) sharedManager;

#pragma mark Handling Users
@property ( assign, readonly ) NSUInteger countOfLoginUsers;

// Set and get the current login user.
@property ( strong, readwrite ) TWPLoginUser* currentLoginUser;

// Fetch PIN code by opening the authorize URL with the default Web Browser
- ( void ) fetchPINByLaunchingDefaultWebBrowser: ( NSString* )_ScreenName
                                     errorBlock: ( void (^)( NSError* _Error ) )_ErrorBlock;

// Create a new login user by fetching the OAuth access token pair with given PIN code,
// which was obtained by invoking `fetchPINByLaunchingDefaultWebBrowser:errorBlock:`.
- ( void ) createUserWithPIN: ( NSString* )_PIN
                successBlock: ( void (^)( TWPLoginUser* _NewLoginUser ) )_SuccessBlock
                  errorBlock: ( void (^)( NSError* _Error ) )_ErrorBlock;

// Create a login user by retrieving OAuth token pair from current default keychain
// based on the given user id (_UserID is used for account name).
- ( TWPLoginUser* ) retrieveUserWithUserID: ( NSString* )_UserID;

// Remove the login user identified by _UserID.
- ( BOOL ) removeUserWithUserID: ( NSString* )_UserID;

// Create a login user with given _UserID, _UserName, _OAuthToken,_OAuthTokenSecret.
// This method will not access the current default keychain automatically.
- ( TWPLoginUser* ) createUserWithUserID: ( NSString* )_UserID
                                userName: ( NSString* )_UserName
                              OAuthToken: ( NSString* )_OAuthToken
                        OAuthTokenSecret: ( NSString* )_OAuthTokenSecret;

// Create a login user with given _UserID, _OAuthToken,_OAuthTokenSecret.
// This method will not access the current default keychain automatically.
- ( TWPLoginUser* ) createUserWithUserID: ( NSString* )_UserID
                              OAuthToken: ( NSString* )_OAuthToken
                        OAuthTokenSecret: ( NSString* )_OAuthTokenSecret;

// Get the copies of all login users.
- ( NSArray* ) copiesOfAllLoginUsers;

// Remove all login users.
- ( void ) removeAllLoginUsers;

@end

// User Defauls Keys
NSString extern* const TWPUserDefaultsKeyCurrentLoginUser;
NSString extern* const TWPUserDefaultsKeyAllLoginUsers;

// Notification Names
NSString extern* const TWPLoginUsersManagerDidFinishAddingNewLoginUser;
NSString extern* const TWPLoginUsersManagerDidFinishRemovingLoginUser;
NSString extern* const TWPLoginUsersManagerDidFinishUpdatingCurrentLoginUser;
NSString extern* const TWPLoginUsersManagerDidFinishRemovingAllLoginUsers;

// Notification User Info Keys
NSString extern* const TWPNewLoginUserUserInfoKey;
NSString extern* const TWPRemovedLoginUserUserInfoKey;
NSString extern* const TWPNumberOfRemainingLoginUsersUserInfoKey;

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