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

#import "TWPTweetingBoxController.h"
#import "TWPTweetingBaseView.h"
#import "TWPTweetingCompleteView.h"
#import "TWPCuttingLineView.h"

// Private Interfaces
@interface TWPTweetingBoxController ()
- ( void ) _addAndFitSubview: ( NSView* )_Subview;
@end // Private Interfaces

// // TWPTweetingBoxController class
@implementation TWPTweetingBoxController

@synthesize cuttingLine;

@synthesize tweetingBaseView;
@synthesize tweetingCompleteView;

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.

    [ self _addAndFitSubview: self.tweetingBaseView ];
    }

#pragma mark Private Interfaces
- ( void ) _addAndFitSubview: ( NSView* )_Subview
    {
    NSRect viewBounds = self.view.bounds;
    NSRect newBounds = NSMakeRect( viewBounds.origin.x
                                 , viewBounds.origin.y
                                 , NSWidth( viewBounds )
                                 , NSHeight( viewBounds ) - ( NSHeight( self.cuttingLine.frame ) + 1.f )
                                 );
                                 
    [ _Subview setFrame: newBounds ];
    [ self.view addSubview: _Subview ];
    }

@end // TWPTweetingBoxController class

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