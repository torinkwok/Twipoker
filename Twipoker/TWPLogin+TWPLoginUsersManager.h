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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

@import Foundation;

#import "TWPLoginUser.h"

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