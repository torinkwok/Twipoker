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
    { TWPBrainSignalTypeTweetMask           = 1U
    , TWPBrainSignalTypeFriendsListsMask    = 1U << 1
    , TWPBrainSignalTypeDeleteMask          = 1U << 2
    , TWPBrainSignalTypeScrubGeoMask        = 1U << 3
    , TWPBrainSignalTypeLimitMask           = 1U << 4
    , TWPBrainSignalTypeDisconnectMask      = 1U << 5
    , TWPBrainSignalTypeWarningMask         = 1U << 6
    , TWPBrainSignalTypeEventMask           = 1U << 7
    , TWPBrainSignalTypeStatusWithheldMask  = 1U << 8
    , TWPBrainSignalTypeCountryWithheldMask = 1U << 9
    , TWPBrainSignalTypeUserWithheldMask    = 1U << 10
    , TWPBrainSignalTypeControlMask         = 1U << 11
    , TWPBrainSignalTypeDirectMessagesMask  = 1U << 12
    };

// TWPBrain class
@interface TWPBrain : NSObject <OTCSTTwitterStreamingAPIDelegate>

#pragma mark Initializations
+ ( instancetype ) wiseBrain;

#pragma mark Registration of Limbs
// Authenticating User
- ( void ) registerLimbForAuthenticatingUser: ( NSObject <TWPLimb>* )_NewLimb
                                 brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;

- ( void ) removeLimbForAuthenticatingUser: ( NSObject <TWPLimb>* )_Limb
                               brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;

// Specifying User
- ( void ) registerLimb: ( NSObject <TWPLimb>* )_NewLimb
              forUserID: ( NSString* )_UserID
            brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;

- ( void ) removeLimb: ( NSObject <TWPLimb>* )_Limb
            forUserID: ( NSString* )_UserID
          brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals;

@end // TWPBrain class

// TWPLimb class
@protocol TWPLimb <NSObject>

- ( void ) didReceiveTweetWithinHomeTimeline: ( OTCTweet* )_Tweet fromBrain: ( TWPBrain* )_Brain;

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