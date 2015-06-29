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

#import "TWPNavBarController.h"
#import "TWPNavButton.h"
#import "TWPNavBarTotemView.h"

@interface TWPNavBarController ()

@end

// TWPNavBarController class
@implementation TWPNavBarController

@synthesize navButton;
@synthesize totemView;

@synthesize delegate = _delegate;

- ( void ) reload
    {
    id totemContent = [ self.delegate totemContent ];
    [ self.totemView setContent: totemContent ];

    id navBarBackButtonTitleContent = [ self.delegate navBarBackButtonTitleContent ];
    if ( navBarBackButtonTitleContent )
        {
        if ( [ navBarBackButtonTitleContent isKindOfClass: [ NSString class ] ] )
            {
            [ self.navButton setTitle: ( NSString* )navBarBackButtonTitleContent ];
            [ self.navButton setImage: nil ];
            }

        else if ( [ navBarBackButtonTitleContent isKindOfClass: [ NSImage class ] ] )
            {
            [ self.navButton setTitle: @"" ];
            [ self.navButton setImage: ( NSImage* )navBarBackButtonTitleContent ];
            }
        }

    [ self.navButton setHidden: [ self.delegate atTheEnd ] ];
    }

#pragma mark Initializations
- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

@end // TWPNavBarController class

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