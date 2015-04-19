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

#import <Foundation/Foundation.h>

#import "TWPLoginUser.h"

@class TWPLoginUser;
@protocol TWPUserManagerDelegate;

// User Defauls Keys
NSString extern* const TWPUserDefaultsKeyCurrentUser;
NSString extern* const TWPUserDefaultsKeyAllUsers;

// Notification Names
NSString extern* const TWPTwipokerDidFinishLoginNotification;

// Notification User Info Keys
NSString extern* const TWPNewUserUserInfoKey;

/** The `TWPLoginUsersManager` class enables us to manage all of the Twipoker users.
  */
@interface TWPLoginUsersManager : NSObject

@property ( weak, readwrite ) IBOutlet id <TWPUserManagerDelegate> delegate;

@property ( strong, readonly ) NSDictionary* loginUsers;
@property ( strong, readwrite ) TWPLoginUser* currentUser;

#pragma mark Initialization
// Returns the shared user manager object for the process.
+ ( instancetype ) sharedManager;

#pragma mark Handling Users
// Create an user by retrieving OAuth token pair from current default keychain
// based on the given user id (_UserID is used for account name)
- ( TWPLoginUser* ) retrieveUserWithUserID: ( NSString* )_UserID;

- ( TWPLoginUser* ) createUserWithUserName: ( NSString* )_UserName
                               userID: ( NSString* )_UserID
                           OAuthToken: ( NSString* )_OAuthToken
                     OAuthTokenSecret: ( NSString* )_OAuthTokenSecret;

- ( NSArray* ) allUsers;
- ( void ) removeAllUsers;

@end

@protocol TWPUserManagerDelegate

@optional
// Sent by the default notification center immediately after a successful login
- ( void ) twipokerDidFinishLogin: ( NSNotification* )_Notif;

- ( void )        userManager: ( TWPLoginUsersManager* )_UserManager
    didFinishLoginWithNewUser: ( TWPLoginUser* )_NewUser;

@end

void TWPFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam );

// Retrieves a SecKeychainRef represented the current default keychain.
SecKeychainRef TWPCurrentDefaultKeychain( NSError** _Error );

// Adds a new generic passphrase to the keychain represented by receiver.
SecKeychainItemRef TWPAddApplicationPassphraseToDefaultKeychain( NSString* _ServiceName
                                                               , NSString* _AccountName
                                                               , NSString* _Passphrase
                                                               , NSError** _Error );

SecKeychainItemRef TWPFindApplicationPassphraseInDefaultKeychain( NSString* _ServiceName
                                                                , NSString* _AccountName
                                                                , NSError** _Error );

NSData* TWPGetPassphrase( SecKeychainItemRef _KeychainItemRef );

#pragma mark TWPLoginUser + TWPLoginUsersManager
@interface TWPLoginUser ( TWPLoginUsersManager )

+ ( instancetype ) _loginUserWithUserID: ( NSString* )_UserID error: ( NSError** )_Error;

+ ( instancetype ) _loginUserWithUserID: ( NSString* )_UserID
                               userName: ( NSString* )_UserName
                       OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
                 OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString;

+ ( instancetype ) _loginUserWithUserID: ( NSString* )_UserID
                       OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
                 OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString;

- ( instancetype ) initWithUserID: ( NSString* )_UserID error: ( NSError** )_Error;

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                         userName: ( NSString* )_UserName
                 OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
           OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString;

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                 OAuthAccessToken: ( NSString* )_OAuthAccessTokenString
           OAuthAccessTokenSecret: ( NSString* )_OAuthAccessTokenSecretString;

- ( BOOL ) _permanentSecret: ( NSError** )_Error;

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