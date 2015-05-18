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

#import "_TWPSignalLimbPairsSet.h"

// --------------------------------------------------------------------------------------------------- //
// _TWPSignalLimbPair class
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

- ( NSUInteger ) hash
    {
    NSUInteger signalMaskHash = self.signalMask;
    NSUInteger limbHash = ( NSUInteger )self.limb;

    return signalMaskHash ^ limbHash;
    }

@end // _TWPSignalLimbPair class

// --------------------------------------------------------------------------------------------------- //
// _TWPSignalLimbPairsSet class
@implementation _TWPSignalLimbPairsSet

@synthesize twitterAPI = _twitterAPI;

@dynamic pairsCount;

+ ( instancetype ) pairsWithTwitterAPI: ( STTwitterAPI* )_TwitterAPI
    {
    return [ [ [ self class ] alloc ] initWithTwitterAPI: _TwitterAPI ];
    }

- ( instancetype ) initWithTwitterAPI: ( STTwitterAPI* )_TwitterAPI
    {
    if ( self = [ super init ] )
        {
        self->_twitterAPI = _TwitterAPI;
        self->_signalLimbPairs = [ NSMutableSet set ];
        }

    return self;
    }

- ( NSUInteger ) pairsCount
    {
    return self->_signalLimbPairs.count;
    }

- ( void ) addPairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask
                            limb: ( NSObject <TWPLimb>* )_NewLimb
    {
    _TWPSignalLimbPair* pair = [ _TWPSignalLimbPair pairWithSignalMask: _SignalMask limb: _NewLimb ];
    [ self addPair: pair ];
    }

- ( void ) addPair: ( _TWPSignalLimbPair* )_NewPair
    {
    [ self->_signalLimbPairs addObject: _NewPair ];
    }

- ( void ) removePairWithSignalMask: ( TWPBrainSignalTypeMask )_SignalMask
                               limb: ( NSObject <TWPLimb>* )_NewLimb
    {
    _TWPSignalLimbPair* pair = [ _TWPSignalLimbPair pairWithSignalMask: _SignalMask limb: _NewLimb ];
    [ self removePair: pair ];
    }

- ( void ) removePair: ( _TWPSignalLimbPair* )_NewPair
    {
    [ self->_signalLimbPairs removeObject: _NewPair ];
    }

#pragma mark Conforms <NSFastEnumeration> protocol
- ( NSUInteger ) countByEnumeratingWithState: ( NSFastEnumerationState* )_State
                                     objects: ( __unsafe_unretained id [] )_Buffer
                                       count: ( NSUInteger )_Len
    {
    return [ self->_signalLimbPairs countByEnumeratingWithState: _State objects: _Buffer count: _Len ];
    }

@end // _TWPSignalLimbPairsSet class

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