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

#import "TWPViewsStack.h"

@implementation TWPViewsStack

@synthesize baseViewController = _baseViewController;
@synthesize viewsStack = _viewsStack;
@synthesize cursor = _cursor;

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->_viewsStack = [ NSMutableArray array ];
        self->_cursor = -1;
        }

    return self;
    }

- ( void ) pushView: ( NSViewController* )_ViewController
    {
    if ( _ViewController.view )
        {
        if ( self->_cursor < ( NSInteger )( self->_viewsStack.count - 1 ) )
            {
            NSInteger firstDeletionIndex = self->_cursor + 1;
            NSRange range = NSMakeRange( firstDeletionIndex, self->_viewsStack.count - firstDeletionIndex );
            [ self->_viewsStack removeObjectsInRange: range ];
            }

        [ self->_viewsStack addObject: _ViewController ];
        self->_cursor++;
        }

    // TODO: Handling error: _ViewController.view must not be nil
    }

- ( NSViewController* ) popView
    {
    NSViewController* poppedView = nil;

    if ( self->_viewsStack.count )
        {
        [ self->_viewsStack removeLastObject ];
        self->_cursor--;
        }

    return poppedView;
    }

- ( NSViewController* ) backwardMoveCursor
    {
    if ( self->_cursor > -1 )
        self->_cursor--;

    return [ self _currentView ];
    }

- ( NSViewController* ) forwardMoveCursor
    {
    self->_cursor++;

    if ( self->_cursor > self->_viewsStack.count )
        self->_cursor = self->_viewsStack.count;

    return [ self _currentView ];
    }

- ( NSViewController* ) currentView
    {
    return [ self _currentView ];
    }

- ( NSViewController* ) _currentView
    {
    NSViewController* current = nil;

    if ( self->_cursor > -1 )
        current = [ self->_viewsStack objectAtIndex: self->_cursor ];
    else
        current = self.baseViewController;

    return current;
    }

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