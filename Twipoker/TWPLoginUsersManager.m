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
NSString* const TWPLoginUsersManagerDidFinishAddingNewLoginUser = @"home.bedroom.TongGuo.Twipoker.TWPLoginUsersManager.Notif.DidFinishAddingNewLoginUser";
NSString* const TWPLoginUsersManagerDidFinishRemovingLoginUser = @"home.bedroom.TongGuo.Twipoker.TWPLoginUsersManager.Notif.DidFinishRemovingLoginUser";
NSString* const TWPLoginUsersManagerDidFinishUpdatingCurrentLoginUser = @"home.bedroom.TongGuo.Twipoker.TWPLoginUsersManager.Notif.DidFinishUpdatingCurrentLoginUser";
NSString* const TWPLoginUsersManagerDidFinishRemovingAllLoginUsers = @"home.bedroom.TongGuo.Twipoker.TWPLoginUsersManager.Notif.DidRemovingAllLoginUsers";

// Notification User Info Keys
NSString* const TWPNewLoginUserUserInfoKey = @"home.bedroom.TongGuo.Twipoker.UserInfoKeys.NewLoginUser";
NSString* const TWPRemovedLoginUserUserInfoKey = @"home.bedroom.TongGuo.Twipoker.UserInfoKeys.RemovedLoginUser";
NSString* const TWPNumberOfRemainingLoginUsersUserInfoKey = @"home.bedroom.TongGuo.Twipoker.UserInfoKeys.NumberOfRemainingLoginUsersUserInfoKey";

@implementation TWPLoginUsersManager
    {
    NSMutableArray __strong* _allLoginUserIDs;
    NSMutableArray __strong* _allLoginUsers;

    NSString       __strong* _currentLoginUserID;
    TWPLoginUser   __strong* _currentLoginUser;
    }

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
@dynamic countOfLoginUsers;
@dynamic currentLoginUser;

// Get the current login user.
- ( TWPLoginUser* ) currentLoginUser
    {
    return self->_currentLoginUser;
    }

- ( NSUInteger ) countOfLoginUsers
    {
    return self->_allLoginUsers.count;
    }

// Set the current login user.
- ( void ) setCurrentLoginUser: ( TWPLoginUser* )_User
    {
    if ( ![ _User isEqualToLoginUser: self->_currentLoginUser ] )
        {
        self->_currentLoginUserID = _User.userID;
        self->_currentLoginUser = _User;

        if ( _User )
            [ [ NSUserDefaults standardUserDefaults ] setObject: self->_currentLoginUserID forKey: TWPUserDefaultsKeyCurrentLoginUser ];
        else
            [ [ NSUserDefaults standardUserDefaults ] removeObjectForKey: TWPUserDefaultsKeyCurrentLoginUser ];

        [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPLoginUsersManagerDidFinishUpdatingCurrentLoginUser
                                                               object: self
                                                             userInfo: @{ TWPNewLoginUserUserInfoKey : self->_currentLoginUser ?: [ NSNull null ] } ];
        }
    }

// Fetch PIN code by opening the authorize URL with the default Web Browser
- ( void ) fetchPINByLaunchingDefaultWebBrowser: ( NSString* )_ScreenName
                                     errorBlock: ( void (^)( NSError* _Error ) )_ErrorBlock
    {
    self->_tmpTwitterAPI = [ STTwitterAPI twitterAPIWithOAuthConsumerName: TWPConsumerName
                                                              consumerKey: TWPConsumerKey
                                                           consumerSecret: TWPConsumerSecret ];
    // Obtain a pair of OAuth Request Token and secret
    // to request a PIN code which will be used for user authorization
    [ self->_tmpTwitterAPI postTokenRequest:
        ^( NSURL* _URL, NSString* _OAuthToken )
            {
            // The form of _URL is similar to:
            // https://api.twitter.com/oauth/authorize?oauth_callback_confirmed=true&oauth_token_secret=Qt8sA9YkmDn35HQ2cSLWT4Os73oEjxeJ&screen_name=@NSTongG&force_login=1&oauth_token=vCvhmhTkhhZaOjaMbqEWL06c1pfVEIUu

            // It consists of the following parts:
            // OAuth Request Token: vCvhmhTkhhZaOjaMbqEWL06c1pfVEIUu
            // OAuth Request Token Secret: Qt8sA9YkmDn35HQ2cSLWT4Os73oEjxeJ
            // Force Login: YES
            // Screen Name: @NSTongG
            // Confirmed: True

            // Open this URL with the current default Web Browser.
            // Users will find out the PIN code on the page to which _URL points.
            [ [ NSWorkspace sharedWorkspace ] openURL: _URL ];
            }
             authenticateInsteadOfAuthorize: NO
                                 forceLogin: @YES
                                 screenName: _ScreenName
                              oauthCallback: TWPOAuthCallbackOutOfBand
                                 errorBlock: ^( NSError* _Error ) { _ErrorBlock( _Error ); } ];
    }

// Create a new login user by fetching the OAuth access token pair with given PIN code,
// which was obtained by invoking `fetchPINByLaunchingDefaultWebBrowser:errorBlock:`.
- ( void ) createUserWithPIN: ( NSString* )_PIN
                successBlock: ( void (^)( TWPLoginUser* _NewLoginUser ) )_SuccessBlock
                  errorBlock: ( void (^)( NSError* _Error ) )_ErrorBlock
    {
    // _SuccessBlock must not be nil while the _ErrorBlock can be nil.
    // NSAssert( _SuccessBlock, @"Fatal error: Success block must not be nil" );
    [ self->_tmpTwitterAPI postAccessTokenRequestWithPIN: _PIN
                                            successBlock:
        ^( NSString* _OAuthToken, NSString* _OAuthTokenSecret, NSString* _UserID, NSString* _ScreenName )
            {
            self->_tmpTwitterAPI = nil;

            TWPLoginUser* newLoginUser = [ [ TWPLoginUsersManager sharedManager ]
                createUserWithUserID: _UserID userName: _ScreenName OAuthToken: _OAuthToken OAuthTokenSecret: _OAuthTokenSecret ];

            if ( _SuccessBlock )
                _SuccessBlock( newLoginUser );
            } errorBlock: ^( NSError* _Error ) { _ErrorBlock( _Error ); } ];
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

// Remove the login user identified by _UserID.
- ( BOOL ) removeUserWithUserID: ( NSString* )_UserID
    {
    BOOL isSuccess = NO;
    TWPLoginUser __strong* oldLoginUser = [ self retrieveUserWithUserID: _UserID ];

    if ( oldLoginUser )
        {
        [ self->_allLoginUserIDs removeObject: oldLoginUser.userID ];
        [ self->_allLoginUsers removeObject: oldLoginUser ];
        [ [ NSUserDefaults standardUserDefaults ] setObject: self->_allLoginUserIDs forKey: TWPUserDefaultsKeyAllLoginUsers ];

        if ( [ self.currentLoginUser isEqualToLoginUser: oldLoginUser ] )
            [ self setCurrentLoginUser: self->_allLoginUsers.firstObject ];

        [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPLoginUsersManagerDidFinishRemovingLoginUser
                                                               object: self
                                                             userInfo: @{ TWPRemovedLoginUserUserInfoKey : oldLoginUser
                                                                        , TWPNumberOfRemainingLoginUsersUserInfoKey : @( self->_allLoginUsers.count )
                                                                        } ];
        isSuccess = YES;
        }

    return isSuccess;
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

            [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPLoginUsersManagerDidFinishAddingNewLoginUser
                                                                   object: self
                                                                 userInfo: @{ TWPNewLoginUserUserInfoKey : newLoginUser } ];
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

    self.currentLoginUser = nil;

    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPLoginUsersManagerDidFinishRemovingAllLoginUsers
                                                           object: self
                                                         userInfo: nil ];
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