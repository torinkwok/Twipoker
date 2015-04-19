//
//  TWPLogin+TWPLoginUsersManager.h
//  Twipoker
//
//  Created by Tong G. on 4/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

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
