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

#pragma mark TWPStackContentViewController + Private Category
@interface TWPStackContentViewController ()

// `currentDashboardStack` property was set as read only in the declaration.
// Make it internally writable.
@property ( weak, readwrite ) TWPViewsStack* currentDashboardStack;

@end // TWPStackContentViewController + Private Category

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
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( shouldDisplayDetailOfTweet: )
                                                        name: TWPTweetCellViewShouldDisplayDetailOfTweet
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _listCellMouseDown: )
                                                        name: TWPListCellViewMouseDown
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _dmPreviewTableCellMouseDown: )
                                                        name: TWPDirectMessagePreviewTableCellViewMouseDown
                                                      object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPTweetCellViewShouldDisplayDetailOfTweet object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPListCellViewMouseDown object: nil ];
    }

- ( void ) shouldDisplayDetailOfTweet: ( NSNotification* )_Notif
    {
    NSLog( @"%@", _Notif );
//    OTCTweet* tweet = _Notif.userInfo[ TWPTweetCellViewTweetUserInfoKey ];
//    TWPRepliesTimelineViewController* newView = [ TWPRepliesTimelineViewController repliesTimelineViewControllerWithTweet: tweet ];
//    [ self _pushViewIntoViewsStack: newView ];
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
- ( void ) _pushViewIntoViewsStack: ( NSViewController* )_ViewContorller
    {
    [ self.currentDashboardStack pushView: _ViewContorller ];
    self.currentDashboardStack = self.currentDashboardStack;
    [ self.navigationBarController reload ];
    }

- ( void ) _listCellMouseDown: ( NSNotification* )_Notif
    {
    [ self pushTwitterListTimelineToCurrentViewsStackAction: ( TWPListCellView* )( _Notif.object ) ];
    }

- ( void ) _dmPreviewTableCellMouseDown: ( NSNotification* )_Notif
    {
    [ self pushDirectMessageSessionViewToCurrentViewStackAction: ( TWPDirectMessagePreviewTableCellView* )( _Notif.object ) ];
    }

- ( IBAction ) pushUserTimleineToCurrentViewsStackAction: ( id )_Sender
    {
    OTCTwitterUser* twitterUser = [ _Sender twitterUser ];

    NSViewController* twitterUserViewNewController =
        [ TWPTwitterUserViewController twitterUserViewControllerWithTwitterUser: twitterUser ];

    [ self _pushViewIntoViewsStack: twitterUserViewNewController ];
    }

- ( IBAction ) pushRepliesTimleineToCurrentViewsStackAction: ( id )_Sender
    {
//    NSViewController* newRepliesTimelineViewController =
//        [ TWPRepliesTimelineViewController repliesTimelineViewControllerWithTweet: [ ( TWPTweetTextField* )_Sender tweet ] ];
//
//    [ self _pushViewIntoViewsStack: newRepliesTimelineViewController ];
    }

- ( IBAction ) pushTwitterListTimelineToCurrentViewsStackAction: ( id )_Sender
    {
    NSViewController* twitterListTimelineNewController =
        [ TWPTwitterListTimelineViewController twitterListViewControllerWithTwitterList: [ ( TWPListCellView* )_Sender twitterList ] ];

    [ self _pushViewIntoViewsStack: twitterListTimelineNewController ];
    }

- ( IBAction ) pushDirectMessageSessionViewToCurrentViewStackAction: ( id )_Sender
    {
//    [ self.dashboardView selectRowIndexes: [ NSIndexSet indexSetWithIndex: 5 ] byExtendingSelection: NO ];

    NSViewController* dmSessionViewNewController =
        [ TWPDirectMessageSessionViewController sessionViewControllerWithSession: [ ( TWPDirectMessagePreviewTableCellView* )_Sender session ] ];

    [ self _pushViewIntoViewsStack: dmSessionViewNewController ];
    }

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