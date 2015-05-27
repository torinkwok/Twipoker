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

#import "TWPDirectMessagesSession.h"
#import "TWPDirectMessagesCoordinator.h"

@implementation TWPDirectMessagesSession

@synthesize allDirectMessages = _DMs;
@synthesize otherSideUser = _otherSideUser;

#pragma mark Initializations
+ ( instancetype ) sessionWithOtherSideUser: ( OTCTwitterUser* )_OtherSideUser
    {
    return [ [ [ self class ] alloc ] initWithOtherSideUser: _OtherSideUser ];
    }

- ( instancetype ) initWithOtherSideUser: ( OTCTwitterUser* )_OtherSideUser
    {
    if ( self = [ super init ] )
        {
        self->_DMs = [ NSMutableArray array ];
        self->_otherSideUser = _OtherSideUser;

        // Retrieve the direct messages sent/received by the other side user
        NSArray* allDMs =  [ [ TWPDirectMessagesCoordinator defaultCenter ] allDMs ];
        for ( OTCDirectMessage* _DM in allDMs )
            if ( [ self->_otherSideUser isEqualToUser: _DM.sender ]
                    || [ self->_otherSideUser isEqualToUser: _DM.recipient ] )
                [ _DMs addObject: _DM ];

//        // Retrieve the direct messages sent by the other side user
//        NSArray* receivedDMs = [ [ TWPDirectMessagesCoordinator defaultCenter ] receivedDMs ];
//        for ( OTCDirectMessage* _DM in receivedDMs )
//            if ( [ self->_otherSideUser isEqualToUser: _DM.sender ] )
//                [ _DMs addObject: _DM ];
//
//        // Retrieve the direct messages sent by me and received by other side user
//        NSArray* sentDMs = [ [ TWPDirectMessagesCoordinator defaultCenter ] sentDMs ];
//        for ( OTCDirectMessage* _DM in sentDMs )
//            if ( [ self->_otherSideUser isEqualToUser: _DM.recipient ] )
//                [ _DMs addObject: _DM ];

        [ self->_DMs sortWithOptions: NSSortConcurrent
                     usingComparator:
            ( NSComparator )^( OTCDirectMessage* _LhsDM, OTCDirectMessage* _RhsDM )
                {
                return _LhsDM.tweetID < _RhsDM.tweetID;
                } ];
        }

    return self;
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