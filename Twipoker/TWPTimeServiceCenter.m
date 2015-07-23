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

#import "TWPTimeServiceCenter.h"

TWPTimeServiceCenter static __strong* sSingleton;

// Private Interfaces
@interface TWPTimeServiceCenter ()
- ( void ) _timeToUpdateDateIndicatorView: ( NSTimer* )_Timer;
@end // Private Interfaces

// TWPTimeServiceCenter class
@implementation TWPTimeServiceCenter

#pragma mark Initializations
+ ( instancetype ) defaultTimeServiceCenter
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sSingleton )
        {
        if ( self = [ super init ] )
            {
            self->_observers = [ NSMutableSet set ];

            [ NSTimer scheduledTimerWithTimeInterval: 1.f
                                              target: self
                                            selector: @selector( _timeToUpdateDateIndicatorView: )
                                            userInfo: nil
                                             repeats: YES ];
            sSingleton = self;
            }
        }

    return sSingleton;
    }

#pragma mark Managing Observers
- ( void ) addObserver: ( id <TWPTimeServiceCenterObserver> )_DateIndicatorView
    {
    if ( [ _DateIndicatorView conformsToProtocol: @protocol( TWPTimeServiceCenterObserver ) ]
            && [ _DateIndicatorView respondsToSelector: @selector( timeShouldBeUpdated ) ] )
        [ self->_observers addObject: _DateIndicatorView ];
    }

- ( void ) removeObserver: ( id <TWPTimeServiceCenterObserver> )_DateIndicatorView
    {
    [ self->_observers removeObject: _DateIndicatorView ];
    }

#pragma mark Private Interfaces
- ( void ) _timeToUpdateDateIndicatorView: ( NSTimer* )_Timer
    {
    [ self->_observers makeObjectsPerformSelector: @selector( timeShouldBeUpdated ) ];
    }

@end // TWPTimeServiceCenter class

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