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

#import "TWPNavigationBarController.h"
#import "TWPStackContentView.h"
#import "TWPStackContentViewController.h"

#import "TWPCuttingLineView.h"
#import "TWPTweetingBaseView.h"
#import "TWPTweetingCompleteView.h"

// TWPMainWindowContentView class
@implementation TWPMainWindowContentView

@synthesize navigationBarController;
@synthesize stackContentViewController;

@synthesize cuttingLineView;
@synthesize tweetingBaseView;
@synthesize tweetingCompleteView;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ self _addAndFitTweetingView: self.tweetingCompleteView ];

//    [ NSTimer scheduledTimerWithTimeInterval: 5.f
//                                      target: self
//                                    selector: @selector( timerFireMethod: )
//                                    userInfo: nil
//                                     repeats: NO ];
    }

//- ( void ) timerFireMethod: ( NSTimer* )_Timer
//    {
//    [ self _addAndFitTweetingView: self.tweetingCompleteView ];
//    }

- ( void ) _addAndFitTweetingView: ( TWPTweetingView* )_TweetingView
    {
    NSRect frameOfStackContentView = self.stackContentViewController.view.frame;
    frameOfStackContentView.size.height -= ( NSHeight( _TweetingView.frame ) + NSHeight( self.cuttingLineView.frame ) );
    TWPStackContentView* stackContentView = ( TWPStackContentView* )( self.stackContentViewController.view );
    [ stackContentView setFrame: frameOfStackContentView ];

    NSLog( @"%@: %@", stackContentView, NSStringFromRect( stackContentView.frame ) );
    NSLog( @"%@", NSStringFromRect( [ ( TWPStackContentView* )( self.stackContentViewController.view ) boundsOfElementView ] ) );

    NSRect frameOfCuttingLineView = NSMakeRect( NSMinX( frameOfStackContentView ), NSHeight( self.navigationBarController.view.frame ) + NSHeight( frameOfStackContentView )
                                              , NSWidth( self.cuttingLineView.frame ), NSHeight( self.cuttingLineView.frame ) );
    [ self addSubview: self.cuttingLineView ];
    [ self.cuttingLineView setFrame: frameOfCuttingLineView ];

    NSRect frameOfTweetingBaseView = NSMakeRect( NSMinX( self.cuttingLineView.frame ), NSMaxY( frameOfCuttingLineView )
                                               , NSWidth( _TweetingView.frame ), NSHeight( _TweetingView.frame ) );
    [ self addSubview: _TweetingView ];
    [ _TweetingView setFrame: frameOfTweetingBaseView ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    NSColor* color = [ NSColor colorWithHTMLColor: @"52AAEE" ];
    [ color set ];
    NSRectFill( _DirtyRect );
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