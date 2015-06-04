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
#import "TWPStackContentViewController.h"
#import "TWPDashboardView.h"
#import "TWPDashboardCellView.h"
#import "TWPViewsStack.h"
#import "TWPNavigationBar.h"

@implementation TWPStackContentView

@synthesize navigationBar;

@synthesize controller;
@synthesize KVOController;

#pragma mark Initialization
- ( void ) awakeFromNib
    {
    self.KVOController = [ FBKVOController controllerWithObserver: self ];
    [ self.KVOController observe: self.controller
                         keyPath: TWPStackContentViewControllerCurrentDashboardStackKeyPath
                         options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           block:
        ( FBKVONotificationBlock )^( id _Observer, id _Object, NSDictionary* _Changes )
            {
            TWPViewsStack __weak* newViewsStack = _Changes[ @"new" ];
            [ newViewsStack.currentView.view setFrame: [ self boundsOfElementView ] ];
            [ self setSubviews: @[ newViewsStack.currentView.view ] ];
            } ];
    }

#pragma mark Utilities
- ( NSRect ) boundsOfElementView
    {
    NSRect rect = NSInsetRect( self.bounds, 0, -1.5 );
    rect.size.width += 1.f;

    return rect;
    }

- ( void ) setFrame:(NSRect)frame
    {
    [ super setFrame: frame ];
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