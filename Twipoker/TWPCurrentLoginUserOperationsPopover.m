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

#import "TWPCurrentLoginUserOperationsPopover.h"
#import "TWPCurrentLoginUserOperationsViewController.h"

// TWPCurrentLoginUserOperationsPopover class
@implementation TWPCurrentLoginUserOperationsPopover

@dynamic twitterUser;

#pragma mark Initializations
+ ( instancetype ) popoverWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                                 delegate: ( id <TWPCurrentLoginUserOperationsPopoverDelegate> )_Delegate
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser delegate: _Delegate ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
                              delegate: ( id <TWPCurrentLoginUserOperationsPopoverDelegate> )_Delegate
    {
    if ( self = [ super init ] )
        {
        self->_twitterUser = _TwitterUser;

        TWPCurrentLoginUserOperationsViewController* operationsViewController = [ TWPCurrentLoginUserOperationsViewController operationsViewController ];
        [ self setContentViewController: operationsViewController ];
        [ self setDelegate: _Delegate ];
        [ self setBehavior: NSPopoverBehaviorTransient ];
        }

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    self->_twitterUser = _TwitterUser;
    }

- ( OTCTwitterUser* ) twitterUser
    {
    return self->_twitterUser;
    }

@end // TWPCurrentLoginUserOperationsPopover class

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