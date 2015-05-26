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

#import "TWPDirectMessagesDispatchCenter.h"
#import "TWPLoginUsersManager.h"

@implementation TWPDirectMessagesDispatchCenter

#pragma mark Initialization
+ ( instancetype ) defaultCenter
    {
    return [ [ [ self class ] alloc ] init ];
    }

TWPDirectMessagesDispatchCenter static __strong* sDefaultCenter = nil;
- ( instancetype ) init
    {
    if ( !sDefaultCenter )
        {
        if ( self = [ super init ] )
            {
            self->_sentDMs = [ NSMutableArray array ];
            self->_receivedDMs = [ NSMutableArray array ];
            self->_twitterAPI = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;

            // Fetch 20 most recent direct messages sent by current authenticating user
            [ self->_twitterAPI getDirectMessagesSinceID: nil maxID: nil count: @( 20 ).stringValue page: nil includeEntities: @YES
                                            successBlock:
                ^( NSArray* _Messages )
                    {
                    for ( NSDictionary* _MsgJSON in _Messages )
                        {
                        OTCDirectMessage* dm = [ OTCDirectMessage directMessageWithJSON: _MsgJSON ];
                        if ( dm )
                            [ self->_sentDMs addObject: dm ];
                        }
                    } errorBlock:
                        ^( NSError* _Error ) { NSLog( @"%@", _Error ); } ];

            // Fetch 20 most recent direct messages sent to current authenticating user
            [ self->_twitterAPI getDirectMessagesSinceID: nil maxID: nil count: @( 20 ).stringValue includeEntities: @YES skipStatus: @YES
                                            successBlock:
                ^( NSArray* _Messages )
                    {
                    for ( NSDictionary* _MsgJSON in _Messages )
                        {
                        OTCDirectMessage* dm = [ OTCDirectMessage directMessageWithJSON: _MsgJSON ];
                        if ( dm )
                            [ self->_receivedDMs addObject: dm ];
                        }
                    } errorBlock:
                        ^( NSError* _Error ) { NSLog( @"%@", _Error ); } ];

            sDefaultCenter = self;
            }
        }

    return sDefaultCenter;
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