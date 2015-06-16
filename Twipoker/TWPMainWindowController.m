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

#import "TWPMainWindowController.h"
#import "TWPLoginUsersManager.h"
#import "TWPTwitterUserProfileViewController.h"
#import "TWPTwitterUserProfileView.h"
#import "TWPCuttingLineView.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPNavigationBarController.h"

// TWPMainWindowController class
@implementation TWPMainWindowController

@synthesize navigationBarController;

@synthesize twitterUserProfileViewController;
@synthesize cuttingLineBetweetMainViewAndProfileView;

#pragma mark Initializers
+ ( instancetype ) mainWindowController
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithWindowNibName: @"TWPMainWindow" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    self.twitterUserProfileViewController.navigationBarController = self.navigationBarController;
    }

#pragma mark IBActions
- ( IBAction ) showUserProfileAction: ( id )_Sender
    {
    OTCTwitterUser* twitterUser = [ ( TWPTimelineUserNameButton* )_Sender twitterUser ];
    [ self.twitterUserProfileViewController setTwitterUser: twitterUser ];

    NSRect frameOfCuttingLine = NSMakeRect( NSMaxX( self.navigationBarController.view.frame ), 0.f
                                          , NSWidth( self.cuttingLineBetweetMainViewAndProfileView.bounds )
                                          , NSHeight( self.cuttingLineBetweetMainViewAndProfileView.bounds )
                                          );

    [ self.cuttingLineBetweetMainViewAndProfileView setFrame: frameOfCuttingLine ];
    [ self.window.contentView addSubview: self.cuttingLineBetweetMainViewAndProfileView ];

    TWPTwitterUserProfileView* profileView = ( TWPTwitterUserProfileView* )( self.twitterUserProfileViewController.view );
    NSRect frameOfProfileView = NSMakeRect( NSMaxX( self.cuttingLineBetweetMainViewAndProfileView.frame ), 0.f
                                          , NSWidth( profileView.bounds )
                                          , NSHeight( profileView.bounds )
                                          );

    [ profileView setFrame: frameOfProfileView ];
    [ self.window.contentView addSubview: profileView ];

    NSRect newWindowFrame = [ self.window frame ];
    newWindowFrame.size.width += ( NSWidth( self.cuttingLineBetweetMainViewAndProfileView.bounds ) + NSWidth( profileView.bounds ) );
    [ self.window setFrame: newWindowFrame display: YES ];
    }

@end // TWPMainWindowController

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