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

#import "TWPViewsStack.h"
#import "TWPViewController.h"

// Private Interfaces
@interface TWPViewsStack ()
- ( TWPViewController* ) _currentView;
@end // Private Interfaces

// TWPViewsStack class
@implementation TWPViewsStack

@synthesize baseViewController = _baseViewController;
@synthesize viewsStack = _viewsStack;

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        self->_viewsStack = [ NSMutableArray array ];

    return self;
    }

- ( void ) pushView: ( TWPViewController* )_ViewController
    {
    if ( _ViewController.view )
        [ self->_viewsStack addObject: _ViewController ];

    // TODO: Handling error: _ViewController.view must not be nil
    }

- ( void ) popView
    {
    if ( self->_viewsStack.count > 0 )
        [ self->_viewsStack removeLastObject ];
    }

- ( TWPViewController* ) currentView
    {
    return [ self _currentView ];
    }

- ( TWPViewController* ) viewBeforeCurrentView
    {
    TWPViewController* interestingView = nil;
    TWPViewController* current = [ self _currentView ];
    NSUInteger currentIndex = [ self->_viewsStack indexOfObject: current ];
    if ( currentIndex > 0 && currentIndex != NSNotFound )
        interestingView = [ self->_viewsStack objectAtIndex: currentIndex - 1 ];
    else
        interestingView = self.baseViewController;

    return interestingView;
    }

#pragma mark Private Interfaces
- ( TWPViewController* ) _currentView
    {
    TWPViewController* currentViewController = nil;

    if ( self->_viewsStack.count > 0 )
        currentViewController = self->_viewsStack.lastObject;
    else
        currentViewController = self.baseViewController;

    return currentViewController;
    }

@end // TWPViewsStack class

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