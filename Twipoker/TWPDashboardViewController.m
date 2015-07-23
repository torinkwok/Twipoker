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

#import "TWPDashboardViewController.h"
#import "TWPDashboardTab.h"
#import "TWPBrain.h"
#import "TWPCurrentUserAvatarWellController.h"
#import "TWPLoginUsersManager.h"

// TWPDashboardViewController class
@implementation TWPDashboardViewController

@synthesize currentUserAvatarWellController = _currentUserAvatarWellController;

@synthesize homeTab = _homeTab;
@synthesize favTab = _favTab;
@synthesize listsTab = _listsTab;
@synthesize notifTab = _notifTab;
@synthesize meTab = _meTab;
@synthesize dmTab = _dmTab;

@synthesize composeButton = _composeButton;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ [ TWPBrain wiseBrain ] fetchUserDetails: [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID
                                 successBlock:
        ^( OTCTwitterUser* _TwitterUser )
            {
            self.currentUserAvatarWellController.twitterUser = _TwitterUser;
            } errorBlock: ^( NSError* _Error )
                            {
                            NSLog( @"%@", _Error );
                            } ];
    }

- ( void ) viewDidLoad
    {
//    [ self.view removeConstraints: self.view.constraints ];
//
//    [ self.homeTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ self.favTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ self.listsTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ self.notifTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ self.meTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ self.dmTab setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ self.composeButton setTranslatesAutoresizingMaskIntoConstraints: NO ];
//
//    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( _homeTab, _favTab, _listsTab, _notifTab, _meTab, _dmTab, _composeButton );
//
//    NSArray* verticalConstraints = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"V:|-topSpace-"
//                                      "[_homeTab(==homeTabHeight)][_favTab(==favTabHeight)][_listsTab(==listsTabHeight)]"
//                                      "[_notifTab(==notifTabHeight)][_meTab(==meTabHeight)][_dmTab(==dmTabHeight)]"
//                                      "-(>=paddingBetweenOperationsAndCompose@priority)-[_composeButton(==composeButtonHeight)]|"
//                            options: 0
//                            metrics: @{ @"topSpace" : @( NSMaxY( self.view.frame ) - NSMaxY( _homeTab.frame ) )
//                                      , @"homeTabHeight" : @( NSHeight( _homeTab.frame ) )
//                                      , @"favTabHeight" : @( NSHeight( _favTab.frame ) )
//                                      , @"listsTabHeight" : @( NSHeight( _listsTab.frame ) )
//                                      , @"notifTabHeight" : @( NSHeight( _notifTab.frame ) )
//                                      , @"meTabHeight" : @( NSHeight( _meTab.frame ) )
//                                      , @"dmTabHeight" : @( NSHeight( _dmTab.frame ) )
//                                      , @"composeButtonHeight" : @( NSHeight( _composeButton.frame ) )
//                                      , @"priority" : @( NSLayoutPriorityDefaultHigh )
//                                      , @"paddingBetweenOperationsAndCompose" : @( NSMinY( _dmTab.frame ) - NSMaxY( _composeButton.frame ) )
//                                      }
//                              views: viewsDict ];
//
//    NSArray* horizontalConstraintsHomeTab = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_homeTab(==homeTabWidth)]|" options: 0 metrics: @{ @"homeTabWidth" : @( NSWidth( _homeTab.frame ) ) } views: viewsDict ];
//
//    NSArray* horizontalConstraintsFavTab = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_favTab(==favTabWidth)]|" options: 0 metrics: @{ @"favTabWidth" : @( NSWidth( _favTab.frame ) ) } views: viewsDict ];
//
//    NSArray* horizontalConstraintsListsTab = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_listsTab(==listsTabWidth)]|" options: 0 metrics: @{ @"listsTabWidth" : @( NSWidth( _listsTab.frame ) ) } views: viewsDict ];
//
//    NSArray* horizontalConstraintsNotifTab = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_notifTab(==notifTabWidth)]|" options: 0 metrics: @{ @"notifTabWidth" : @( NSWidth( _notifTab.frame ) ) } views: viewsDict ];
//
//    NSArray* horizontalConstraintsMeTab = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_meTab(==meTabWidth)]|" options: 0 metrics: @{ @"meTabWidth" : @( NSWidth( _meTab.frame ) ) } views: viewsDict ];
//
//    NSArray* horizontalConstraintsDMTab = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_dmTab(==dmTabWidth)]|" options: 0 metrics: @{ @"dmTabWidth" : @( NSWidth( _dmTab.frame ) ) } views: viewsDict ];
//
//    NSArray* horizontalConstraintsComposeButton = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|[_composeButton(==composeButtonWidth)]|" options: 0 metrics: @{ @"composeButtonWidth" : @( NSWidth( _composeButton.frame ) ) } views: viewsDict ];
//
//    [ self.view addConstraints: verticalConstraints ];
//    [ self.view addConstraints: horizontalConstraintsHomeTab ];
//    [ self.view addConstraints: horizontalConstraintsFavTab ];
//    [ self.view addConstraints: horizontalConstraintsListsTab ];
//    [ self.view addConstraints: horizontalConstraintsNotifTab ];
//    [ self.view addConstraints: horizontalConstraintsMeTab ];
//    [ self.view addConstraints: horizontalConstraintsDMTab ];
//    [ self.view addConstraints: horizontalConstraintsComposeButton ];
    }

@end // TWPDashboardViewController class

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