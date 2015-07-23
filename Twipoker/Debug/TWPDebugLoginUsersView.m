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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TWPDebugLoginUsersView.h"
#import "TWPLoginUsersManager.h"

NSString* const kColumnIdentifierUserID = @"user-id";
NSString* const kColumnIdentifierOAuthAccessToken = @"oauth-access-token";
NSString* const kColumnIdentifierOAuthAccessTokenSecret = @"oauth-access-token-secret";

@implementation TWPDebugLoginUsersView

- ( IBAction ) fetchPINCodeAction: ( id )_Sender
    {
    [ [ TWPLoginUsersManager sharedManager ] fetchPINByLaunchingDefaultWebBrowser: self.userScreenNameTextField.stringValue
                                                                       errorBlock:
        ^( NSError* _Error )
            {
            [ self performSelectorOnMainThread: @selector( presentError: ) withObject: _Error waitUntilDone: YES ];
            } ];
    }

- ( IBAction ) loginAction: ( id )_Sender
    {
    [ [ TWPLoginUsersManager sharedManager ] createUserWithPIN: self.PINCodeTextField.stringValue
                                                  successBlock: nil
                                                    errorBlock:
        ^( NSError* _Error )
            {
            [ self performSelectorOnMainThread: @selector( presentError: ) withObject: _Error waitUntilDone: YES ];
            } ];
    }

- ( IBAction ) removeSelectedLoginUsersAction: ( id )_Sender;
    {
    NSIndexSet* selectedRowIndexes = [ self.loginUsersTableView selectedRowIndexes ];
    NSMutableArray* userIDsToBeRemoved = [ NSMutableArray array ];
    [ selectedRowIndexes enumerateIndexesUsingBlock:
        ^( NSUInteger _RowIndex, BOOL* _Stop )
            {
            NSTableColumn* userIDColumn = [ self.loginUsersTableView tableColumnWithIdentifier: kColumnIdentifierUserID ];
            NSString* userID = [ self.loginUsersTableView.dataSource tableView: self.loginUsersTableView
                                                     objectValueForTableColumn: userIDColumn
                                                                           row: _RowIndex ];
            [ userIDsToBeRemoved addObject: userID ];
            } ];

    for ( NSString* _UserID in userIDsToBeRemoved )
        [ [ TWPLoginUsersManager sharedManager ] removeUserWithUserID: _UserID ];
    }

- ( IBAction ) removeAllLoginUsersAction: ( id )_Sender
    {
    [ [ TWPLoginUsersManager sharedManager ] removeAllLoginUsers ];
    }

#pragma  mark Control Delegate
- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    NSTextView* fieldEditor = [ _Notif.userInfo objectForKey: @"NSFieldEditor" ];
    NSButton* testButton = nil;

    if ( ( id )( fieldEditor.delegate ) == self.userScreenNameTextField )
        testButton = self.fetchPINCodeButton;
    else if ( ( id )( fieldEditor.delegate ) == self.PINCodeTextField )
        testButton = self.loginButton;

    [ testButton setEnabled: fieldEditor.string.length > 0 ];
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