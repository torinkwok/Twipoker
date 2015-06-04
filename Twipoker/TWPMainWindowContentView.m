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
    [ self _addAndFitTweetingView: self.tweetingBaseView ];

    [ NSTimer scheduledTimerWithTimeInterval: 10.f
                                      target: self
                                    selector: @selector( timerFireMethod: )
                                    userInfo: nil
                                     repeats: NO ];
    }

- ( void ) timerFireMethod: ( NSTimer* )_Timer
    {
    [ self _addAndFitTweetingView: self.tweetingCompleteView ];
    }

- ( void ) _addAndFitTweetingView: ( TWPTweetingView* )_TweetingView
    {
    [ self.tweetingBaseView removeFromSuperview ];
    [ self.tweetingCompleteView removeFromSuperview ];
    [ self.cuttingLineView removeFromSuperview ];

    // Navigation bar
    NSRect frameOfNavigationBar = self.navigationBarController.view.frame;

    // Tweeting view
    NSRect frameOfTweetingView = NSMakeRect( NSMinX( frameOfNavigationBar ), NSMinY( self.frame )
                                           , NSWidth( _TweetingView.frame ), NSHeight( _TweetingView.frame ) );
    [ _TweetingView setFrame: frameOfTweetingView ];
    [ self addSubview: _TweetingView ];

    // Cutting line
    NSRect frameOfCuttingLineView = NSMakeRect( NSMinX( frameOfTweetingView ), NSHeight( frameOfTweetingView )
                                              , NSWidth( self.cuttingLineView.frame ), NSHeight( self.cuttingLineView.frame ) );
    [ self.cuttingLineView setFrame: frameOfCuttingLineView ];
    [ self addSubview: self.cuttingLineView ];

    // Stack content view
    TWPStackContentView* stackContentView = ( TWPStackContentView* )( self.stackContentViewController.view );
    [ stackContentView removeFromSuperview ];
    NSRect frameOfStackContentView = NSMakeRect( NSMinX( frameOfCuttingLineView )
                                               , NSMaxY( frameOfCuttingLineView )
                                               , NSWidth( stackContentView.frame )
                                               , NSMinY( frameOfNavigationBar ) - NSMaxY( frameOfCuttingLineView ) );

    // ------
    // TODO: An ugly solution to fix layout issue of timeline scroll view
    TWPTimelineScrollView* timelineScrollView = ( TWPTimelineScrollView* )( stackContentView.subviews.firstObject );
    NSRect oldFrameOfTimelineScrollView = timelineScrollView.frame;     // Current value: {0, -1.5}, {607, 660}}
    [ stackContentView setFrame: frameOfStackContentView ];
    NSRect newFrameOfTimelineScrollView = timelineScrollView.frame;     // Current value {{0, -153.5}, {607, 660}}

    // Current value: Current value:
    // { {0, -1.5}, {607, NSHeight( newFrameOfTimelineScrollView ) - ( oldframeOfTimelineScrollView.origin.y - newFrameOfTimelineScrollView.origin.y )} }
    // =
    // { {0, -1.5}, {607, NSHeight( newFrameOfTimelineScrollView ) - ( -1.5 - (-153.5) )} }
    NSRect fixedFrameOfTimelineScrollView = oldFrameOfTimelineScrollView;
    fixedFrameOfTimelineScrollView.size.height =
        NSHeight( newFrameOfTimelineScrollView ) - ( oldFrameOfTimelineScrollView.origin.y - newFrameOfTimelineScrollView.origin.y );

    [ timelineScrollView setFrame: fixedFrameOfTimelineScrollView ];
    [ self addSubview: stackContentView ];
    // ------
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    NSColor* color = [ NSColor colorWithHTMLColor: @"52AAEE" ];
    [ color set ];
    NSRectFill( _DirtyRect );
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