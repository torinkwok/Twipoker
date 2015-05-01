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
#import "TWPDashboardCellView.h"
#import "TWPViewsStack.h"
#import "TWPNavigationBar.h"

// KVO Key Path
NSString* const TWPStackContentViewControllerCurrentDashboardStackKeyPath = @"self.currentDashboardStack";

#pragma mark TWPStackContentViewController + Private Category
@interface TWPStackContentViewController ()

// `currentDashboardStack` property was set as read only in the declaration.
// Make it internally writable.
@property ( weak, readwrite ) TWPViewsStack* currentDashboardStack;

@end // TWPStackContentViewController + Private Category

@implementation TWPStackContentViewController

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
        self->_dashboardTabs = @[ NSLocalizedString( @"Home", nil )
                                , NSLocalizedString( @"Favorites", nil )
                                , NSLocalizedString( @"Lists", nil )
                                , NSLocalizedString( @"Notifications", nil )
                                , NSLocalizedString( @"Me", nil )
                                , NSLocalizedString( @"Messages", nil )
                                ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    self.currentDashboardStack = self.homeDashboardStack;
    }

NSString static* const kColumnIDTabs = @"tabs";

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_dashboardTabs.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: kColumnIDTabs ] )
        result = self->_dashboardTabs[ _Row ];

    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    TWPDashboardCellView* dashboardCellView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    NSString* tabName = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    [ dashboardCellView.textField setStringValue: tabName ];

    TWPViewsStack* viewsStack = nil;
    switch ( _Row )
        {
        case 0: viewsStack = self.homeDashboardStack; break;
        case 1: viewsStack = self.favoritesDashboardStack; break;
        case 2: viewsStack = self.listsDashboardStack; break;
        case 3: viewsStack = self.notificationsDashboardStack; break;
        case 4: viewsStack = self.meDashboardStack; break;
        case 5: viewsStack = self.messagesDashboardStack; break;
        }

    dashboardCellView.associatedViewsStack = viewsStack;

    // TODO: [ cellView.imageView set... ];

    return dashboardCellView;
    }

- ( void ) tableViewSelectionDidChange: ( NSNotification* )_Notif
    {
    NSTableView* tabTableView = [ _Notif object ];
    NSTableColumn* currentTableColumn = [ tabTableView tableColumnWithIdentifier: @"tabs" ];
    NSInteger selectedRow = [ tabTableView selectedRow ];

    TWPDashboardCellView* cellView = ( TWPDashboardCellView* )[ tabTableView.delegate
        tableView: tabTableView viewForTableColumn: currentTableColumn row: ( NSInteger )selectedRow ];

    TWPViewsStack* associatedViewsStack = [ cellView associatedViewsStack ];

    // self.view is observing this key path,
    // it will be notified after assignment then make appropriate adjustments
    self.currentDashboardStack = associatedViewsStack;
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