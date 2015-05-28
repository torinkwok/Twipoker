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

#import "TWPDirectMessageSession.h"
#import "TWPDirectMessagesCoordinator.h"

@implementation TWPDirectMessageSession

@synthesize allDirectMessages = _DMs;
@synthesize otherSideUser = _otherSideUser;
@dynamic mostRecentMessage;

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
        [ self _loadMessages ];
        }

    return self;
    }

#pragma mark Accessors
- ( OTCDirectMessage* ) mostRecentMessage
    {
    return self->_DMs.firstObject;
    }

#pragma mark Comparing
- ( BOOL ) isEqualToSession: ( TWPDirectMessageSession* )_AnotherSession
    {
    if ( self == _AnotherSession )
        return YES;

    return [ self->_otherSideUser isEqualToUser: _AnotherSession.otherSideUser ];
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ TWPDirectMessageSession class ] ] )
        return [ self isEqualToSession: ( TWPDirectMessageSession* )_Object ];

    return [ super isEqual: _Object ];
    }

#pragma mark Reloading
- ( void ) reloadMessages
    {
    [ self _loadMessages ];
    }

- ( void ) _loadMessages
    {
    // Retrieve the direct messages sent/received by the other side user
    NSArray* allDMs =  [ [ TWPDirectMessagesCoordinator defaultCenter ] allDMs ];
    for ( OTCDirectMessage* _DM in allDMs )
        if ( [ self->_otherSideUser isEqualToUser: _DM.sender ]
                || [ self->_otherSideUser isEqualToUser: _DM.recipient ] )
            if ( ![ _DMs containsObject: _DM ] )
                [ _DMs addObject: _DM ];

    [ self->_DMs sortWithOptions: NSSortConcurrent
                 usingComparator:
        ( NSComparator )^( OTCDirectMessage* _LhsDM, OTCDirectMessage* _RhsDM )
            {
            return _LhsDM.tweetID < _RhsDM.tweetID;
            } ];
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