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
#import "TWPDirectMessagesSession.h"
#import "TWPDirectMessagesCoordinator.h"
#import "TWPBrain.h"
#import "TWPLoginUsersManager.h"

@interface TWPDirectMessagesPreviewViewController ()

@end

@implementation TWPDirectMessagesPreviewViewController

- ( void ) updateDMs: ( NSArray* )_DMs
    {
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
        TWPDirectMessagesSession* session = [ TWPDirectMessagesSession sessionWithOtherSideUser: _OtherSideUser ];
        if ( session && ![ self->_directMessageSessions containsObject: session ] )
            [ self->_directMessageSessions addObject: session ];
        }

    NSLog( @"%@", self->_directMessageSessions );
    }

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"TWPMessagesView" bundle: [ NSBundle mainBundle ] ] )
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

#pragma mark Conforms to <NSTableViewDelegate>

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