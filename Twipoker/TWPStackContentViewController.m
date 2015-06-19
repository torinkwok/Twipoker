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

#import "TWPStackContentViewController.h"
#import "TWPStackContentView.h"
#import "TWPDashboardView.h"
#import "TWPViewsStack.h"
#import "TWPNavigationBar.h"
#import "TWPTwitterUserViewController.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPTwitterUserViewController.h"
#import "TWPNavigationBarController.h"
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

// KVO Key Paths
NSString* const TWPStackContentViewControllerCurrentDashboardStackKeyPath = @"self.currentDashboardStack";

// Receiving Notification Names
NSString* const TWPStackContentViewShouldShowUserTweets = @"StackContentView.Notif.ShowUserTweets";

// Notification User Info Keys
NSString* const kTwitterUser = @"StackContentView.Notif.UserInfoKey.TwitterUser";
NSString* const kTwitterList = @"StackContentView.Notif.UserInfoKey.TwitterList";
NSString* const kDirectMessageSession = @"StackContentView.Notif.UserInfoKey.DirectMessageSession";

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

@synthesize navigationBarController;

@synthesize homeDashboardStack;
@synthesize favoritesDashboardStack;
@synthesize listsDashboardStack;
@synthesize notificationsDashboardStack;
@synthesize meDashboardStack;
@synthesize messagesDashboardStack;

@synthesize currentDashboardStack;

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _listCellMouseDown: ) name: TWPListCellViewMouseDown object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _dmPreviewTableCellMouseDown: ) name: TWPDirectMessagePreviewTableCellViewMouseDown object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _shouldShowUserTweets: ) name: TWPStackContentViewShouldShowUserTweets object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPListCellViewMouseDown object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPDirectMessagePreviewTableCellViewMouseDown object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPStackContentViewShouldShowUserTweets object: nil ];
    }

- ( void ) viewWillAppear
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
        , ( dispatch_block_t )^( void )
            {
            self.currentDashboardStack = self.homeDashboardStack;
            self.navigationBarController.delegate = self.currentDashboardStack;
            } );
    }

NSString static* const kColumnIDTabs = @"tabs";

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_dashboardTabIcons.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: kColumnIDTabs ] )
        result = self->_dashboardTabIcons[ _Row ];

    return result;
    }

#pragma mark Conforms to <TWPDashboardViewDelegate>
- ( void ) dashboardView: ( TWPDashboardView* )_DashboardView
    selectedTabDidChange: ( TWPDashboardTab* )_NewSelectedTab
    {
    TWPViewsStack* associatedViewsStack = [ _NewSelectedTab associatedViewsStack ];

    // self.view is observing this key path,
    // it will be notified after assignment then make appropriate adjustments
    self.currentDashboardStack = associatedViewsStack;
    self.navigationBarController.delegate = self.currentDashboardStack;
    }

#pragma mark IBActions
- ( IBAction ) goBackAction: ( id )_Sender
    {
    [ self.currentDashboardStack backwardMoveCursor ];
    self.currentDashboardStack = self.currentDashboardStack;
    [ self.navigationBarController reload ];
    }

- ( IBAction ) goForwardAction: ( id )_Sender
    {
    [ self.currentDashboardStack forwardMoveCursor ];
    self.currentDashboardStack = self.currentDashboardStack;
    [ self.navigationBarController reload ];
    }

#pragma mark Private Interfaces
// Notification selector
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
- ( void ) _pushViewIntoViewsStack: ( NSViewController* )_ViewContorller
    {
    [ self.currentDashboardStack pushView: _ViewContorller ];
    self.currentDashboardStack = self.currentDashboardStack;
    [ self.navigationBarController reload ];
    }

- ( void ) _pushUserTimleineToCurrentViewsStack: ( OTCTwitterUser* )_TwitterUser
    {
    NSViewController* twitterUserViewNewController =
        [ TWPTwitterUserViewController twitterUserViewControllerWithTwitterUser: _TwitterUser ];

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