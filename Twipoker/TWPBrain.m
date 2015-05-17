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

#import "TWPBrain.h"
#import "TWPLoginUsersManager.h"

#import "_TWPSignalLimbPairs.h"

// TWPBrain class
@implementation TWPBrain
    {
    // Home Timeline
    STTwitterAPI __strong* _homeTimelineStreamAPI;
    NSMutableArray __strong* _limbsSignalMaskPairsForAuthingUserStreamAPI;

    // Specified Users
    NSMutableDictionary __strong* _dictOfSecifiedUsersStreamAPI;
    }

#pragma mark Initializations
+ ( instancetype ) wiseBrain
    {
    return [ [ [ self class ] alloc ] init ];
    }

TWPBrain static __strong* sWiseBrain;
- ( instancetype ) init
    {
    if ( !sWiseBrain )
        {
        if ( self = [ super init ] )
            {
            self->_homeTimelineStreamAPI = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;
            self->_homeTimelineStreamAPI.delegate = self;

            self->_limbsSignalMaskPairsForAuthingUserStreamAPI = [ NSMutableArray array ];

            self->_dictOfSecifiedUsersStreamAPI = [ NSMutableDictionary dictionary ];

            [ self->_homeTimelineStreamAPI fetchUserStreamIncludeMessagesFromFollowedAccounts: @NO
                                                                                     includeReplies: @NO
                                                                                    keywordsToTrack: nil
                                                                              locationBoundingBoxes: nil ];
            sWiseBrain = self;
            }
        }

    return sWiseBrain;
    }

#pragma mark Registration of Limbs
// Authenticating User
- ( void ) registerLimbForAuthenticatingUser: ( NSObject <TWPLimb>* )_NewLimb
                                 brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _NewLimb )
        {
        _TWPSignalLimbPair* pair = [ _TWPSignalLimbPair pairWithSignalMask: _BrainSignals limb: _NewLimb ];

        if ( pair )
            [ self->_limbsSignalMaskPairsForAuthingUserStreamAPI addObject: pair ];
        }
    }

- ( void ) removeLimbForAuthenticatingUser: ( NSObject <TWPLimb>* )_Limb
                               brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _Limb )
        {
        [ self->_limbsSignalMaskPairsForAuthingUserStreamAPI removeObject:
            [ _TWPSignalLimbPair pairWithSignalMask: _BrainSignals limb: _Limb ] ];
        }
    }

// Specifying User
- ( void ) registerLimb: ( NSObject <TWPLimb>* )_NewLimb
              forUserID: ( NSString* )_UserID
            brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _NewLimb && _UserID )
        {
        _TWPSignalLimbPairs* correctpondingPairs = self->_dictOfSecifiedUsersStreamAPI[ _UserID ];

        if ( !correctpondingPairs )
            {
            correctpondingPairs = [ _TWPSignalLimbPairs pairsWithTwitterAPI: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI ];
            [ correctpondingPairs addPairWithSignalMask: _BrainSignals limb: _NewLimb ];

            self->_dictOfSecifiedUsersStreamAPI[ _UserID ] = correctpondingPairs;
            }
        else
            [ correctpondingPairs addPairWithSignalMask: _BrainSignals limb: _NewLimb ];
        }
    }

- ( void ) removeLimb: ( NSObject <TWPLimb>* )_Limb
            forUserID: ( NSString* )_UserID
          brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _Limb && _UserID )
        {
        _TWPSignalLimbPairs* correctpondingPairs = self->_dictOfSecifiedUsersStreamAPI[ _UserID ];

        if ( correctpondingPairs )
            [ correctpondingPairs removePairWithSignalMask: _BrainSignals limb: _Limb ];

        if ( !correctpondingPairs.pairsCount )
            [ self->_dictOfSecifiedUsersStreamAPI[ _UserID ] removeObjectForKey: _UserID ];
        }
    }

#pragma mark Conforms to <OTCSTTwitterStreamingAPIDelegate> protocol
- ( void ) twitterAPI: ( STTwitterAPI* )_TwitterAPI didReceiveTweet: ( OTCTweet* )_ReceivedTweet
    {
    for ( _TWPSignalLimbPair* _Pair in self->_limbsSignalMaskPairsForAuthingUserStreamAPI )
        {
        if ( ( _Pair.signalMask & TWPBrainSignalTypeTweetMask )
                && [ _Pair.limb respondsToSelector: @selector( didReceiveTweetWithinHomeTimeline:fromBrain: ) ] )
            [ _Pair.limb didReceiveTweetWithinHomeTimeline: _ReceivedTweet fromBrain: self ];
        }
    }

@end // TWPBrain class

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