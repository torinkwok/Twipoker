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

#import "TWPDashboardViewController.h"
#import "TWPTimelineScrollView.h"
#import "TWPNavigationBarController.h"
#import "TWPStackContentView.h"
#import "TWPViewsStack.h"
#import "TWPStackContentViewController.h"

#import "TWPTweetingBoxNotificationNames.h"
#import "TWPCuttingLineView.h"
#import "TWPTweetingCompleteBox.h"
#import "TWPTimelineUserNameButton.h"

#import "TWPActionNotifications.h"
#import "TWPLoginUsersManager.h"
#import "TWPTwitterUserProfileViewController.h"
#import "TWPTwitterUserProfileView.h"

#import "NSView+TwipokerAutoLayout.h"

@interface TWPMainWindowContentViewController ()
- ( void ) _showUserProfile: ( NSNotification* )_Notif;
- ( void ) _hideUserProfile: ( NSNotification* )_Notif;
@end

@implementation TWPMainWindowContentViewController

@dynamic isShowingProfile;

@synthesize dashboardViewController;
@synthesize stackContentViewController;

@synthesize navigationBarController;
@synthesize twitterUserProfileViewController;
@synthesize cuttingLineBetweetMainViewAndProfileView;

@synthesize cuttingLineBetweenNavBarAndViewsStack;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    self.twitterUserProfileViewController.refNavBarController = self.navigationBarController;
    self->_initialFrame = self.view.frame;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _showUserProfile: ) name: TWPTwipokerShouldShowUserProfile object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _hideUserProfile: ) name: TWPTwipokerShouldHideUserProfile object: nil ];
        }

    return self;
    }

- ( void ) viewWillAppear
    {
    [ super viewDidLoad ];
    [ self setShowingProfile: NO ];
    }

#pragma mark Deallocator
- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPTwipokerShouldShowUserProfile object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPTwipokerShouldHideUserProfile object: nil ];
    }

#pragma mark Accessors
- ( void ) setShowingProfile: ( BOOL )_IsShowingProfile
    {
    self->_isShowingProfile = _IsShowingProfile;

    [ self.view removeConstraints: self.view.constraints ];
    [ self.view setSubviews: @[] ];

    NSView* navBar = self.navigationBarController.view;
    NSView* horizontalCuttingLine = self.cuttingLineBetweenNavBarAndViewsStack;
    NSView* stackContentView = self.stackContentViewController.view;
    NSView* dashboardView = self.dashboardViewController.view;
    NSView* profileView = self.twitterUserProfileViewController.view;
    NSView* verticalCuttingLine = self.cuttingLineBetweetMainViewAndProfileView;

    [ navBar setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ horizontalCuttingLine setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ stackContentView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ dashboardView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ profileView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ verticalCuttingLine setTranslatesAutoresizingMaskIntoConstraints: NO ];

    [ self.view addSubview: navBar ];
    [ self.view addSubview: horizontalCuttingLine ];
    [ self.view addSubview: stackContentView ];
    [ self.view addSubview: dashboardView ];

    NSDictionary* viewsDict =
        NSDictionaryOfVariableBindings( navBar, horizontalCuttingLine, stackContentView, dashboardView, profileView, verticalCuttingLine );

    if ( !self->_isShowingProfile )
        {
        NSArray* horizontalConstraints0 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)][navBar(>=navBarWidth)]|"
                                options: 0
                                metrics: @{ @"dashboardViewWidth" : @( dashboardView.minimumSizeInNib.width )
                                          , @"navBarWidth" : @( navBar.minimumSizeInNib.width )
                                          , @"cuttingLineWidth" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"stackContentViewWidth" : @( stackContentView.minimumSizeInNib.width )
                                          }
                                  views: viewsDict ];

        NSArray* horizontalConstraints1 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)][horizontalCuttingLine(==navBar)]|"
                                options: 0
                                metrics: @{ @"dashboardViewWidth" : @( dashboardView.minimumSizeInNib.width ) }
                                  views: viewsDict ];

        NSArray* horizontalConstraints2 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)][stackContentView(==navBar)]|"
                                options: 0
                                metrics: @{ @"dashboardViewWidth" : @( dashboardView.minimumSizeInNib.width ) }
                                  views: viewsDict ];


        NSArray* verticalConstraints0 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|[dashboardView(>=dashboardViewHeight)]|"
                                options: 0
                                metrics: @{ @"dashboardViewHeight" : @( dashboardView.minimumSizeInNib.height )
                                          , @"navBarHeight" : @( navBar.minimumSizeInNib.height )
                                          , @"cuttingLineWidth" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"stackContentViewHeight" : @( stackContentView.minimumSizeInNib.height )
                                          }
                                  views: viewsDict ];

        NSArray* verticalConstraints1 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|[navBar(==navBarHeight)][horizontalCuttingLine(==cuttingLineHeight)][stackContentView(>=stackContentViewHeight)]|"
                                options: 0
                                metrics: @{ @"navBarHeight" : @( navBar.minimumSizeInNib.height )
                                          , @"cuttingLineHeight" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"stackContentViewHeight" : @( stackContentView.minimumSizeInNib.height )
                                          }
                                  views: viewsDict ];

        [ self.view addConstraints: horizontalConstraints0 ];
        [ self.view addConstraints: horizontalConstraints1 ];
        [ self.view addConstraints: horizontalConstraints2 ];
        [ self.view addConstraints: verticalConstraints0 ];
        [ self.view addConstraints: verticalConstraints1 ];
        }
    else
        {
        [ self.view addSubview: profileView ];
        [ self.view addSubview: verticalCuttingLine ];

        NSArray* horizontalConstraints0 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)]"
                                          "[navBar(>=navBarWidth)]"
                                          "[verticalCuttingLine(==cuttingLineWidth)]"
                                          "[profileView(==profileViewWidth)]|"
                                options: 0
                                metrics: @{ @"dashboardViewWidth" : @( dashboardView.minimumSizeInNib.width )
                                          , @"navBarWidth" : @( navBar.minimumSizeInNib.width )
                                          , @"cuttingLineWidth" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"profileViewWidth" : @( profileView.minimumSizeInNib.width )
                                          }
                                  views: viewsDict ];

        NSArray* horizontalConstraints1 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)]"
                                          "[horizontalCuttingLine(==navBar)]"
                                          "[verticalCuttingLine(==cuttingLineWidth)]"
                                          "[profileView(==profileViewWidth)]|"
                                options: 0
                                metrics: @{ @"dashboardViewWidth" : @( dashboardView.minimumSizeInNib.width )
                                          , @"cuttingLineWidth" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"profileViewWidth" : @( profileView.minimumSizeInNib.width )
                                          }
                                  views: viewsDict ];

        NSArray* horizontalConstraints2 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)]"
                                          "[stackContentView(==navBar)]"
                                          "[verticalCuttingLine(==cuttingLineWidth)]"
                                          "[profileView(==profileViewWidth)]|"
                                options: 0
                                metrics: @{ @"dashboardViewWidth" : @( dashboardView.minimumSizeInNib.width )
                                          , @"cuttingLineWidth" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"profileViewWidth" : @( profileView.minimumSizeInNib.width )
                                          }
                                  views: viewsDict ];

        NSArray* verticalConstraints0 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|[dashboardView(>=dashboardViewHeight)]|"
                                options: 0
                                metrics: @{ @"dashboardViewHeight" : @( dashboardView.minimumSizeInNib.height ) }
                                  views: viewsDict ];

        NSArray* verticalConstraints1 = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|[navBar(==navBarHeight)][horizontalCuttingLine(==cuttingLineHeight)][stackContentView(>=stackContentViewHeight)]|"
                                options: 0
                                metrics: @{ @"navBarHeight" : @( navBar.minimumSizeInNib.height )
                                          , @"cuttingLineHeight" : @( horizontalCuttingLine.minimumSizeInNib.height )
                                          , @"stackContentViewHeight" : @( stackContentView.minimumSizeInNib.height )
                                          }
                                  views: viewsDict ];

        NSArray* heightConstraintsVerticalCuttingLine = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|[verticalCuttingLine(>=verticalCuttingLineHeight)]|"
                                options: 0
                                metrics: @{ @"verticalCuttingLineHeight" : @( verticalCuttingLine.minimumSizeInNib.height ) }
                                  views: viewsDict ];

        NSArray* heightConstraintsProfileView = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|[profileView(>=profileViewHeight)]|"
                                options: 0
                                metrics: @{ @"profileViewHeight" : @( profileView.minimumSizeInNib.height ) }
                                  views: viewsDict ];

        [ self.view addConstraints: horizontalConstraints0 ];
        [ self.view addConstraints: horizontalConstraints1 ];
        [ self.view addConstraints: horizontalConstraints2 ];
        [ self.view addConstraints: verticalConstraints0 ];
        [ self.view addConstraints: verticalConstraints1 ];
        [ self.view addConstraints: heightConstraintsVerticalCuttingLine ];
        [ self.view addConstraints: heightConstraintsProfileView ];
        }
    }

- ( BOOL ) isShowingProfile
    {
    return self->_isShowingProfile;
    }

#pragma mark Private Interfaces
- ( void ) _showUserProfile: ( NSNotification* )_Notif
    {
    OTCTwitterUser* twitterUser = _Notif.userInfo[ kTwitterUser ];
    [ self.twitterUserProfileViewController setTwitterUser: twitterUser ];

    [ self setShowingProfile: YES ];
    }

- ( void ) _hideUserProfile: ( NSNotification* )_Notif
    {
    [ self setShowingProfile: NO ];
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