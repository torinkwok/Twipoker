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

#import <Foundation/Foundation.h>

@protocol TWPLimb;
@class _TWPSignalLimbPairsSet;

typedef NS_ENUM ( NSUInteger, TWPBrainSignalTypeMask )
    { TWPBrainSignalTypeNewTweetMask        = 1U
    , TWPBrainSignalTypeMentionedMeMask     = 1U << 1
    , TWPBrainSignalTypeTweetDeletionMask   = 1U << 2
    , TWPBrainSignalTypeTimelineEventMask   = 1U << 3
    , TWPBrainSignalTypeDirectMessagesMask  = 1U << 4
    , TWPBrainSignalTypeDisconnectionMask   = 1U << 5
    };

// TWPBrain class
@interface TWPBrain : NSObject <OTCSTTwitterStreamingAPIDelegate>
    {
@private
    // Home Timeline
    // Single-user stream, containing roughly all of the data corresponding with
    // the current authenticating user’s view of Twitter.
    _TWPSignalLimbPairsSet __strong* _pairsForHomeTimeline;

    // Global Timeline
    // Streams of the public data flowing through Twitter.
    _TWPSignalLimbPairsSet __strong* _pairsForMentionsTimeline;

    // Specified Users
    /* @{ UserID : _TWPSignalLimbPairsSet
        , UserID : _TWPSignalLimbPairsSet
        , UserID : _TWPSignalLimbPairsSet
        , ...
        } */
    NSMutableDictionary __strong* _dictOfSecifiedUsersStreamAPI;
    }

#pragma mark Initializations
+ ( instancetype ) wiseBrain;

#pragma mark Registration of Limbs
- ( void ) registerLimb: ( NSObject <TWPLimb>* )_NewLimb forUserID: ( NSString* )_UserID brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;
- ( void ) removeLimb: ( NSObject <TWPLimb>* )_Limb forUserID: ( NSString* )_UserID brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;

@end // TWPBrain class

// TWPLimb class
@protocol TWPLimb <NSObject>

@optional
- ( void ) didReceiveTweet: ( OTCTweet* )_Tweet fromBrain: ( TWPBrain* )_Brain;
- ( void ) didReceiveMention: ( OTCTweet* )_Metion fromBrain: ( TWPBrain* )_Brain;
- ( void ) didReceiveEvent: ( OTCStreamingEvent* )_Tweet fromBrain: ( TWPBrain* )_Brain;

@end // TWPLimb class

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