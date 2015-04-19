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
    // @[ @{ID, name}, @{ID, name}, @{ID, name} ... ]
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

void TWPFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam )
    {
    if ( _ErrorParam )
        {
        CFStringRef cfErrorDesc = SecCopyErrorMessageString( _ResultCode, NULL );
        *_ErrorParam = [ [ NSError errorWithDomain: NSOSStatusErrorDomain
                                              code: _ResultCode
                                          userInfo: @{ NSLocalizedDescriptionKey : [ ( __bridge NSString* )cfErrorDesc copy ] }
                                                  ] copy ];
        CFRelease( cfErrorDesc );
        }
    }

// Retrieves a SecKeychainRef represented the current default keychain.
SecKeychainRef TWPCurrentDefaultKeychain( NSError** _Error )
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef secCurrentDefaultKeychain = NULL;

    if ( ( resultCode = SecKeychainCopyDefault( &secCurrentDefaultKeychain ) ) != errSecSuccess )
        TWPFillErrorParamWithSecErrorCode( resultCode, _Error );

    return secCurrentDefaultKeychain;
    }

// Adds a new generic passphrase to the keychain represented by receiver.
SecKeychainItemRef TWPAddApplicationPassphraseToDefaultKeychain( NSString* _ServiceName
                                                               , NSString* _AccountName
                                                               , NSString* _Passphrase
                                                               , NSError** _Error
                                                               )
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainItemRef secKeychainItem = NULL;
    SecKeychainRef secDefaultKeychain = TWPCurrentDefaultKeychain( _Error );
    if ( secDefaultKeychain )
        {
        // As described in documentation:
        // SecKeychainAddGenericPassword() function automatically calls the SecKeychainUnlock () function
        // to display the Unlock Keychain dialog box if the keychain is currently locked.
        // Adding.... Beep Beep Beep...
        if ( ( resultCode = SecKeychainAddGenericPassword( secDefaultKeychain
                                                         , ( UInt32 )_ServiceName.length, _ServiceName.UTF8String
                                                         , ( UInt32 )_AccountName.length, _AccountName.UTF8String
                                                         , ( UInt32 )_Passphrase.length, _Passphrase.UTF8String
                                                         , &secKeychainItem
                                                         ) ) != errSecSuccess )
            TWPFillErrorParamWithSecErrorCode( resultCode, _Error );

        CFRelease( secDefaultKeychain );
        }

    return secKeychainItem;
    }

SecKeychainItemRef TWPFindApplicationPassphraseInDefaultKeychain( NSString* _ServiceName
                                                                , NSString* _AccountName
                                                                , NSError** _Error )
    {
    SecKeychainRef secDefaultKeychain = TWPCurrentDefaultKeychain( _Error );

    OSStatus resultCode = errSecSuccess;
    NSMutableDictionary* finalQueryDictionary =
        [ NSMutableDictionary dictionaryWithObjectsAndKeys:
              ( __bridge id )kSecClassGenericPassword, ( __bridge id )kSecClass
            , _ServiceName, ( __bridge id )kSecAttrService
            , _AccountName , ( __bridge id )kSecAttrAccount
            , ( __bridge id )kSecMatchLimitOne, ( __bridge id )kSecMatchLimit
            , @[ ( __bridge id )secDefaultKeychain ], ( __bridge id )kSecMatchSearchList
            , ( __bridge id )kCFBooleanTrue, ( __bridge id )kSecReturnRef
            , nil ];

    CFTypeRef secMatchedItem = NULL;
    if ( ( resultCode = SecItemCopyMatching( ( __bridge CFDictionaryRef )finalQueryDictionary
                                           , &secMatchedItem ) ) != errSecSuccess )
        if ( resultCode != errSecItemNotFound )
            TWPFillErrorParamWithSecErrorCode( resultCode, _Error );

    return ( SecKeychainItemRef )secMatchedItem;
    }

NSData* TWPGetPassphrase( SecKeychainItemRef _KeychainItemRef )
    {
    OSStatus resultCode = errSecSuccess;
    NSData* passphraseData = nil;

    UInt32 lengthOfSecretData = 0;
    void* secretData = NULL;

    // Get the secret data
    resultCode = SecKeychainItemCopyAttributesAndData( _KeychainItemRef, NULL, NULL, NULL
                                                     , &lengthOfSecretData, &secretData );
    if ( resultCode == errSecSuccess )
        {
        passphraseData = [ NSData dataWithBytes: secretData length: lengthOfSecretData ];
        SecKeychainItemFreeAttributesAndData( NULL, secretData );
        }

    return passphraseData;
    }

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