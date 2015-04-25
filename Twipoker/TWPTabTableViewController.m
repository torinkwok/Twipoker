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
        self->_tabLabels = @[ NSLocalizedString( @"Timeline", nil )
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
        case 0: resultView.associatedViewController = self.associatedHomeTimelineScrollViewController; break;
        case 1: resultView.associatedViewController = self.associatedFavoritesTimelineScrollViewController; break;
        case 2: resultView.associatedViewController = self.associatedListsTimelineScrollViewController; break;
        case 3: resultView.associatedViewController = self.associatedNotificationsTimelineScrollViewController; break;
        case 4: resultView.associatedViewController = self.associatedMeTimelineScrollViewController; break;
        case 5: resultView.associatedViewController = self.associatedMessagesTimelineScrollViewController; break;
        }

    return resultView;
    }

- ( void ) tableViewSelectionDidChange: ( NSNotification* )_Notif
    {
    NSLog( @"Selected Index: %ld", [ ( NSTableView* )_Notif.object selectedRow ] );
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