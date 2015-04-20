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

#import "TWPDebugLoginUsersViewController.h"
#import "TWPLoginUsersManager.h"

@implementation TWPDebugLoginUsersViewController
    {
    NSArray __strong* _copiesOfAllLoginUsers;
    }

#pragma mark Confomrs to <MASPreferencesViewController>
@dynamic identifier;
@dynamic toolbarItemImage;
@dynamic toolbarItemLabel;

- ( void ) loginUsersManagerDidFinishAddingNewLoginUser: ( NSNotification* )_Notif
    {
    self->_copiesOfAllLoginUsers = [ [ TWPLoginUsersManager sharedManager ] copiesOfAllLoginUsers ];
    }

- ( void ) loginUsersManagerDidFinishRemovingAllLoginUsers: ( NSNotification* )_Notif
    {
    self->_copiesOfAllLoginUsers = [ [ TWPLoginUsersManager sharedManager ] copiesOfAllLoginUsers ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPDebugLoginUsersView" bundle: [ NSBundle mainBundle ] ] )
        {
        self->_copiesOfAllLoginUsers = [ [ TWPLoginUsersManager sharedManager ] copiesOfAllLoginUsers ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( loginUsersManagerDidFinishAddingNewLoginUser: )
                                                        name: TWPLoginUsersManagerDidFinishAddingNewLoginUser
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( loginUsersManagerDidFinishRemovingAllLoginUsers: )
                                                        name: TWPLoginUsersManagerDidFinishRemovingAllLoginUsers
                                                      object: nil ];
        }

    return self;
    }

- ( NSString* ) identifier
    {
    return @"home.bedroom.TongGuo.Twipoker.UI.DebugConsole.LoginUsers";
    }

- ( NSImage* ) toolbarItemImage
    {
    return [ NSImage imageNamed: NSImageNameEveryone ];
    }

- ( NSString* ) toolbarItemLabel
    {
    return NSLocalizedString( @"Users", nil );
    }

#pragma mark Confomrs to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return self->_copiesOfAllLoginUsers.count;
    }

- ( id )            tableView: ( NSTableView* )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: @"user-id" ] )
        result = [ ( TWPLoginUser* )self->_copiesOfAllLoginUsers[ _Row ] userID ];
    else if ( [ _TableColumn.identifier isEqualToString: @"oauth-access-token" ] )
        result = [ ( TWPLoginUser* )self->_copiesOfAllLoginUsers[ _Row ] OAuthToken ];
    else if ( [ _TableColumn.identifier isEqualToString: @"oauth-access-token-secret" ] )
        result = [ ( TWPLoginUser* )self->_copiesOfAllLoginUsers[ _Row ] OAuthTokenSecret ];

    return result;
    }

#pragma mark Confomrs to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    NSView* resultView = nil;

    if ( [ _TableColumn.identifier isEqualToString: @"user-id" ] )
        {
        resultView = [ _TableView makeViewWithIdentifier: @"user-id" owner: self ];
        [ [ ( NSTableCellView* )resultView textField ] setStringValue: [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ] ];
        }
    else if ( [ _TableColumn.identifier isEqualToString: @"oauth-access-token" ] )
        {
        resultView = [ _TableView makeViewWithIdentifier: @"oauth-access-token" owner: self ];
        [ [ ( NSTableCellView* )resultView textField ] setStringValue: [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ] ];
        }
    else if ( [ _TableColumn.identifier isEqualToString: @"oauth-access-token-secret" ] )
        {
        resultView = [ _TableView makeViewWithIdentifier: @"oauth-access-token-secret" owner: self ];
        [ [ ( NSTableCellView* )resultView textField ] setStringValue: [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ] ];
        }

    return resultView;
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