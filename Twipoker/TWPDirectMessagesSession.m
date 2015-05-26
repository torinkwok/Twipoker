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
#import "TWPDirectMessagesDispatchCenter.h"

@implementation TWPDirectMessagesSession

@synthesize allDirectMessages = _DMs;

@synthesize recipient = _recipient;
@synthesize sender = _sender;

#pragma mark Initializations
+ ( instancetype ) sessionWithRecipient: ( OTCTwitterUser* )_Recipient
                                 sender: ( OTCTwitterUser* )_Sender
    {
    return [ [ [ self class ] alloc ] initWithRecipient: _Recipient sender: _Sender ];
    }

- ( instancetype ) initWithRecipient: ( OTCTwitterUser* )_Recipient
                              sender: ( OTCTwitterUser* )_Sender
    {
    if ( self = [ super init ] )
        {
        self->_DMs = [ NSMutableArray array ];

        self->_recipient = _Recipient;
        self->_sender = _Sender;

        NSArray* receivedDMs = [ [ TWPDirectMessagesDispatchCenter defaultCenter ] receivedDMs ];
        for ( OTCDirectMessage* _DM in receivedDMs )
            if ( [ self->_sender isEqualToUser: _DM.sender ] )
                [ _DMs addObject: _DM ];

        NSArray* sentDMs = [ [ TWPDirectMessagesDispatchCenter defaultCenter ] sentDMs ];
        for ( OTCDirectMessage* _DM in sentDMs )
            if ( [ self->_recipient isEqualToUser: _DM.recipient ] )
                [ _DMs addObject: _DM ];

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