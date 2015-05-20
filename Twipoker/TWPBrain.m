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

#import "_TWPMonitoringUserIDsSet.h"

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
            // Single-user stream, containing roughly all of the data corresponding with
            // the current authenticating user’s view of Twitter.
            self->_pairsSetForHomeTimeline = [ _TWPMonitoringUserIDsSet pairsWithTwitterAPI: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI ];
            self->_pairsSetForHomeTimeline.twitterAPI.delegate = self;
            [ self->_pairsSetForHomeTimeline.twitterAPI
                fetchUserStreamIncludeMessagesFromFollowedAccounts: @NO
                                                    includeReplies: @NO
                                                   keywordsToTrack: nil
                                             locationBoundingBoxes: nil ];
            // Global Timeline
            // Streams of the public data flowing through Twitter.
            self->_pairsSetForMentionsTimeline = [ _TWPMonitoringUserIDsSet pairsWithTwitterAPI: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI ];
            self->_pairsSetForMentionsTimeline.twitterAPI.delegate = self;
            [ self->_pairsSetForMentionsTimeline.twitterAPI
                    fetchStatusesFilterKeyword: @"@NSTongG" users: nil locationBoundingBoxes: nil ];

            self->_dictOfSecifiedUsersStreamAPI = [ NSMutableDictionary dictionary ];

            sWiseBrain = self;
            }
        }

    return sWiseBrain;
    }

#pragma mark Registration of Limbs
- ( void ) registerLimb: ( NSObject <TWPLimb>* )_NewLimb
              forUserID: ( NSString* )_UserID
            brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _NewLimb )
        {
        if ( !_UserID )
            {
            _TWPMonitoringUserID* pair = [ _TWPMonitoringUserID pairWithSignalMask: _BrainSignals limb: _NewLimb ];

            if ( pair )
                {
                id __weak target = nil;

                if ( _BrainSignals & TWPBrainSignalTypeNewTweetMask
                        || _BrainSignals & TWPBrainSignalTypeTweetDeletionMask
                        || _BrainSignals & TWPBrainSignalTypeTimelineEventMask
                        || _BrainSignals & TWPBrainSignalTypeDirectMessagesMask )
                    [ self->_pairsSetForHomeTimeline addPair: pair ];

                if ( _BrainSignals & TWPBrainSignalTypeMentionedMeMask )
                    [ self->_pairsSetForMentionsTimeline addPair: pair ];

                if ( _BrainSignals & TWPBrainSignalTypeDisconnectionMask )
                    ;

                [ target performSelectorOnMainThread: @selector( addObject: ) withObject: pair waitUntilDone: YES ];
                }
            }
        else if ( _UserID
                    && ( _BrainSignals & TWPBrainSignalTypeNewTweetMask
                            || _BrainSignals & TWPBrainSignalTypeTweetDeletionMask
                            || _BrainSignals & TWPBrainSignalTypeUserUpdateMask ) )
            {
            _TWPMonitoringUserIDsSet* pairsSet = self->_dictOfSecifiedUsersStreamAPI[ _UserID ];

            if ( !pairsSet )
                {
                pairsSet = [ _TWPMonitoringUserIDsSet pairsWithTwitterAPI: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI ];
                [ pairsSet addPairWithSignalMask: _BrainSignals limb: _NewLimb ];

                self->_dictOfSecifiedUsersStreamAPI[ _UserID ] = pairsSet;
                pairsSet.twitterAPI.delegate = self;
                [ pairsSet.twitterAPI fetchStatusesFilterKeyword: @"" users: @[ _UserID ] locationBoundingBoxes: nil ];
                }
            else
                [ pairsSet addPairWithSignalMask: _BrainSignals limb: _NewLimb ];
            }
        }
    }

- ( void ) removeLimb: ( NSObject <TWPLimb>* )_NewLimb
            forUserID: ( NSString* )_UserID
          brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    if ( _NewLimb )
        {
        _TWPMonitoringUserIDsSet* correctpondingPairs = self->_dictOfSecifiedUsersStreamAPI[ _UserID ];

        if ( correctpondingPairs )
            [ correctpondingPairs removePairWithSignalMask: _BrainSignals limb: _NewLimb ];

        if ( !correctpondingPairs.pairsCount )
            [ self->_dictOfSecifiedUsersStreamAPI[ _UserID ] removeObjectForKey: _UserID ];
        }
    }

#pragma mark Conforms to <OTCSTTwitterStreamingAPIDelegate> protocol
- ( void ) twitterAPI: ( STTwitterAPI* )_TwitterAPI didReceiveTweet: ( OTCTweet* )_ReceivedTweet
    {
    if ( _TwitterAPI == self->_pairsSetForHomeTimeline.twitterAPI
            || _TwitterAPI == self->_pairsSetForMentionsTimeline.twitterAPI )
        {
        _TWPMonitoringUserIDsSet* pairsSet = nil;

        if ( _TwitterAPI == self->_pairsSetForHomeTimeline.twitterAPI )
            pairsSet = self->_pairsSetForHomeTimeline;

        else if ( _TwitterAPI == self->_pairsSetForMentionsTimeline.twitterAPI )
            pairsSet = self->_pairsSetForMentionsTimeline;

        for ( _TWPMonitoringUserID* _Pair in pairsSet )
            {
            if ( ( _Pair.signalMask & TWPBrainSignalTypeNewTweetMask )
                    && [ _Pair.limb respondsToSelector: @selector( didReceiveTweet:fromBrain: ) ] )
                [ _Pair.limb didReceiveTweet: _ReceivedTweet fromBrain: self ];

            else if ( ( _Pair.signalMask & TWPBrainSignalTypeMentionedMeMask )
                    && [ _Pair.limb respondsToSelector: @selector( didReceiveMention:fromBrain: ) ] )
                [ _Pair.limb didReceiveMention: _ReceivedTweet fromBrain: self ];
            }
        }
    else
        {
        for ( NSString* _UserID in self->_dictOfSecifiedUsersStreamAPI )
            {
            _TWPMonitoringUserIDsSet* pairsSet = ( _TWPMonitoringUserIDsSet* )( self->_dictOfSecifiedUsersStreamAPI[ _UserID ] );
            if ( pairsSet.twitterAPI == _TwitterAPI )
                {
                for ( _TWPMonitoringUserID* _Pair in pairsSet )
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
    if ( _TwitterAPI == self->_pairsSetForHomeTimeline.twitterAPI )
        {
        for ( _TWPMonitoringUserID* _Pair in self->_pairsSetForHomeTimeline )
            {
            if ( ( _Pair.signalMask & TWPBrainSignalTypeTimelineEventMask )
                    && [ _Pair.limb respondsToSelector: @selector( didReceiveEvent:fromBrain: ) ] )
                [ _Pair.limb didReceiveEvent: _DetectedEvent fromBrain: self ];
            }
        }
    }

- ( void )   twitterAPI: ( STTwitterAPI* )_TwitterAPI
    tweetHasBeenDeleted: ( NSString* )_DeletedTweetID
                 byUser: ( NSString* )_UserID
                     on: ( NSDate* )_DeletionDate
    {
    if ( _TwitterAPI == self->_pairsSetForHomeTimeline.twitterAPI )
        {
        for ( _TWPMonitoringUserID* _Pair in self->_pairsSetForHomeTimeline )
            {
            if ( ( _Pair.signalMask & TWPBrainSignalTypeTweetDeletionMask )
                    && [ _Pair.limb respondsToSelector: @selector( didReceiveTweetDeletion:byUser:on: ) ] )
                [ _Pair.limb didReceiveTweetDeletion: _DeletedTweetID byUser: _UserID on: _DeletionDate ];
            }
        }
    else
        {
        for ( NSString* _UserID in self->_dictOfSecifiedUsersStreamAPI )
            {
            _TWPMonitoringUserIDsSet* pairsSet = ( _TWPMonitoringUserIDsSet* )( self->_dictOfSecifiedUsersStreamAPI[ _UserID ] );
            if ( pairsSet.twitterAPI == _TwitterAPI )
                {
                for ( _TWPMonitoringUserID* _Pair in pairsSet )
                    {
                    if ( ( _Pair.signalMask & TWPBrainSignalTypeTweetDeletionMask )
                            && [ _Pair.limb respondsToSelector: @selector( didReceiveTweetDeletion:byUser:on: ) ] )
                        [ _Pair.limb didReceiveTweetDeletion: _DeletedTweetID byUser: _UserID on: _DeletionDate ];
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