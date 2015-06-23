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

#import "TWPDashboardViewController.h"
#import "TWPDashboardTab.h"

@interface TWPDashboardViewController ()

@end

@implementation TWPDashboardViewController

@synthesize homeTab = _homeTab;
@synthesize favTab = _favTab;
@synthesize listsTab = _listsTab;
@synthesize notifTab = _notifTab;
@synthesize meTab = _meTab;
@synthesize dmTab = _dmTab;

@synthesize composeButton = _composeButton;

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self.view removeConstraints: self.view.constraints ];

    [ self.homeTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.favTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.listsTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.notifTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.meTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.dmTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self.composeButton setTranslatesAutoresizingMaskIntoConstraints: NO ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( _homeTab, _favTab, _listsTab, _notifTab, _meTab, _dmTab, _composeButton );

    // FIXME: Fucking bug
    NSArray* verticalConstraints = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|-topSpace-"
                                      "[_homeTab(==homeTabHeight)][_favTab(==favTabHeight)][_listsTab(==listsTabHeight)]"
                                      "[_notifTab(==notifTabHeight)][_meTab(==meTabHeight)][_dmTab(==dmTabHeight)]"
                                      "-(>=paddingBetweenOperationsAndCompose)-[_composeButton(==composeButtonHeight)]|"
                            options: 0
                            metrics: @{ @"topSpace" : @( NSMaxY( self.view.frame ) - NSMaxY( _homeTab.frame ) )
                                      , @"homeTabHeight" : @( NSHeight( _homeTab.frame ) )
                                      , @"favTabHeight" : @( NSHeight( _favTab.frame ) )
                                      , @"listsTabHeight" : @( NSHeight( _listsTab.frame ) )
                                      , @"notifTabHeight" : @( NSHeight( _notifTab.frame ) )
                                      , @"meTabHeight" : @( NSHeight( _meTab.frame ) )
                                      , @"dmTabHeight" : @( NSHeight( _dmTab.frame ) )
                                      , @"composeButtonHeight" : @( NSHeight( _composeButton.frame ) )
                                      , @"paddingBetweenOperationsAndCompose" : @( NSMinY( _dmTab.frame ) - NSMaxY( _composeButton.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* horizontalConstraints0 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|_homeTab(==homeTabWidth)|"
                            options: 0
                            metrics: @{ @"homeTabWidth" : @( NSWidth( _homeTab.frame ) ) }
                              views: viewsDict ];

    [ self.view addConstraints: verticalConstraints ];
    [ self.view addConstraints: horizontalConstraints0 ];
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