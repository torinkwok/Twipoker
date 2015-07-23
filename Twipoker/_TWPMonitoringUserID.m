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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "_TWPMonitoringUserID.h"

// _TWPMonitoringUserID class
@implementation _TWPMonitoringUserID

@synthesize signalMask;
@synthesize limb;

#pragma mark Initializations
+ ( instancetype ) IDWithUserID: ( NSString* )_UserID signalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb
    {
    return [ [ [ self class ] alloc ] initWithUserID: _UserID signalMask: _SignalMask limb: _Limb ];
    }

- ( instancetype ) initWithUserID: ( NSString* )_UserID signalMask: ( TWPBrainSignalTypeMask )_SignalMask limb: ( NSObject <TWPLimb>* )_Limb
    {
    if ( !_Limb )
        return nil;

    if ( self = [ super init ] )
        {
        self.userID = _UserID;
        self.signalMask = _SignalMask;
        self.limb = _Limb;
        }

    return self;
    }

#pragma mark Comparing
- ( BOOL ) isEqualToPair: ( _TWPMonitoringUserID* )_RhsPair
    {
    if ( self == _RhsPair )
        return YES;

    return ( [ self.userID isEqualToString: _RhsPair.userID ] )
                && ( self.signalMask == _RhsPair.signalMask )
                && ( self.limb == _RhsPair.limb );
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ _TWPMonitoringUserID class ] ] )
        return [ self isEqualToPair: ( _TWPMonitoringUserID* )_Object ];

    return [ super isEqual: _Object ];
    }

- ( NSUInteger ) hash
    {
    NSUInteger userIDHash = self.userID.hash;
    NSUInteger signalMaskHash = self.signalMask;
    NSUInteger limbHash = ( NSUInteger )self.limb;

    return userIDHash ^ signalMaskHash ^ limbHash;
    }

@end // _TWPMonitoringUserID class

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