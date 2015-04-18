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

#import "TWPUserManager.h"

@interface TWPUser ()

- ( instancetype ) initWithUserName: ( NSString* )_UserName
                             userID: ( NSString* )_UserID
                         OAuthToken: ( NSString* )_OAuthTokenString
                   OAuthTokenSecret: ( NSString* )_OAuthTokenSecretString;

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                       OAuthToken: ( NSString* )_OAuthTokenString
                 OAuthTokenSecret: ( NSString* )_OAuthTokenSecretString;

@end // TWPUser + Private

#pragma mark TWPUser class
@implementation TWPUser : NSObject

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

#pragma mark Initialization
- ( instancetype ) initWithUserName: ( NSString* )_UserName
                             userID: ( NSString* )_UserID
                         OAuthToken: ( NSString* )_OAuthTokenString
                   OAuthTokenSecret: ( NSString* )_OAuthTokenSecretString;
    {
    if ( !( _UserID.length > 0 && _OAuthTokenString.length > 0 && _OAuthTokenSecretString.length > 0 ) )
        return nil;

    if ( self = [ super init ] )
        {
        STTwitterAPI* newAPI = [ STTwitterAPI twitterAPIWithOAuthConsumerName: TWPConsumerName
                                                                  consumerKey: TWPConsumerKey
                                                               consumerSecret: TWPConsumerSecret
                                                                   oauthToken: _OAuthTokenString
                                                             oauthTokenSecret: _OAuthTokenSecretString ];
        self->_twitterAPI = newAPI;
        self->_twitterAPI.userName = _UserName;
        self->_twitterAPI.userID = _UserID;
        }

    return self;
    }

- ( instancetype ) initWithUserID: ( NSString* )_UserID
                       OAuthToken: ( NSString* )_OAuthTokenString
                 OAuthTokenSecret: ( NSString* )_OAuthTokenSecretString
    {
    return [ self initWithUserName: nil
                            userID: _UserID
                        OAuthToken: _OAuthTokenString
                  OAuthTokenSecret: _OAuthTokenSecretString ];
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

@end // TWPUser class

// ======================================================================================== //

NSString* const TWPUserDefaultsKeyCurrentUser = @"home.bedroom.TongGuo.Twipoker.UserDefaults.CurrentUser";
NSString* const TWPUserDefaultsKeyAllUsers = @"home.bedroom.TongGuo.Twipoker.UserDefaults.AllUsers";

@implementation TWPUserManager
    {
    // An array of `NSDictionary` objects
    // @[ @{ID, name}, @{ID, name}, @{ID, name} ... ]
    NSMutableArray __strong* _usersIDsInMemory;

    NSString __strong* _userIDInMemoryOfCurrentUser;
    TWPUser __strong* _currentUser;
    }

@dynamic currentUser;

#pragma mark Initialization
// Returns the shared user manager object for the process.
TWPUserManager static* s_sharedManager = nil;
+ ( instancetype ) sharedManager
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_sharedManager = [ [ TWPUserManager alloc ] init ];
                    } );

    return s_sharedManager;
    }

- ( instancetype ) init
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
        }

    return self;
    }

#pragma mark Handling Users
- ( TWPUser* ) currentUser
    {
    return self->_currentUser;
    }

- ( void ) setCurrentUser: ( TWPUser* )_User
    {
    if ( _User )
        {
        [ self _appendUserToUserDefaults: _User ];

        self->_userIDInMemoryOfCurrentUser = [ _User.userID copy ];
        [ [ NSUserDefaults standardUserDefaults ] setObject: self->_userIDInMemoryOfCurrentUser forKey: TWPUserDefaultsKeyCurrentUser ];

        self->_currentUser = _User;
        }
    else
        NSLog( @"The `TWPUser` parameters (%@) passed to the method was not valid", _User );
    }

- ( TWPUser* ) retrieveUserWithUserID: ( NSString* )_UserID
    {
    NSError* error = nil;
    TWPUser* user = nil;

    for ( NSString* userIDElem in self->_usersIDsInMemory )
        {
        if ( [ userIDElem isEqualToString: _UserID ] )
            {
            SecKeychainItemRef applicationPassphraseForGivenUserID =
                TWPFindApplicationPassphraseInDefaultKeychain( TwipokerAppID, _UserID, &error );

            if ( applicationPassphraseForGivenUserID )
                {
                NSData* cocoaDataWrappingOAuthTokenPair = TWPGetPassphrase( applicationPassphraseForGivenUserID );
                if ( cocoaDataWrappingOAuthTokenPair )
                    {
                    NSString* OAuthTokenPair = [ [ NSString alloc ] initWithData: cocoaDataWrappingOAuthTokenPair encoding: NSUTF8StringEncoding ];
                    NSArray* components = [ OAuthTokenPair componentsSeparatedByString: @"_" ];

                    if ( components.count == 2 )
                        user = [ [ TWPUser alloc ] initWithUserID: userIDElem
                                                       OAuthToken: components.firstObject
                                                 OAuthTokenSecret: components.lastObject ];
                    }

                CFRelease( applicationPassphraseForGivenUserID );
                }
            else
                {
                // If there is not a matched passphrase item (perhaps it has been deleted, moved or renamed)
                [ self->_usersIDsInMemory removeObject: userIDElem ];
                [ [ NSUserDefaults standardUserDefaults ] setObject: self->_usersIDsInMemory forKey: TWPUserDefaultsKeyAllUsers ];
                }

            break;
            }
        }

    return user;
    }

- ( TWPUser* ) createUserWithUserName: ( NSString* )_UserName
                               userID: ( NSString* )_UserID
                           OAuthToken: ( NSString* )_OAuthToken
                     OAuthTokenSecret: ( NSString* )_OAuthTokenSecret
    {
    TWPUser* newUser = nil;

    if ( ( newUser = [ [ TWPUser alloc ] initWithUserName: _UserName
                                                   userID: _UserID
                                               OAuthToken: _OAuthToken
                                         OAuthTokenSecret: _OAuthTokenSecret ] ) )
        {
        if ( ![ self _appendUserToUserDefaults: newUser ] )
            NSLog( @"Failed to store new user into user defaults" );

        if ( !self.currentUser )
            self.currentUser = newUser;
        }

    return newUser;
    }

- ( BOOL ) _appendUserToUserDefaults: ( TWPUser* )_User
    {
    BOOL isSuccess = NO;

    if ( _User && _User.userID )
        {
        if ( ![ self->_usersIDsInMemory containsObject: _User.userID ] )
            {
            [ self->_usersIDsInMemory addObject: _User.userID ];
            [ [ NSUserDefaults standardUserDefaults ] setObject: self->_usersIDsInMemory forKey: TWPUserDefaultsKeyAllUsers ];

            NSError* error = nil;
            SecKeychainItemRef secKeychainItem = NULL;
            if ( ( secKeychainItem = TWPAddApplicationPassphraseToDefaultKeychain
                    ( TwipokerAppID
                    , _User.userID
                    , [ NSString stringWithFormat: @"%@_%@", _User.OAuthToken, _User.OAuthTokenSecret ]
                    , &error
                    ) ) )
                {
                CFRelease( secKeychainItem );
                isSuccess = YES;
                }
            else
                // If the error domain and error code is NSOSStatusErrorDomain errSecDuplicateItem respectively,
                // we will still log this error, but it's generally safe to ignore it.
                TWPPrintNSErrorForLog( error );
            }
        else
            isSuccess = YES;
        }

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