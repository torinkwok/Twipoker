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

// --------------------------------------------------------------------------------------------------- //
// _TWPSignalLimbPair class
@interface _TWPSignalLimbPair : NSObject

@property ( assign, readwrite ) TWPBrainSignalTypeMask signalMask;
@property ( strong, readwrite ) NSObject <TWPLimb>* limb;

#pragma mark Initializations
+ ( instancetype ) pairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb;
- ( instancetype ) initWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb;

#pragma mark Comparing
- ( BOOL ) isEqualToPair: ( _TWPSignalLimbPair* )_RhsPair;

@end // _TWPSignalLimbPair class

// --------------------------------------------------------------------------------------------------- //
// _TWPSignalLimbPairs class
@interface _TWPSignalLimbPairs : NSObject <NSFastEnumeration>
    {
@private
    STTwitterAPI __strong* _twitterAPI;
    NSMutableSet __strong* _signalLimbPairs;
    }

@property ( strong, readonly ) STTwitterAPI* twitterAPI;

@property ( assign, readonly ) NSUInteger pairsCount;

+ ( instancetype ) pairsWithTwitterAPI: ( STTwitterAPI* )_TwitterAPI;
- ( instancetype ) initWithTwitterAPI: ( STTwitterAPI* )_TwitterAPI;

- ( void ) addPairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_NewLimb;
- ( void ) addPair: ( _TWPSignalLimbPair* )_NewPair;

- ( void ) removePairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_NewLimb;
- ( void ) removePair: ( _TWPSignalLimbPair* )_NewPair;

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