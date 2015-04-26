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

#import "TWPStackContentView.h"
#import "TWPDashboardView.h"
#import "TWPDashboardCellView.h"
#import "TWPDashboardStack.h"

@implementation TWPStackContentView

@synthesize initialViewsStack = _initialViewsStack;

#pragma mark Initialization
- ( void ) awakeFromNib
    {
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( dashboardViewSelectedTabChanged: )
                                                    name: TWPDashboardViewSelectedTabChanged
                                                  object: nil ];

    [ self.initialViewsStack.baseViewController.view setFrame: [ self boundsOfElementView ] ];
    [ self setSubviews: @[ self.initialViewsStack.baseViewController.view ] ];
    }

- ( void ) dashboardViewSelectedTabChanged: ( NSNotification* )_Notif
    {
    TWPDashboardStack* associatedViewsStack = [ ( TWPDashboardCellView* )( _Notif.userInfo[ @"tab-cell-view" ] ) associatedViewsStack ];
    NSView* associatedView = associatedViewsStack.baseViewController.view;

    [ associatedView setFrame: [ self boundsOfElementView ] ];
    [ self setSubviews: @[ associatedView ] ];
    }

#pragma mark Utilities
- ( NSRect ) boundsOfElementView
    {
    NSRect rect = NSInsetRect( self.bounds, 0, -1.5 );
    rect.size.width += 1.f;

    return rect;
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