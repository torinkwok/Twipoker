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

#import "TWPMainWindowContentViewController.h"

#import "TWPDashboardViewController.h"
#import "TWPTimelineScrollView.h"

#import "TWPStackContentView.h"
#import "TWPViewsStack.h"
#import "TWPStackContentViewController.h"

#import "TWPTweetingBoxNotificationNames.h"
#import "TWPCuttingLineView.h"
#import "TWPTweetingCompleteBox.h"
#import "TWPTimelineUserNameButton.h"

#import "TWPLoginUsersManager.h"
#import "TWPTwitterUserProfileView.h"

#import "NSView+TwipokerAutoLayout.h"

@interface TWPMainWindowContentViewController ()

@end

@implementation TWPMainWindowContentViewController

@dynamic isShowingProfile;

@synthesize dashboardViewController;
@synthesize stackContentViewController;

@synthesize cuttingLineBetweetMainViewAndProfileView;

@synthesize cuttingLineBetweenNavBarAndViewsStack;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    // TODO:
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        ;

    return self;
    }

- ( void ) viewWillAppear
    {
    [ super viewDidLoad ];
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