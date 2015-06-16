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

#import "TWPMainWindowContentView.h"

#import "TWPTimelineScrollView.h"
#import "TWPNavigationBarController.h"
#import "TWPStackContentView.h"
#import "TWPStackContentViewController.h"

#import "TWPTweetingBoxNotificationNames.h"
#import "TWPCuttingLineView.h"
#import "TWPTweetingCompleteBox.h"
#import "TWPTimelineUserNameButton.h"

// Private Interfaces
@interface TWPMainWindowContentView ()
- ( void ) _setUpSubviews;
@end // Private Interfaces

// TWPMainWindowContentView class
@implementation TWPMainWindowContentView

@synthesize navigationBarController;
@synthesize stackContentViewController;

@synthesize cuttingLineBetweenNavBarAndViewsStack;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ self _setUpSubviews ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    NSColor* color = [ NSColor colorWithHTMLColor: @"52AAEE" ];
    [ color set ];
    NSRectFill( _DirtyRect );
    }

#pragma mark Private Interfaces
- ( void ) _setUpSubviews
    {
    [ self.cuttingLineBetweenNavBarAndViewsStack removeFromSuperview ];

    // Navigation bar
    NSRect frameOfNavigationBar = self.navigationBarController.view.frame;

    // Cutting line
    NSRect frameOfCuttingLineView = NSMakeRect( NSMinX( frameOfNavigationBar ), NSHeight( frameOfNavigationBar )
                                              , NSWidth( self.cuttingLineBetweenNavBarAndViewsStack.frame ), NSHeight( self.cuttingLineBetweenNavBarAndViewsStack.frame ) );

    [ self.cuttingLineBetweenNavBarAndViewsStack setFrame: frameOfCuttingLineView ];
    [ self addSubview: self.cuttingLineBetweenNavBarAndViewsStack ];

    // Stack content view
    TWPStackContentView* stackContentView = ( TWPStackContentView* )( self.stackContentViewController.view );
    NSRect frameOfStackContentView = NSMakeRect( NSMinX( frameOfCuttingLineView )
                                               , NSMaxY( frameOfCuttingLineView )
                                               , NSWidth( stackContentView.frame )
                                               , NSHeight( self.bounds ) - NSHeight( frameOfNavigationBar ) - NSHeight( frameOfCuttingLineView )
                                               );

    [ stackContentView setFrame: frameOfStackContentView ];
    [ self addSubview: stackContentView ];
    }

- ( BOOL ) isFlipped
    {
    return YES;
    }

@end // TWPMainWindowContentView class

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