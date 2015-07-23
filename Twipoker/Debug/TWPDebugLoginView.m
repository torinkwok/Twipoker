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

#import "TWPDebug.h"
#import "TWPDebugLoginView.h"
#import "TWPButton.h"
#import "TWPTextField.h"
#import "TWPLoginPanelController.h"
#import "TWPLoginPanelContentView.h"

@implementation TWPDebugLoginView

@synthesize radiusTopLeft_signInTwitterButton_slider = _radiusTopLeft_signInTwitterButton_slider;
@synthesize radiusBottomLeft_signInTwitterButton_slider = _radiusBottomLeft_signInTwitterButton_slider;
@synthesize radiusTopRight_signInTwitterButton_slider = _radiusTopRight_signInTwitterButton_slider;
@synthesize radiusBottomRight_signInTwitterButton_slider = _radiusBottomRight_signInTwitterButton_slider;

@synthesize signInTwitterButton;
@synthesize enterUserNameTextField;
@synthesize enterPINTextField;

@synthesize radius_signInTwitterButton_restoreDefaultButton = _radius_signInTwitterButton_restoreDefaultButton;

- ( void ) awakeFromNib
    {
    [ self _doInitialOperation ];
    }

- ( void ) _doInitialOperation
    {
    self.radiusTopLeft_signInTwitterButton_slider.doubleValue = TWP_DEFAULT_RADIUS_CORNER;
    self.radiusBottomLeft_signInTwitterButton_slider.doubleValue = TWP_DEFAULT_RADIUS_CORNER;
    self.radiusTopRight_signInTwitterButton_slider.doubleValue = TWP_DEFAULT_RADIUS_CORNER;
    self.radiusBottomRight_signInTwitterButton_slider.doubleValue = TWP_DEFAULT_RADIUS_CORNER;

    self.signInTwitterButton = [ ( TWPLoginPanelContentView* )( [ TWPDebug sharedDebug ].appDelegate.loginPanelController.window.contentView ) signInTwitterButton ];
    self.enterUserNameTextField = [ ( TWPLoginPanelContentView* )( [ TWPDebug sharedDebug ].appDelegate.loginPanelController.window.contentView ) enterUserNameTextField ];
    self.enterPINTextField = [ ( TWPLoginPanelContentView* )( [ TWPDebug sharedDebug ].appDelegate.loginPanelController.window.contentView ) enterPINTextField ];
    }

- ( IBAction ) radiusOfSignInTwitterButtonChanged: ( id )_Sender
    {
    NSString* controlID = [ _Sender identifier ];
    CGFloat newValue = [ ( NSSlider* )_Sender doubleValue ];

    if ( [ controlID isEqualToString: @"Top Left-Button" ] )
        self.signInTwitterButton.radiusOfTopLeftCorner = newValue;

    else if ( [ controlID isEqualToString: @"Bottom Left-Button" ] )
        self.signInTwitterButton.radiusOfBottomLeftCorner = newValue;

    else if ( [ controlID isEqualToString: @"Top Right-Button" ] )
        self.signInTwitterButton.radiusOfTopRightCorner = newValue;

    else if ( [ controlID isEqualToString: @"Bottom Right-Button" ] )
        self.signInTwitterButton.radiusOfBottomRightCorner = newValue;
    }

- ( IBAction ) radiusOfInputFieldChanged: ( id )_Sender
    {
    NSString* controlID = [ _Sender identifier ];
    CGFloat newValue = [ ( NSSlider* )_Sender doubleValue ];

    if ( [ controlID isEqualToString: @"Top Left-Input Fields" ] )
        {
        self.enterUserNameTextField.radiusOfTopLeftCorner = newValue;
        self.enterPINTextField.radiusOfTopLeftCorner = newValue;
        }

    else if ( [ controlID isEqualToString: @"Bottom Left-Input Fields" ] )
        {
        self.enterUserNameTextField.radiusOfBottomLeftCorner = newValue;
        self.enterPINTextField.radiusOfBottomLeftCorner = newValue;
        }

    else if ( [ controlID isEqualToString: @"Top Right-Input Fields" ] )
        {
        self.enterUserNameTextField.radiusOfTopRightCorner = newValue;
        self.enterPINTextField.radiusOfTopRightCorner = newValue;
        }

    else if ( [ controlID isEqualToString: @"Bottom Right-Input Fields" ] )
        {
        self.enterUserNameTextField.radiusOfBottomRightCorner = newValue;
        self.enterPINTextField.radiusOfBottomRightCorner = newValue;
        }
    }

- ( IBAction ) restoreDefaultAction: ( id )_Sender
    {
    [ self _doInitialOperation ];

    [ self.signInTwitterButton setRadiusOfTopLeftCorner: TWP_DEFAULT_RADIUS_CORNER ];
    [ self.signInTwitterButton setRadiusOfBottomLeftCorner: TWP_DEFAULT_RADIUS_CORNER ];
    [ self.signInTwitterButton setRadiusOfTopRightCorner: TWP_DEFAULT_RADIUS_CORNER ];
    [ self.signInTwitterButton setRadiusOfBottomRightCorner: TWP_DEFAULT_RADIUS_CORNER ];
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