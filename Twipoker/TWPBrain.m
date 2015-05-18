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
            // Home Timeline
            self->_homeTimelineStreamAPI = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;
            self->_pairArrForHomeTimeline = [ NSMutableArray array ];
            self->_homeTimelineStreamAPI.delegate = self;
            [ self->_homeTimelineStreamAPI fetchUserStreamIncludeMessagesFromFollowedAccounts: @NO
                                                                               includeReplies: @NO
                                                                              keywordsToTrack: nil
                                                                        locationBoundingBoxes: nil ];

            // Specified Users
            self->_globalTimelineStreamAPI = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;
            self->_pairArrForGlobalTimeline = [ NSMutableArray array ];
            self->_globalTimelineStreamAPI.delegate = self;
            [ self->_globalTimelineStreamAPI fetchStatusesFilterKeyword: @"@NSTongG"
                                                                 users: nil
                                                 locationBoundingBoxes: nil ];

            self->_dictOfSecifiedUsersStreamAPI = [ NSMutableDictionary dictionary ];

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
            [ self->_pairArrForHomeTimeline addObject: pair ];
        }
    }

- ( void ) removeLimbForAuthenticatingUser: ( NSObject <TWPLimb>* )_Limb
                               brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _Limb )
        {
        [ self->_pairArrForHomeTimeline removeObject:
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
            correctpondingPairs.twitterAPI.delegate = self;
            [ correctpondingPairs.twitterAPI fetchStatusesFilterKeyword: @"" users: @[ _UserID ] locationBoundingBoxes: nil ];

            if ( correctpondingPairs )
                [ self->_dictOfSecifiedUsersStreamAPI setObject: correctpondingPairs forKey: _UserID ];
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
    if ( _TwitterAPI == self->_homeTimelineStreamAPI || _TwitterAPI == self->_globalTimelineStreamAPI )
        {
        for ( _TWPSignalLimbPair* _Pair in self->_pairArrForHomeTimeline )
            {
            if ( ( _Pair.signalMask & TWPBrainSignalTypeNewTweetMask )
                    && [ _Pair.limb respondsToSelector: @selector( didReceiveTweet:fromBrain: ) ] )
                [ _Pair.limb didReceiveTweet: _ReceivedTweet fromBrain: self ];
            }
        }
    else
        {
        for ( NSString* _UserID in self->_dictOfSecifiedUsersStreamAPI )
            {
            _TWPSignalLimbPairs* pairs = ( _TWPSignalLimbPairs* )( self->_dictOfSecifiedUsersStreamAPI[ _UserID ] );
            if ( pairs.twitterAPI == _TwitterAPI )
                {
                for ( _TWPSignalLimbPair* _Pair in pairs )
                    {
                    if ( ( _Pair.signalMask & TWPBrainSignalTypeNewTweetMask )
                        && [ _Pair.limb respondsToSelector: @selector( didReceiveTweet:fromBrain: ) ] )
                        [ _Pair.limb didReceiveTweet: _ReceivedTweet fromBrain: self ];
                    }
                }
            }
        }
    }

- ( void )             twitterAPI: ( STTwitterAPI* )_TwitterAPI
    streamingEventHasBeenDetected: ( OTCStreamingEvent* )_DetectedEvent
    {
    if ( _TwitterAPI == self->_homeTimelineStreamAPI )
        {
        for ( _TWPSignalLimbPair* _Pair in self->_pairArrForHomeTimeline )
            {
            if ( ( _Pair.signalMask & TWPBrainSignalTypeTimelineEventMask )
                    && [ _Pair.limb respondsToSelector: @selector( didReceiveEvent:fromBrain: ) ] )
                [ _Pair.limb didReceiveEvent: _DetectedEvent fromBrain: self ];
            }
        }
    else
        {
        for ( NSString* _UserID in self->_dictOfSecifiedUsersStreamAPI )
            {
            _TWPSignalLimbPairs* pairs = ( _TWPSignalLimbPairs* )( self->_dictOfSecifiedUsersStreamAPI[ _UserID ] );
            if ( pairs.twitterAPI == _TwitterAPI )
                {
                for ( _TWPSignalLimbPair* _Pair in pairs )
                    {
                    if ( ( _Pair.signalMask & TWPBrainSignalTypeTimelineEventMask )
                        && [ _Pair.limb respondsToSelector: @selector( didReceiveEvent:fromBrain: ) ] )
                        [ _Pair.limb didReceiveEvent: _DetectedEvent fromBrain: self ];
                    }
                }
            }
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