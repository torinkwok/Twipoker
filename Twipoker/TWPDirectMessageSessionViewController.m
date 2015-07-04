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

#import "TWPDirectMessageSessionViewController.h"
#import "TWPDirectMessageSession.h"
#import "TWPDirectMessageSessionCellView.h"
#import "TWPDirectMessageSessionView.h"

#import "NSString+Twipoker.h"

// Private Interfaces
@interface TWPDirectMessageSessionViewController ()
- ( void ) _sendDMInTextView: ( NSTextView* )_TextView;
@end // Private Interfaces

// TWPDirectMessageSessionViewController class
@implementation TWPDirectMessageSessionViewController

@synthesize sessionTableView;
@synthesize inputBox;

#pragma mark Initializations
+ ( instancetype ) sessionViewControllerWithSession: ( TWPDirectMessageSession* )_DMSession
                                   withTotemContent: ( id )_TotemContent
    {
    return [ [ [ self class ] alloc ] initWithSession: _DMSession withTotemContent: _TotemContent ];
    }

- ( instancetype ) initWithSession: ( TWPDirectMessageSession* )_DMSession
                  withTotemContent: ( id )_TotemContent

    {
    if ( self = [ super initWithNibName: @"TWPDirectMessagesSessionView" bundle: [ NSBundle mainBundle ] ] )
        {
        self->_session = _DMSession;
        [ self setTotemContent: _TotemContent ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    [ [ TWPDirectMessagesCoordinator defaultCenter ] registerObserver: self otherSideUser: self->_session.otherSideUser ];
    }

- ( void ) dealloc
    {
    [ [ TWPDirectMessagesCoordinator defaultCenter ] removeObserver: self ];
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return [ self->_session allDirectMessages ].count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = self->_session.allDirectMessages[ _Row ];
    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    TWPDirectMessageSessionCellView* sessionCellView =
        ( TWPDirectMessageSessionCellView* )[ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    OTCDirectMessage* dm = self->_session.allDirectMessages[ _Row ];
    sessionCellView.directMessage = dm;

    return sessionCellView;
    }

- ( BOOL ) tableView: ( NSTableView* )_TableView
     shouldSelectRow: ( NSInteger )_Row
    {
    return NO;
    }

#pragma mark Conforms to <TWPDirectMessagesCoordinatorObserver>
- ( void )       coordinator: ( TWPDirectMessagesCoordinator* )_Coordinator
    didUpdateSessionWithUser: ( OTCTwitterUser* )_OtherSideUser
    {
    [ self->_session reloadMessages ];
    [ self.sessionTableView reloadData ];
    }

- ( BOOL )     textView: ( NSTextView* )_TextView
    doCommandBySelector: ( SEL )_Selector
    {
    if ( _Selector == @selector( insertNewline: ) )
        {
        [ self _sendDMInTextView: _TextView ];

        // This class will handle the insertNewLine: command by invoking _sendDMInTextView: method
        // and the _TextView will not attempt to perform it.
        return YES;
        }

    return NO;
    }

#pragma mark Private Interfaces
- ( void ) _sendDMInTextView: ( NSTextView* )_TextView
    {
    NSString* message = _TextView.string;

    if ( [ message hasAtLeastOneNonChar: @" " ] )
        {
        [ self->_session sendMessage: message recipientID: self->_session.otherSideUser.ID ];
        [ _TextView setString: @"" ];
        }
    }

@end // TWPDirectMessageSessionViewController class

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