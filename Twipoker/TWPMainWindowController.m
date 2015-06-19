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

#import "TWPActionNotifications.h"
#import "TWPMainWindowController.h"
#import "TWPLoginUsersManager.h"
#import "TWPTwitterUserProfileViewController.h"
#import "TWPTwitterUserProfileView.h"
#import "TWPCuttingLineView.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPNavigationBarController.h"

// Private Interfaces
@interface TWPMainWindowController ()

- ( void ) _showUserProfile: ( NSNotification* )_Notif;
- ( void ) _hideUserProfile: ( NSNotification* )_Notif;

@end // Private Interfaces

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
        self->_isShowingProfile = NO;

        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _showUserProfile: ) name: TWPTwipokerShouldShowUserProfile object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( _hideUserProfile: ) name: TWPTwipokerShouldHideUserProfile object: nil ];
        }

    return self;
    }

#pragma mark Deallocator
- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPTwipokerShouldShowUserProfile object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: TWPTwipokerShouldHideUserProfile object: nil ];
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    self.twitterUserProfileViewController.refNavBarController = self.navigationBarController;
    self->_initialFrame = self.window.frame;
    }

#pragma mark Private Interfaces
- ( void ) _showUserProfile: ( NSNotification* )_Notif
    {
    OTCTwitterUser* twitterUser = _Notif.userInfo[ kTwitterUser ];
    [ self.twitterUserProfileViewController setTwitterUser: twitterUser ];

    if ( !self->_isShowingProfile )
        {
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
        [ self.window setFrame: newWindowFrame display: YES animate: YES ];

        self->_isShowingProfile = YES;
        }
    }

- ( void ) _hideUserProfile: ( NSNotification* )_Notif
    {
    NSRect newFrame = NSMakeRect( NSMinX( self.window.frame ), NSMinY( self.window.frame ), NSWidth( self->_initialFrame ), NSHeight( self->_initialFrame ) );
    [ self.window setFrame: newFrame display: YES animate: YES ];

    [ self.twitterUserProfileViewController.view removeFromSuperview ];
    [ self.cuttingLineBetweetMainViewAndProfileView removeFromSuperview ];

    self->_isShowingProfile = NO;
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