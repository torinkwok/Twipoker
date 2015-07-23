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

#import "TWPQuoteRetweetBoxController.h"
#import "TWPBrain.h"
#import "TWPRetweetUpdateObject.h"

@interface TWPQuoteRetweetBoxController ()

@end

@implementation TWPQuoteRetweetBoxController

@synthesize retweetUpdateObject;

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

#pragma mark Initializations
+ ( instancetype ) tweetBoxControllerWithRetweetUpdate: ( TWPRetweetUpdateObject* )_RetweetUpdateObj
    {
    return [ [ [ self class ] alloc ] initWithRetweetUpdate: _RetweetUpdateObj ];
    }

- ( instancetype ) initWithRetweetUpdate: ( TWPRetweetUpdateObject* )_RetweetUpdateObj
    {
    if ( self = [ super initWithWindowNibName: @"TWPQuoteRetweetBox" ] )
        self->retweetUpdateObject = _RetweetUpdateObj;

    return self;
    }

#pragma mark IBActions
- ( IBAction ) postButtonClickedAction: ( id )_Sender
    {
    [ [ TWPBrain wiseBrain ] postRetweetUpdate: self.retweetUpdateObject
                                  successBlock:
        ^( OTCTweet* _PushedTweet )
            {
            // TODO:
            NSLog( @"Just posted Tweet: %@", _PushedTweet );
            } errorBlock:
                ^( NSError* _Error )
                    {
                    // TODO:
                    NSLog( @"%@", _Error );
                    } ];

    [ self.tweetTextView setString: @"" ];
    [ self _clearRetweetUpdateObject ];
    [ self.window.sheetParent endSheet: self.window returnCode: NSModalResponseOK ];
    }

- ( IBAction ) cancelButtonClickedAction: ( id )_Sender
    {
    [ self.window.sheetParent endSheet: self.window returnCode: NSModalResponseCancel ];
    }

- ( void ) _clearRetweetUpdateObject
    {
    self.retweetUpdateObject.tweetToBeRetweeted = nil;
    self->retweetUpdateObject.comment = nil;
    }

#pragma mark Conforms to <NSTextViewDelegate>
- ( void ) textDidChange: ( NSNotification* )_Notif
    {
    NSText* text = ( NSText* )( _Notif.object );

    NSString* currentText = text.string;
    [ self.retweetUpdateObject setComment: currentText ];
    [ self.postButton setEnabled: currentText.length > 0 ];
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