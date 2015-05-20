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

typedef NS_ENUM ( NSUInteger, TWPBrainSignalTypeMask )
    { TWPBrainSignalTypeNewTweetMask        = 1U
    , TWPBrainSignalTypeMentionedMeMask     = 1U << 1
    , TWPBrainSignalTypeTweetDeletionMask   = 1U << 2
    , TWPBrainSignalTypeTimelineEventMask   = 1U << 3
    , TWPBrainSignalTypeDirectMessagesMask  = 1U << 4
    , TWPBrainSignalTypeDisconnectionMask   = 1U << 5
    , TWPBrainSignalTypeUserUpdateMask      = 1U << 6
    };

// TWPBrain class
@interface TWPBrain : NSObject <OTCSTTwitterStreamingAPIDelegate>
    {
@private
    // Home Timeline
    // Single-user stream, containing roughly all of the data corresponding with
    // the current authenticating user’s view of Twitter.
    STTwitterAPI __strong* _authingUserTimelineStream;

    // Global Timeline
    // Streams of the public data flowing through Twitter.
    STTwitterAPI __strong* _publicTimelineFilterStream;

    NSMutableArray __strong* _monitoringUserIDs;
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
- ( void ) brain: ( TWPBrain* )_Brain didReceiveTweet: ( OTCTweet* )_Tweet;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveTweetDeletion: ( NSString* )_DeletedTweetID byUser: ( NSString* )_UserID on: ( NSDate* )_DeletionDate;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveMention: ( OTCTweet* )_Metion;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveEvent: ( OTCStreamingEvent* )_Tweet;

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