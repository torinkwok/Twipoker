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

#import "TWPMainWindowContentViewController.h"

#import "TWPDashboardView.h"
#import "TWPTimelineScrollView.h"
#import "TWPNavigationBarController.h"
#import "TWPStackContentView.h"
#import "TWPStackContentViewController.h"

#import "TWPTweetingBoxNotificationNames.h"
#import "TWPCuttingLineView.h"
#import "TWPTweetingCompleteBox.h"
#import "TWPTimelineUserNameButton.h"

@interface TWPMainWindowContentViewController ()

@end

@implementation TWPMainWindowContentViewController

@synthesize navigationBarController;
@synthesize stackContentViewController;

@synthesize cuttingLineBetweenNavBarAndViewsStack;

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self.view removeConstraints: self.view.constraints ];

    NSView* navBar = self.navigationBarController.view;
    NSView* horizontalCuttingLine = self.cuttingLineBetweenNavBarAndViewsStack;
    NSView* stackContentView = self.stackContentViewController.view;
    NSView* dashboardView = self.dashboardView;

    [ self.view addSubview: navBar ];
    [ self.view addSubview: horizontalCuttingLine ];
    [ self.view addSubview: stackContentView ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( navBar, horizontalCuttingLine, stackContentView, dashboardView );

    NSArray* verticalConstraints0 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|[navBar][horizontalCuttingLine(==cuttingLineWidth)][stackContentView(>=stackContentViewHeight)]|"
                            options: 0
                            metrics: @{ @"cuttingLineWidth" : @( NSHeight( horizontalCuttingLine.frame ) )
                                      , @"stackContentViewHeight" : @( NSHeight( stackContentView.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* horizontalConstraints0 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|[navBar][dashboardView(==dashboardViewWidth)][stackContentView(>=stackContentViewWidth)]|"
                            options: 0
                            metrics: @{ @"cuttingLineWidth" : @( NSHeight( horizontalCuttingLine.frame ) )
                                      , @"stackContentViewWidth" : @( NSWidth( stackContentView.frame ) )
                                      , @"dashboardViewWidth" : @( NSWidth( dashboardView.frame ) )
                                      }
                              views: viewsDict ];

    [ self.view addConstraints: verticalConstraints0 ];
    [ self.view addConstraints: horizontalConstraints0 ];

//    [ self.cuttingLineBetweenNavBarAndViewsStack removeFromSuperview ];
//
//    // Navigation bar
//    NSRect frameOfNavigationBar = self.navigationBarController.view.frame;
//
//    // Cutting line
//    NSRect frameOfCuttingLineView = NSMakeRect( NSMinX( frameOfNavigationBar ), NSHeight( frameOfNavigationBar )
//                                              , NSWidth( self.cuttingLineBetweenNavBarAndViewsStack.frame ), NSHeight( self.cuttingLineBetweenNavBarAndViewsStack.frame ) );
//
//    [ self.cuttingLineBetweenNavBarAndViewsStack setFrame: frameOfCuttingLineView ];
//    [ self addSubview: self.cuttingLineBetweenNavBarAndViewsStack ];
//
//    // Stack content view
//    TWPStackContentView* stackContentView = ( TWPStackContentView* )( self.stackContentViewController.view );
//    NSRect frameOfStackContentView = NSMakeRect( NSMinX( frameOfCuttingLineView )
//                                               , NSMaxY( frameOfCuttingLineView )
//                                               , NSWidth( stackContentView.frame )
//                                               , NSHeight( self.bounds ) - NSHeight( frameOfNavigationBar ) - NSHeight( frameOfCuttingLineView )
//                                               );
//
//    [ stackContentView setFrame: frameOfStackContentView ];
//    [ self addSubview: stackContentView ];
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