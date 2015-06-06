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

@class TWPTweetUpdateObject;

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

    NSMutableSet __strong* _friendsList;
    NSMutableSet __strong* _monitoringUserIDs;

    NSMutableArray __strong* _uniqueTweetsQueue;
    }

@property ( strong, readwrite ) OTCTwitterUser* currentTwitterUser;

#pragma mark Initializations
+ ( instancetype ) wiseBrain;

#pragma mark Operations
- ( void ) pushTweetUpdate: ( TWPTweetUpdateObject* )_TweetUpdateObj
              successBlock: ( void (^)( OTCTweet* _PushedTweet ) )_SuccessBlock
                errorBlock: ( void (^)( NSError* _Error ) )_ErrorBlock;

- ( void ) favTweet: ( OTCTweet* )_Tweet
       successBlock: ( void (^)( OTCTweet* _FavedTweet ) )_SuccessBlock
         errorBlock: ( void (^)( NSError* _Error ) )_ErrorBlock;

#pragma mark Registration of Limbs
- ( void ) registerLimb: ( NSObject <TWPLimb>* )_NewLimb forUserIDs: ( NSArray* )_UserIDs brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;
- ( void ) removeLimb: ( NSObject <TWPLimb>* )_Limb forUserIDs: ( NSArray* )_UserIDs brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;

@end // TWPBrain class

// TWPLimb class
@protocol TWPLimb <NSObject>

@optional
- ( void ) brain: ( TWPBrain* )_Brain didReceiveTweet: ( OTCTweet* )_Tweet;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveTweetDeletion: ( NSString* )_DeletedTweetID byUser: ( NSString* )_UserID on: ( NSDate* )_DeletionDate;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveMention: ( OTCTweet* )_Metion;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveDirectMessage: ( OTCDirectMessage* )_DirectMessage;
- ( void ) brain: ( TWPBrain* )_Brain didReceiveEvent: ( OTCStreamingEvent* )_DetectedEvent;

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