//
//  TWPKeychain.h
//  Twipoker
//
//  Created by Tong G. on 4/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

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