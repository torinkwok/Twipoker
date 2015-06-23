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

#import "TWPNavigationBarController.h"
#import "TWPViewsStack.h"

@implementation TWPNavigationBarController

@dynamic delegate;

@synthesize twitterLogo = _twitterLogo;

@synthesize goBackButton = _goBackButton;
@synthesize goForwardButton = _goForwardButton;

#pragma mark Initializations
- ( void ) viewDidLoad
    {
    [ self.view removeConstraints: self.view.constraints ];

    [ self->_twitterLogo setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self->_goBackButton setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self->_goForwardButton setTranslatesAutoresizingMaskIntoConstraints: NO ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( _twitterLogo, _goBackButton, _goForwardButton );

    NSNumber* paddingCenteredLogoHorizontally = @( NSMinX( _twitterLogo.frame ) - NSMaxX( _goForwardButton.frame ) );
    NSArray* horizontalConstraintsButtons = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|-(==leadingSpace)"
                                      "-[_goBackButton(==buttonsWidth)]"
                                      "-(==paddingBetweenButtons)"
                                      "-[_goForwardButton(==goBackButton)]"
                                      "-(>=tralingSpace)-|"
                            options: 0
                            metrics: @{ @"leadingSpace" : @( NSMinX( _goBackButton.frame ) )
                                      , @"buttonsWidth" : @( NSWidth( _goBackButton.frame ) )
                                      , @"goBackButton" : @( NSWidth( _goForwardButton.frame ) )
                                      , @"twitterLogoWidth" : @( NSWidth( _twitterLogo.frame ) )
                                      , @"paddingBetweenButtons" : @( NSMinX( _goForwardButton.frame ) - NSMaxX( _goBackButton.frame ) )
                                      , @"paddingBetweenGoForwardAndLogo" : paddingCenteredLogoHorizontally
                                      , @"paddingCenteredLogoHorizontally" : paddingCenteredLogoHorizontally
                                      , @"tralingSpace" : @( NSWidth( self.view.frame ) - NSMaxX( _goForwardButton.frame ) )
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
        constraintsWithVisualFormat: @"V:|-(==space)-[_goBackButton(==goBackButtonHeight)]-(==space)-|"
                            options: 0
                            metrics: @{ @"space" : @( ( NSHeight( self.view.frame ) - NSHeight( _goBackButton.frame ) ) / 2 )
                                      , @"goBackButtonHeight" : @( NSHeight( _goBackButton.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* verticalConstraintsGoForwardButton = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|-(==space)-[_goForwardButton(==_goBackButton)]-(==space)-|"
                            options: 0
                            metrics: @{ @"space" : @( ( NSHeight( self.view.frame ) - NSHeight( _goForwardButton.frame ) ) / 2 ) }
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
    [ self.view addConstraints: verticalConstraintsGoForwardButton ];
    [ self.view addConstraints: verticalConstraintsTwitterLogo ];

    [ self.view addConstraint: centerXConstraint ];
    [ self.view addConstraint: centerYConstraint ];
    }

#pragma mark Accessors
- ( void ) setDelegate: ( TWPViewsStack* )_NewDelegate
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
    BOOL goBackButtonNewState = self->_delegate.cursor > -1;
    BOOL goForwardButtonNewState = self->_delegate.cursor != self->_delegate.viewsStack.count - 1;

    [ self.goBackButton setEnabled: goBackButtonNewState ];
    [ self.goForwardButton setEnabled: goForwardButtonNewState ];
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