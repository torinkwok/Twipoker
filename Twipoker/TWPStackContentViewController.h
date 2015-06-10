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

@import Cocoa;

// KVO Key Paths
NSString extern* const TWPStackContentViewControllerCurrentDashboardStackKeyPath;

@class TWPViewsStack;
@class TWPNavigationBarController;
@class TWPDashboardView;

@interface TWPStackContentViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
    {
@private
    NSArray __strong* _dashboardTabs;
    }

@property ( weak ) IBOutlet TWPDashboardView* dashboardView;
@property ( weak ) IBOutlet TWPNavigationBarController* navigationBarController;

@property ( weak ) IBOutlet TWPViewsStack* homeDashboardStack;
@property ( weak ) IBOutlet TWPViewsStack* favoritesDashboardStack;
@property ( weak ) IBOutlet TWPViewsStack* listsDashboardStack;
@property ( weak ) IBOutlet TWPViewsStack* notificationsDashboardStack;
@property ( weak ) IBOutlet TWPViewsStack* meDashboardStack;
@property ( weak ) IBOutlet TWPViewsStack* messagesDashboardStack;

@property ( weak, readonly ) TWPViewsStack* currentDashboardStack;

#pragma mark IBActions
- ( IBAction ) pushUserTimleineToCurrentViewsStackAction: ( id )_Sender;
- ( IBAction ) pushRepliesTimleineToCurrentViewsStackAction: ( id )_Sender;
- ( IBAction ) pushTwitterListTimelineToCurrentViewsStackAction: ( id )_Sender;
- ( IBAction ) pushDirectMessageSessionViewToCurrentViewStackAction: ( id )_Sender;

- ( IBAction ) goBackAction: ( id )_Sender;
- ( IBAction ) goForwardAction: ( id )_Sender;

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