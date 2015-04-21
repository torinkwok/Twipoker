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
#import "TWPDebugLoginUsersView.h"

#pragma mark TWPDebugLoginUsersViewController + Private
@interface TWPDebugLoginUsersViewController ()
@end // TWPDebugLoginUsersViewController + Private

#pragma mark TWPDebugLoginUsersViewController
@implementation TWPDebugLoginUsersViewController
    {
    NSArray __strong* _copiesOfAllLoginUsers;
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
                                                    selector: @selector( loginUsersManagerDidFinishRemovingLoginUser: )
                                                        name: TWPLoginUsersManagerDidFinishRemovingLoginUser
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( loginUsersManagerDidFinishRemovingAllLoginUsers: )
                                                        name: TWPLoginUsersManagerDidFinishRemovingAllLoginUsers
                                                      object: nil ];
        }

    return self;
    }

- ( void ) loginUsersManagerDidFinishAddingNewLoginUser: ( NSNotification* )_Notif
    {
    self->_copiesOfAllLoginUsers = [ [ TWPLoginUsersManager sharedManager ] copiesOfAllLoginUsers ];
    [ self.loginUsersTableView reloadData ];
    }

- ( void ) loginUsersManagerDidFinishRemovingLoginUser: ( NSNotification* )_Notif
    {
    self->_copiesOfAllLoginUsers = [ [ TWPLoginUsersManager sharedManager ] copiesOfAllLoginUsers ];
    [ self.loginUsersTableView reloadData ];

    if ( ![ _Notif.userInfo[ TWPNumberOfRemainingLoginUsersUserInfoKey ] integerValue ] )
        {
        [ [ ( TWPDebugLoginUsersView* )self.view removeAllLoginUsersButton ] setEnabled: NO ];
        [ [ ( TWPDebugLoginUsersView* )self.view removeSelectedLoginUsersButton ] setEnabled: NO ];
        }
    }

- ( void ) loginUsersManagerDidFinishRemovingAllLoginUsers: ( NSNotification* )_Notif
    {
    self->_copiesOfAllLoginUsers = [ [ TWPLoginUsersManager sharedManager ] copiesOfAllLoginUsers ];
    [ self.loginUsersTableView reloadData ];

    if ( ![ _Notif.userInfo[ TWPNumberOfRemainingLoginUsersUserInfoKey ] integerValue ] )
        {
        [ [ ( TWPDebugLoginUsersView* )self.view removeAllLoginUsersButton ] setEnabled: NO ];
        [ [ ( TWPDebugLoginUsersView* )self.view removeSelectedLoginUsersButton ] setEnabled: NO ];
        }
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPLoginUsersManagerDidFinishAddingNewLoginUser object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPLoginUsersManagerDidFinishRemovingAllLoginUsers object: nil ];
    }

#pragma mark Confomrs to <MASPreferencesViewController>
@dynamic identifier;
@dynamic toolbarItemImage;
@dynamic toolbarItemLabel;

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
    return NSLocalizedString( @"Login Users", nil );
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

    if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierUserID ] )
        result = [ ( TWPLoginUser* )self->_copiesOfAllLoginUsers[ _Row ] userID ];

    else if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierOAuthAccessToken ] )
        result = [ ( TWPLoginUser* )self->_copiesOfAllLoginUsers[ _Row ] OAuthToken ];

    else if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierOAuthAccessTokenSecret ] )
        result = [ ( TWPLoginUser* )self->_copiesOfAllLoginUsers[ _Row ] OAuthTokenSecret ];

    return result;
    }

#pragma mark Confomrs to <NSTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    NSView* resultView = nil;

    if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierUserID ] )
        {
        resultView = [ _TableView makeViewWithIdentifier: kColumnIdentifierUserID owner: self ];
        [ [ ( NSTableCellView* )resultView textField ] setStringValue: [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ] ];
        }
    else if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierOAuthAccessToken ] )
        {
        resultView = [ _TableView makeViewWithIdentifier: kColumnIdentifierOAuthAccessToken owner: self ];
        [ [ ( NSTableCellView* )resultView textField ] setStringValue: [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ] ];
        }
    else if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierOAuthAccessTokenSecret ] )
        {
        resultView = [ _TableView makeViewWithIdentifier: kColumnIdentifierOAuthAccessTokenSecret owner: self ];
        [ [ ( NSTableCellView* )resultView textField ] setStringValue: [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ] ];
        }

    return resultView;
    }

- ( void ) tableViewSelectionDidChange: ( NSNotification* )_Notif
    {
    [ [ ( TWPDebugLoginUsersView* )self.view
        removeSelectedLoginUsersButton ] setEnabled: [ ( NSTableView* )_Notif.object numberOfSelectedRows ] ];
    }

- ( void ) tableView: ( NSTableView* )_TableView
       didAddRowView: ( NSTableRowView* )_RowView
              forRow: ( NSInteger )_Row
    {
    [ [ ( TWPDebugLoginUsersView* )self.view removeAllLoginUsersButton ] setEnabled: self->_copiesOfAllLoginUsers.count ];
    [ [ ( TWPDebugLoginUsersView* )self.view removeSelectedLoginUsersButton ] setEnabled: [ _TableView numberOfSelectedRows ] ];
    }

@end // TWPDebugLoginUsersViewController

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