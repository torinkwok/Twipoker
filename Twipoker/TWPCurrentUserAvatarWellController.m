//
//  TWPCurrentUserAvatarWellController.m
//  Twipoker
//
//  Created by Tong G. on 7/17/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import "TWPCurrentUserAvatarWellController.h"

@interface TWPCurrentUserAvatarWellController ()
- ( TWPUserAvatarWell* ) _userAvatarWell;
@end

@implementation TWPCurrentUserAvatarWellController

- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    [ [ self _userAvatarWell ] setTwitterUser: _TwitterUser ];
    }

- ( TWPUserAvatarWell* ) _userAvatarWell
    {
    return ( TWPUserAvatarWell* )( [ self view ] );
    }

@end
