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

#import "TWPBrain.h"
#import "TWPDirectMessagesPreviewViewController.h"
#import "TWPDirectMessageSession.h"
#import "TWPDirectMessagesCoordinator.h"
#import "TWPLoginUsersManager.h"
#import "TWPDirectMessagePreviewTableCellView.h"
#import "TWPUserAvatarWell.h"

@interface TWPDirectMessagesPreviewViewController ()

@end

@implementation TWPDirectMessagesPreviewViewController

@synthesize DMPreviewTableView;

- ( void ) updateDMs
    {
    self->_directMessageSessions = [ [ TWPDirectMessagesCoordinator defaultCenter ] allDirectMessageSessions ];
    [ self.DMPreviewTableView reloadData ];
    }

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPDirectMessageSessionView" bundle: [ NSBundle mainBundle ] ] )
        self->_directMessageSessions = [ NSArray array ];

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_directMessageSessions.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = [ self->_directMessageSessions objectAtIndex: _Row ];
    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    TWPDirectMessagePreviewTableCellView* previewCellView =
        ( TWPDirectMessagePreviewTableCellView* )[ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    TWPDirectMessageSession* DMSession = ( TWPDirectMessageSession* )( self->_directMessageSessions[ _Row ] );
    previewCellView.session = DMSession;

    return previewCellView;
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