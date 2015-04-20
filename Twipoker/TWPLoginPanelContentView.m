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

#import "TWPButton.h"
#import "TWPTextField.h"
#import "TWPLoginPanelContentView.h"

#import "TWPLoginUsersManager.h"

@implementation TWPLoginPanelContentView
    {
    STTwitterAPI __strong __block* _tmpTwitterAPI;
    }

@synthesize enterUserNameTextField;

@synthesize getPINButton;
@synthesize enterPINTextField;

@synthesize signInTwitterButton;

- ( void ) awakeFromNib
    {
    self.getPINButton.radiusOfTopRightCorner = 0.f;
    self.getPINButton.radiusOfBottomRightCorner = 0.f;

    self.enterPINTextField.radiusOfTopLeftCorner = 0.f;
    self.enterPINTextField.radiusOfBottomLeftCorner = 0.f;

    self.enterUserNameTextField.delegate = self;
    self.enterPINTextField.delegate = self;
    }

#pragma mark Conforms to <NSTextFieldDelegate> protocol
- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    [ self.signInTwitterButton setEnabled:
        ( self.enterUserNameTextField.stringValue.length > 0 && self.enterPINTextField.stringValue.length > 0 ) ];
    }

#pragma mark Custom Behavior
- ( BOOL ) isFlipped
    {
    return YES;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    NSBezierPath* fillPath = [ NSBezierPath bezierPathWithRect: [ self frame ] ];
    NSGradient* fillGradient =
        [ [ NSGradient alloc ] initWithColorsAndLocations: TWP_TWITTER_STARTING_COLOR, .2f, TWP_TWITTER_COLOR, .8f, nil ];

    [ fillGradient drawInBezierPath: fillPath relativeCenterPosition: NSMakePoint( .0f, -1.f ) ];
    }

#pragma mark IBActions
- ( IBAction ) getPINCodeAction: ( id )_Sender
    {
    [ [ TWPLoginUsersManager sharedManager ] createUserByFetchingPIN: self.enterUserNameTextField.stringValue
                                                        successBlock:
        ^( STTwitterAPI* _UncompletedTwitterAPI )
            {
            self->_tmpTwitterAPI = _UncompletedTwitterAPI;
            } errorBlock: ^( NSError* _Error )
                                {
                                [ self performSelectorOnMainThread: @selector( presentError: )
                                                        withObject: _Error
                                                     waitUntilDone: YES ];
                                } ];
    }

- ( IBAction ) signInTwitterAction: ( id )_Sender
    {
    [ [ TWPLoginUsersManager sharedManager ] createUserWithPIN: self.enterPINTextField.stringValue
                                         uncompletedTwitterAPI: self->_tmpTwitterAPI
                                                  successBlock:
        ^( TWPLoginUser* _NewLoginUser )
            {
            if ( _NewLoginUser )
                [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerDidFinishLoginNotification
                                                                       object: nil
                                                                     userInfo: @{ TWPNewLoginUserUserInfoKey : _NewLoginUser } ];

            } errorBlock: ^( NSError* _Error )
                                {
                                [ self performSelectorOnMainThread: @selector( presentError: )
                                                        withObject: _Error
                                                     waitUntilDone: YES ];
                                } ];
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