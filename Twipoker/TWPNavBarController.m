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
#import "TWPViewsStack.h"

// TWPNavBarController class
@implementation TWPNavBarController

@dynamic delegate;

@synthesize twitterLogo = _twitterLogo;

@synthesize backButton = _backButton;

#pragma mark Initializations
- ( void ) viewDidLoad
    {
    [ self.view removeConstraints: self.view.constraints ];

    [ self->_twitterLogo setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self->_backButton setTranslatesAutoresizingMaskIntoConstraints: NO ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( _twitterLogo, _backButton );

    NSArray* horizontalConstraintsButtons = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|-(==leadingSpace)"
                                      "-[_backButton(==buttonsWidth)]"
                                      "-(>=tralingSpace)-|"
                            options: 0
                            metrics: @{ @"leadingSpace" : @( NSMinX( _backButton.frame ) )
                                      , @"buttonsWidth" : @( NSWidth( _backButton.frame ) )
                                      , @"tralingSpace" : @( NSWidth( self.view.frame ) - NSMaxX( _backButton.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* logoWidthConstraint = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:[_twitterLogo(==twitterLogoWidth)]"
                            options: NSLayoutFormatAlignAllCenterX | NSLayoutFormatAlignAllCenterY
                            metrics: @{ @"leadingSpace" : @( NSMinX( _twitterLogo.frame ) )
                                      , @"twitterLogoWidth" : @( NSWidth( _twitterLogo.frame ) )
                                      , @"trailingSpace" : @( NSWidth( self.view.frame ) - NSMaxX( _twitterLogo.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* verticalConstraintsGoBackButton = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|-(==space)-[_backButton(==goBackButtonHeight)]-(==space)-|"
                            options: 0
                            metrics: @{ @"space" : @( ( NSHeight( self.view.frame ) - NSHeight( _backButton.frame ) ) / 2 )
                                      , @"goBackButtonHeight" : @( NSHeight( _backButton.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* verticalConstraintsTwitterLogo = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|-(==space)-[_twitterLogo(==twitterLogoHeight)]-(==space)-|"
                            options: 0
                            metrics: @{ @"space" : @( ( NSHeight( self.view.frame ) - NSHeight( _twitterLogo.frame ) ) / 2 )
                                      , @"twitterLogoHeight" : @( NSHeight( _twitterLogo.frame ) )
                                      }
                              views: viewsDict ];

    NSLayoutConstraint* centerXConstraint = [ NSLayoutConstraint
        constraintWithItem: self.view attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: _twitterLogo attribute: NSLayoutAttributeCenterX multiplier: 1.f constant: 0.f ];

    NSLayoutConstraint* centerYConstraint = [ NSLayoutConstraint
        constraintWithItem: self.view attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: _twitterLogo attribute: NSLayoutAttributeCenterY multiplier: 1.f constant: 0.f ];


    [ self.view addConstraints: horizontalConstraintsButtons ];
    [ self.view addConstraints: logoWidthConstraint ];
    [ self.view addConstraints: verticalConstraintsGoBackButton ];
    [ self.view addConstraints: verticalConstraintsTwitterLogo ];

    [ self.view addConstraint: centerXConstraint ];
    [ self.view addConstraint: centerYConstraint ];
    }

#pragma mark Accessors
- ( void ) setDelegate: ( id <TWPNavBarControllerDelegate> )_NewDelegate
    {
    if ( self->_delegate != _NewDelegate )
        {
        self->_delegate = _NewDelegate;
        [ self reload ];
        }
    }

- ( TWPViewsStack* ) delegate
    {
    return self->_delegate;
    }

- ( void ) reload
    {
    self->_centerStuff = self.delegate.centerStuff;
    self->_backButtonTitle = self.delegate.backButtonTitle;

    NSLog( @"%@", self->_backButtonTitle );
    [ self.backButton setHidden: !self->_backButtonTitle ];
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