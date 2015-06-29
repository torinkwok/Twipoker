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

#import "TWPActionNotifications.h"
#import "TWPStackContentViewController.h"
#import "TWPStackContentView.h"
#import "TWPDashboardView.h"
#import "TWPViewsStack.h"
#import "TWPTwitterUserViewController.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPTwitterUserViewController.h"

#import "TWPRepliesTimelineViewController.h"
#import "TWPTweetCellView.h"
#import "TWPTweetTextField.h"
#import "TWPListCellView.h"
#import "TWPTwitterListTimelineViewController.h"
#import "TWPDirectMessageSession.h"
#import "TWPLoginUsersManager.h"
#import "TWPDirectMessagesCoordinator.h"
#import "TWPDirectMessagePreviewTableCellView.h"
#import "TWPDirectMessageSessionViewController.h"
#import "TWPDashboardTab.h"
#import "TWPDashboardView.h"
#import "TWPTimelineScrollView.h"

#import "NSView+TwipokerAutoLayout.h"

// Private Interfaces
@interface TWPStackContentViewController ()

// `currentDashboardStack` property was set as read only in the declaration.
// Make it internally writable.
@property ( weak, readwrite ) TWPViewsStack* currentDashboardStack;

// Notification selector
- ( void ) _listCellMouseDown: ( NSNotification* )_Notif;
- ( void ) _dmPreviewTableCellMouseDown: ( NSNotification* )_Notif;
- ( void ) _shouldShowUserTweets: ( NSNotification* )_Notif;

// Pushing views
- ( void ) _pushViewIntoViewsStack: ( NSViewController* )_ViewContorller;
- ( void ) _pushUserTimleineToCurrentViewsStack: ( OTCTwitterUser* )_TwitterUser;
- ( void ) _pushTwitterListTimelineToCurrentViewsStack: ( OTCList* )_TwitterList;
- ( void ) _pushDirectMessageSessionViewToCurrentViewStack: ( TWPDirectMessageSession* )_DirectMessageSession;

@end // Private Interfaces

// TWPStackContentViewController class
@implementation TWPStackContentViewController

@synthesize homeDashboardStack;
@synthesize favoritesDashboardStack;
@synthesize listsDashboardStack;
@synthesize notificationsDashboardStack;
@synthesize meDashboardStack;
@synthesize messagesDashboardStack;

@dynamic currentDashboardStack;

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _listCellMouseDown: ) name: TWPListCellViewMouseDown object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _dmPreviewTableCellMouseDown: ) name: TWPDirectMessagePreviewTableCellViewMouseDown object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _shouldShowUserTweets: ) name: /*TWPTwipokerShouldShowUserTweets*/ TWPTwipokerShouldShowUserProfile object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPListCellViewMouseDown object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPDirectMessagePreviewTableCellViewMouseDown object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPTwipokerShouldShowUserTweets object: nil ];
    }

- ( void ) viewWillAppear
    {
    self.currentDashboardStack = self.homeDashboardStack;
    }

#pragma mark Conforms to <TWPDashboardViewDelegate>
- ( void ) setCurrentDashboardStack: ( TWPViewsStack* )_CurrentDashboardStack
    {
    self->_currentDashboardStack = _CurrentDashboardStack;

    [ self.view removeConstraints: self.view.constraints ];
    [ self.view setSubviews: @[] ];

    TWPTimelineScrollView* docView = ( TWPTimelineScrollView* )( self->_currentDashboardStack.currentView.view );
    [ docView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.view addSubview: docView ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( docView );
    NSArray* horizontalConstraints = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|[docView(>=docViewWidth)]|"
                            options: 0
                            metrics: @{ @"docViewWidth" : @( docView.minimumSizeInNib.width ) }
                              views: viewsDict ];

    NSArray* verticalConstraints = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|[docView(>=currentViewHeight)]|"
                            options: 0
                            metrics: @{ @"currentViewHeight" : @( docView.minimumSizeInNib.height ) }
                              views: viewsDict ];

    [ self.view addConstraints: horizontalConstraints ];
    [ self.view addConstraints: verticalConstraints ];

    [ self.navBarController reload ];
    }

- ( TWPViewsStack* ) currentDashboardStack
    {
    return self->_currentDashboardStack;
    }

#pragma mark Conforms to <TWPDashboardViewDelegate>
- ( void ) dashboardView: ( TWPDashboardView* )_DashboardView
    selectedTabDidChange: ( TWPDashboardTab* )_NewSelectedTab
    {
    TWPViewsStack* associatedViewsStack = [ _NewSelectedTab associatedViewsStack ];

    // self.view is observing this key path,
    // it will be notified after assignment then make appropriate adjustments
    self.currentDashboardStack = associatedViewsStack;
    }

#pragma mark IBActions
- ( IBAction ) goBackAction: ( id )_Sender
    {
    [ self.currentDashboardStack popView ];
    self.currentDashboardStack = self.currentDashboardStack;
    }

#pragma mark Private Interfaces
// Notification selectors
- ( void ) _listCellMouseDown: ( NSNotification* )_Notif
    {
    OTCList* twitterList = _Notif.userInfo[ kTwitterList ];
    [ self _pushTwitterListTimelineToCurrentViewsStack: twitterList ];
    }

- ( void ) _dmPreviewTableCellMouseDown: ( NSNotification* )_Notif
    {
    TWPDirectMessageSession* directMessageSession = _Notif.userInfo[ kDirectMessageSession ];
    [ self _pushDirectMessageSessionViewToCurrentViewStack: directMessageSession ];
    }

- ( void ) _shouldShowUserTweets: ( NSNotification* )_Notif
    {
    OTCTwitterUser* twitterUser = _Notif.userInfo[ kTwitterUser ];
    [ self _pushUserTimleineToCurrentViewsStack: twitterUser ];
    }

// Pushing views
- ( void ) _pushViewIntoViewsStack: ( TWPViewController* )_ViewContorller
    {
    [ self.currentDashboardStack pushView: _ViewContorller ];
    self.currentDashboardStack = self.currentDashboardStack;
    }

- ( void ) _pushUserTimleineToCurrentViewsStack: ( OTCTwitterUser* )_TwitterUser
    {
    NSViewController* twitterUserViewNewController =
        [ TWPTwitterUserViewController twitterUserViewControllerWithTwitterUser: _TwitterUser
                                                                   totemContent: _TwitterUser.screenName ];

    [ self _pushViewIntoViewsStack: twitterUserViewNewController ];
    }

- ( void ) _pushTwitterListTimelineToCurrentViewsStack: ( OTCList* )_TwitterList
    {
    NSViewController* twitterListTimelineNewController =
        [ TWPTwitterListTimelineViewController twitterListViewControllerWithTwitterList: _TwitterList ];

    [ self _pushViewIntoViewsStack: twitterListTimelineNewController ];
    }

- ( void ) _pushDirectMessageSessionViewToCurrentViewStack: ( TWPDirectMessageSession* )_DirectMessageSession
    {
    NSViewController* dmSessionViewNewController =
        [ TWPDirectMessageSessionViewController sessionViewControllerWithSession: _DirectMessageSession ];

    [ self _pushViewIntoViewsStack: dmSessionViewNewController ];
    }

#pragma mark Conforms to <TWPNavBarControllerDelegate>
- ( id ) totemContent
    {
    return self.currentDashboardStack.currentView.totemContent;
    }

- ( id ) navBarBackButtonTitleContent
    {
    return self.currentDashboardStack.viewBeforeCurrentView.totemContent;
    }

- ( BOOL ) atTheEnd
    {
    return self.currentDashboardStack.viewsStack.count == 0;
    }

@end // TWPStackContentViewController class

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