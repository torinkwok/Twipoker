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

// _TWPSignalLimbPair class
@interface _TWPSignalLimbPair : NSObject

@property ( assign, readwrite ) TWPBrainSignalTypeMask signalMask;
@property ( strong, readwrite ) NSObject <TWPLimb>* limb;

#pragma mark Initializations
+ ( instancetype ) pairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb;
- ( instancetype ) initWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb;

#pragma mark Comparing
- ( BOOL ) isEqualToPair: ( _TWPSignalLimbPair* )_RhsPair;

@end

@implementation _TWPSignalLimbPair

@synthesize signalMask;
@synthesize limb;

#pragma mark Initializations
+ ( instancetype ) pairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb
    {
    return [ [ [ self class ] alloc ] initWithSignalMask: _SignalMask limb: _Limb ];
    }

- ( instancetype ) initWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb
    {
    if ( !_Limb )
        return nil;

    if ( self = [ super init ] )
        {
        self.signalMask = _SignalMask;
        self.limb = _Limb;
        }

    return self;
    }

#pragma mark Comparing
- ( BOOL ) isEqualToPair: ( _TWPSignalLimbPair* )_RhsPair
    {
    if ( self == _RhsPair )
        return YES;

    return ( self.signalMask == _RhsPair.signalMask ) && ( self.limb == _RhsPair.limb );
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ _TWPSignalLimbPair class ] ] )
        return [ self isEqualToPair: ( _TWPSignalLimbPair* )_Object ];

    return [ super isEqual: _Object ];
    }

@end // _TWPSignalLimbPair class

// TWPBrain class
@implementation TWPBrain
    {
    // Home Timeline
    STTwitterAPI __strong* _homeTimelineStreamAPI;
    NSMutableArray __strong* _limbsSignalMaskPairsForAuthingUserStreamAPI;

    // Specified Users
    NSMutableDictionary __strong* _pairsForSecifiedUsersStreamAPI;
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
            self->_limbsSignalMaskPairsForAuthingUserStreamAPI = [ NSMutableArray array ];

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