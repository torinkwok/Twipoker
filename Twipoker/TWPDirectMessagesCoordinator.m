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

#import <objc/message.h>

#import "TWPDirectMessagesCoordinator.h"
#import "TWPLoginUsersManager.h"
#import "TWPDirectMessagesPreviewViewController.h"
#import "TWPDirectMessageSession.h"

// Private Interfaces
@interface TWPDirectMessagesCoordinator ()

- ( void ) _realodAllSessions;
- ( NSArray* ) _allOtherSideUsers;

@end // Private Interfaces

@implementation TWPDirectMessagesCoordinator

@synthesize DMPreviewViewContorller;
@synthesize allDMs = _allDMs;
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
            self->_allDMs = [ NSMutableArray array ];
            self->_allDirectMessageSessions = [ NSMutableArray array ];

            self->_twitterAPI = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;

            sDefaultCoordinator = self;
            }
        }

    return sDefaultCoordinator;
    }

- ( void ) awakeFromNib
    {
    void ( ^fetchDirectMessagesSuccessBlock )( NSArray* ) =
        ^( NSArray* _MessagesJSON )
            {
            for ( NSDictionary* _MsgJSON in _MessagesJSON )
                {
                OTCDirectMessage* dm = [ OTCDirectMessage directMessageWithJSON: _MsgJSON ];
                if ( dm ) [ self->_allDMs addObject: dm ];

                [ self->_allDMs sortWithOptions: NSSortConcurrent
                                usingComparator:
                    ( NSComparator )^( OTCDirectMessage* _LhsDM, OTCDirectMessage* _RhsDM )
                        {
                        return _LhsDM.tweetID < _RhsDM.tweetID;
                        } ];
                }

            [ self _realodAllSessions ];
            };

    // Fetch 20 most recent direct messages sent by current authenticating user
    [ self->_twitterAPI getDirectMessagesSinceID: nil maxID: nil count: @( 200 ).stringValue page: nil includeEntities: @YES
                                    successBlock: fetchDirectMessagesSuccessBlock
                                      errorBlock: ^( NSError* _Error ) { NSLog( @"%@", _Error ); } ];

    // Fetch 20 most recent direct messages sent to current authenticating user
    [ self->_twitterAPI getDirectMessagesSinceID: nil maxID: nil count: @( 200 ).stringValue includeEntities: @YES skipStatus: @YES
                                    successBlock: fetchDirectMessagesSuccessBlock
                                      errorBlock: ^( NSError* _Error ) { NSLog( @"%@", _Error ); } ];
    }

#pragma mark Dynamic Accessors
- ( NSArray* ) allDirectMessageSessions
    {
    return self->_allDirectMessageSessions;
    }

#pragma mark Private Interfaces
// Extract all the possible users
- ( NSArray* ) _allOtherSideUsers
    {
    NSString* currentTwitterUserID = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID;

    NSMutableArray* otherSideUsers = [ NSMutableArray array ];
    for ( OTCDirectMessage* _DM in self->_allDMs )
        {
        // If the recipient of this direct message is not current authenticating user...
        if ( ![ _DM.recipient.IDString isEqualToString: currentTwitterUserID ] )
            // If otherSideUsers contains the recipient of this direct message, skip this step
            if ( ![ otherSideUsers containsObject: _DM.recipient ] )
                [ otherSideUsers addObject: _DM.recipient ];

        // If the sender of this direct message is not current authenticating user...
        if ( ![ _DM.sender.IDString isEqualToString: currentTwitterUserID ] )
            // If otherSideUsers contains the sender of this direct message, skip this step
            if ( ![ otherSideUsers containsObject: _DM.sender ] )
                [ otherSideUsers addObject: _DM.sender ];
        }

    return otherSideUsers;
    }

// Reload all the direct message sessions
- ( void ) _realodAllSessions
    {
    NSArray* otherSideUsers = [ self _allOtherSideUsers ];

    // Construct direct message sessions according possible user
    for ( OTCTwitterUser* _OtherSideUser in otherSideUsers )
        {
        TWPDirectMessageSession* session = [ TWPDirectMessageSession sessionWithOtherSideUser: _OtherSideUser ];

        if ( session )
            {
            SEL delegateMethodSEL = nil;

            // If the direct message session represented by `session`
            // doesn't exist in self->_allDirectMessageSessions,
            // append it.
            if ( ![ self->_allDirectMessageSessions containsObject: session ] )
                {
                [ self->_allDirectMessageSessions addObject: session ];
                delegateMethodSEL = @selector( coordinator:didAddNewSession: );
                }
            else
                {
                NSUInteger index = [ self->_allDirectMessageSessions indexOfObject: session ];
                [ self->_allDirectMessageSessions[ index ] reloadMessages ];
                delegateMethodSEL = @selector( coordinator:didUpdateSession: );
                }

            for ( NSArray* _Pair in self->_observers )
                {
                if ( [ _Pair.firstObject isEqualToUser: _OtherSideUser ] || _Pair.firstObject == [ NSNull null ] )
                    if ( [ _Pair.lastObject conformsToProtocol: @protocol( TWPDirectMessagesCoordinatorObserver ) ]
                            && [ _Pair.lastObject respondsToSelector: delegateMethodSEL ] )
                        {
                        id observer = _Pair.lastObject;
                        Method delegateRuntimeMethod = class_getInstanceMethod( [ observer class ], delegateMethodSEL );
                        method_invoke( observer, delegateRuntimeMethod, self, session );
//
//                        NSInvocation* delegateInvocation =
//                            [ NSInvocation invocationWithMethodSignature: [ observer methodSignatureForSelector: delegateMethodSEL ] ];
//
//                        [ delegateInvocation setSelector: delegateMethodSEL ];
//
//                        id coordinator = self;
//                        [ delegateInvocation setArgument: &coordinator atIndex: 2 ];
//                        [ delegateInvocation setArgument: &session atIndex: 3 ];
//
//                        [ delegateInvocation invokeWithTarget: observer ];

//                        [ _Pair.lastObject coordinator: self didAddNewSession: session ];
                        }
                }
            }
        }

//    [ self.DMPreviewViewContorller updateDMs ];
    }

#pragma mark Observer Registration
// Once the `_OtherSideUser` sent direct message to the current authenticating user,
// `_NewObserver` will be notified.
- ( void ) registerObserver: ( id <TWPDirectMessagesCoordinatorObserver> )_NewObserver
              otherSideUser: ( OTCTwitterUser* )_OtherSideUser
    {
    NSParameterAssert( ( _NewObserver ) );
    [ self->_observers addObject: @[ ( _OtherSideUser ?: [ NSNull null ] ), _NewObserver ] ];
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