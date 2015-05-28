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

#import "TWPDirectMessagesPreviewViewController.h"
#import "TWPDirectMessageSession.h"
#import "TWPDirectMessagesCoordinator.h"
#import "TWPBrain.h"
#import "TWPLoginUsersManager.h"
#import "TWPDirectMessagePreviewTableCellView.h"
#import "TWPUserAvatarWell.h"

@interface TWPDirectMessagesPreviewViewController ()

@end

@implementation TWPDirectMessagesPreviewViewController

@synthesize DMPreviewTableView;

int static sCounter;
- ( void ) updateDMs: ( NSArray* )_DMs
    {
    sCounter++;
    NSString* currentTwitterUserID = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID;
    NSMutableArray* otherSideUsers = [ NSMutableArray array ];

    for ( OTCDirectMessage* _DM in _DMs )
        {
        if ( ![ _DM.recipient.IDString isEqualToString: currentTwitterUserID ] )
            if ( ![ otherSideUsers containsObject: _DM.recipient ] )
                [ otherSideUsers addObject: _DM.recipient ];

        if ( ![ _DM.sender.IDString isEqualToString: currentTwitterUserID ] )
            if ( ![ otherSideUsers containsObject: _DM.sender ] )
                [ otherSideUsers addObject: _DM.sender ];
        }

    for ( OTCTwitterUser* _OtherSideUser in otherSideUsers )
        {
        TWPDirectMessageSession* session = [ TWPDirectMessageSession sessionWithOtherSideUser: _OtherSideUser ];
        if ( session )
            {
            if ( ![ self->_directMessageSessions containsObject: session ] )
                [ self->_directMessageSessions addObject: session ];
            else
                {
                NSUInteger index = [ self->_directMessageSessions indexOfObject: session ];
                [ self->_directMessageSessions[ index ] reloadMessages ];
                }
            }
        }

    [ self.DMPreviewTableView reloadData ];
    }

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPDirectMessageSessionView" bundle: [ NSBundle mainBundle ] ] )
        self->_directMessageSessions = [ NSMutableArray array ];

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