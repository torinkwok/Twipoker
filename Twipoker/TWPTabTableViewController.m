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

#import "TWPTabTableViewController.h"
#import "TWPTabTableCellView.h"
#import "TWPTabTableView.h"

@implementation TWPTabTableViewController

@synthesize associatedHomeTimelineScrollViewController;
@synthesize associatedFavoritesTimelineScrollViewController;
@synthesize associatedListsTimelineScrollViewController;
@synthesize associatedNotificationsTimelineScrollViewController;
@synthesize associatedMeTimelineScrollViewController;
@synthesize associatedMessagesTimelineScrollViewController;

- ( id ) init
    {
    if ( self = [ super init ] )
        {
        self->_tabLabels = @[ NSLocalizedString( @"Home", nil )
                            , NSLocalizedString( @"Favorites", nil )
                            , NSLocalizedString( @"Lists", nil )
                            , NSLocalizedString( @"Notifications", nil )
                            , NSLocalizedString( @"Me", nil )
                            , NSLocalizedString( @"Messages", nil )
                            ];
        }

    return self;
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_tabLabels.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: @"tab" ] )
        result = self->_tabLabels[ _Row ];

    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    TWPTabTableCellView* resultView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];
    [ resultView.textField setStringValue: self->_tabLabels[ _Row ] ];

    switch ( _Row )
        {
        case TWPTabTableRowHome: resultView.associatedViewController = self.associatedHomeTimelineScrollViewController; break;
        case TWPTabTableRowFavorites: resultView.associatedViewController = self.associatedFavoritesTimelineScrollViewController; break;
        case TWPTabTableRowLists: resultView.associatedViewController = self.associatedListsTimelineScrollViewController; break;
        case TWPTabTableRowNotifications: resultView.associatedViewController = self.associatedNotificationsTimelineScrollViewController; break;
        case TWPTabTableRowMe: resultView.associatedViewController = self.associatedMeTimelineScrollViewController; break;
        case TWPTabTableRowMessages: resultView.associatedViewController = self.associatedMessagesTimelineScrollViewController; break;
        }

    return resultView;
    }

- ( void ) tableViewSelectionDidChange: ( NSNotification* )_Notif
    {
    TWPTabTableView* tabTableView = ( TWPTabTableView* )[ _Notif object ];
    NSTableColumn* currentTableColumn = [ tabTableView tableColumnWithIdentifier: @"tab" ];
    TWPTabTableRow selectedRow = ( TWPTabTableRow )[ tabTableView selectedRow ];

    TWPTabTableCellView* cellView = ( TWPTabTableCellView* )[ tabTableView.delegate
        tableView: tabTableView viewForTableColumn: currentTableColumn row: ( NSInteger )selectedRow ];

    NSNotification* notification = [ NSNotification notificationWithName: TWPTabTableViewSelectedTabChanged
                                                                  object: self
                                                                userInfo: @{ @"tab-cell-view" : cellView } ];

    [ [ NSNotificationCenter defaultCenter ] postNotification: notification ];
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