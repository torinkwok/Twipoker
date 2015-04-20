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


//    // TODO: Waiting for handle the boundary conditions
//    [ TWPTwitterAPI postTokenRequest:
//        ^( NSURL* _URL, NSString* _OAuthToken )
//            {
//            [ [ NSWorkspace sharedWorkspace ] openURL: _URL ];
//            }
//      authenticateInsteadOfAuthorize: NO
//                          forceLogin: @YES
//                          screenName: self.enterUserNameTextField.stringValue
//                       oauthCallback: @"oob"
//                          errorBlock: ^( NSError* _Error ){ NSLog( @"%@", _Error ); } ];
    }

- ( IBAction ) signInTwitterAction: ( id )_Sender
    {
//    [ TWPTwitterAPI postAccessTokenRequestWithPIN: self.enterPINTextField.stringValue
//                                     successBlock:
//        ^( NSString* _OAuthToken, NSString* _OAuthTokenSecret, NSString* _UserID, NSString* _ScreenName )
//            {
//            TWPLoginUser* newUser = [ [ TWPLoginUsersManager sharedManager ]
//                createUserWithUserID: _UserID userName: _ScreenName OAuthToken: _OAuthToken OAuthTokenSecret: _OAuthTokenSecret ];
//
//            if ( newUser )
//                [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerDidFinishLoginNotification
//                                                                       object: nil
//                                                                     userInfo: @{ TWPNewLoginUserUserInfoKey : newUser } ];
//            }
//                                            errorBlock: ^( NSError* _Error ){ NSLog( @"%@", _Error ); } ];
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