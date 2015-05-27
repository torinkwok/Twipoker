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
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
        , ( dispatch_block_t )^( void )
            {
            NSArray* allDMs = [ [ TWPDirectMessagesCoordinator defaultCenter ] allDMs ];

            NSString* currentTwitterUserID = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID;
            NSMutableSet* otherSideUsers = [ NSMutableSet set ];
            for ( OTCDirectMessage* _DM in allDMs )
                {
                if ( ![ _DM.recipient.IDString isEqualToString: currentTwitterUserID ] )
                    [ otherSideUsers addObject: _DM.recipient ];

                if ( ![ _DM.sender.IDString isEqualToString: currentTwitterUserID ] )
                    [ otherSideUsers addObject: _DM.sender ];
                }

            for ( OTCTwitterUser* _OtherSideUser in otherSideUsers )
                {
                TWPDirectMessagesSession* session = [ TWPDirectMessagesSession sessionWithOtherSideUser: _OtherSideUser ];
                if ( session )
                    [ self->_directMessageSessions addObject: session ];
                }
            } );

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