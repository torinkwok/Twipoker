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

#import "TWPDirectMessagesCoordinator.h"
#import "TWPLoginUsersManager.h"
#import "TWPDirectMessagesPreviewViewController.h"
#import "TWPDirectMessageSession.h"

// Private Interfaces
@interface TWPDirectMessagesCoordinator ()
- ( void ) _updateSessions: ( NSArray* )_AllDMs;
@end // Private Interfaces

@implementation TWPDirectMessagesCoordinator

@synthesize DMPreviewViewContorller;

@synthesize sentDMs = _sentDMs;
@synthesize receivedDMs = _receivedDMs;
@synthesize allDirectMessageSessions = _allDirectMessageSessions;

#pragma mark Initialization
+ ( instancetype ) defaultCenter
    {
    return [ [ [ self class ] alloc ] init ];
    }

TWPDirectMessagesCoordinator static __strong* sDefaultCoordinator = nil;
- ( instancetype ) init
    {
    if ( !sDefaultCoordinator )
        {
        if ( self = [ super init ] )
            {
            self->_sentDMs = [ NSMutableArray array ];
            self->_receivedDMs = [ NSMutableArray array ];
            self->_allDirectMessageSessions = [ NSMutableArray array ];

            self->_twitterAPI = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;

            sDefaultCoordinator = self;
            }
        }

    return sDefaultCoordinator;
    }

- ( void ) awakeFromNib
    {
    void ( ^directMessagesFetchingBlock )( NSArray*, NSMutableArray* ) =
        ^( NSArray* _MessagesJSON, NSMutableArray* _StorageIvar )
            {
            for ( NSDictionary* _MsgJSON in _MessagesJSON )
                {
                OTCDirectMessage* dm = [ OTCDirectMessage directMessageWithJSON: _MsgJSON ];
                if ( dm )
                    [ _StorageIvar addObject: dm ];
                }

            [ self _updateSessions: [ self allDMs ] ];
            };

    // Fetch 20 most recent direct messages sent by current authenticating user
    [ self->_twitterAPI getDirectMessagesSinceID: nil maxID: nil count: @( 200 ).stringValue page: nil includeEntities: @YES
                                    successBlock:
        ^( NSArray* _Messages )
            { directMessagesFetchingBlock( _Messages, self->_sentDMs ); }
                                      errorBlock: ^( NSError* _Error ) { NSLog( @"%@", _Error ); } ];

    // Fetch 20 most recent direct messages sent to current authenticating user
    [ self->_twitterAPI getDirectMessagesSinceID: nil maxID: nil count: @( 200 ).stringValue includeEntities: @YES skipStatus: @YES
                                    successBlock:
        ^( NSArray* _Messages )
            { directMessagesFetchingBlock( _Messages, self->_receivedDMs ); }
                                      errorBlock: ^( NSError* _Error ) { NSLog( @"%@", _Error ); } ];
    }

#pragma mark Dynamic Accessors
- ( NSArray* ) allDMs
    {
    NSMutableArray* DMs = [ NSMutableArray arrayWithCapacity: self->_sentDMs.count + self->_receivedDMs.count ];
    [ DMs addObjectsFromArray: self->_sentDMs ];
    [ DMs addObjectsFromArray: self->_receivedDMs ];

    return [ DMs sortedArrayWithOptions: NSSortConcurrent
                        usingComparator:
        ( NSComparator )^( OTCDirectMessage* _LhsDM, OTCDirectMessage* _RhsDM )
            {
            return _LhsDM.tweetID < _RhsDM.tweetID;
            } ];
    }

- ( NSArray* ) allDirectMessageSessions
    {
    return self->_allDirectMessageSessions;
    }

#pragma mark Private Interfaces
- ( void ) _updateSessions: ( NSArray* )_AllDMs
    {
    NSString* currentTwitterUserID = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID;
    NSMutableArray* otherSideUsers = [ NSMutableArray array ];

    for ( OTCDirectMessage* _DM in _AllDMs )
        {
        if ( ![ _DM.recipient.IDString isEqualToString: currentTwitterUserID ] )
            if ( ![ otherSideUsers containsObject: _DM.recipient ] )
                [ otherSideUsers addObject: _DM.recipient ];

        if ( ![ _DM.sender.IDString isEqualToString: currentTwitterUserID ] )
            if ( ![ otherSideUsers containsObject: _DM.sender ] )
                [ otherSideUsers addObject: _DM.sender ];
        }

    for ( OTCTwitterUser* _OtherSideUser in otherSideUsers )
        {
        TWPDirectMessageSession* session = [ TWPDirectMessageSession sessionWithOtherSideUser: _OtherSideUser ];
        if ( session )
            {
            if ( ![ self->_allDirectMessageSessions containsObject: session ] )
                [ self->_allDirectMessageSessions addObject: session ];
            else
                {
                NSUInteger index = [ self->_allDirectMessageSessions indexOfObject: session ];
                [ self->_allDirectMessageSessions[ index ] reloadMessages ];
                }
            }
        }

    [ self.DMPreviewViewContorller updateDMs ];
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