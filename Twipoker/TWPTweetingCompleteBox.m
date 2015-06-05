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

#import "TWPTweetingCompleteBox.h"
#import "TWPBrain.h"
#import "TWPTweetUpdateObject.h"

// TWPTweetingCompleteBox class
@implementation TWPTweetingCompleteBox

@synthesize tweetUpdateObject = _tweetUpdateObject;

@synthesize tweetTextField;

@synthesize uploadMediaButton;

@synthesize tweetButton;
@synthesize cancelButton;

- ( void ) awakeFromNib
    {
    self->_tweetUpdateObject = [ [ TWPTweetUpdateObject alloc ] init ];
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    // Drawing code here.
    NSColor* fillColor = [ NSColor colorWithHTMLColor: @"FAFAFA" ];
    [ fillColor setFill ];
    NSRectFill( _DirtyRect );
    }

#pragma mark Conforms to <NSTextFieldDelegate>
- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    NSTextField* fieldEditor = _Notif.userInfo[ @"NSFieldEditor" ];

    NSString* currentText = ( ( NSTextField* )( fieldEditor.delegate ) ).stringValue;
    [ self->_tweetUpdateObject setTweetText: currentText ];
    [ self.tweetButton setEnabled: currentText.length > 0 ];
    }

#pragma mark IBActions
- ( IBAction ) uploadMediaAction: ( id )_Sender
    {
    NSOpenPanel* openPanel = [ NSOpenPanel openPanel ];

    // Supported image formats: PNG, JPEG, WEBP and GIF. Animated GIFs are supported.
    // Supported video formats: MP4
    [ openPanel setAllowedFileTypes: @[ @"jpeg", @"jpg", @"png", @"webp", @"gif", @"mp4" ] ];
    [ openPanel setAllowsMultipleSelection: NO ];
    [ openPanel beginSheetModalForWindow: self.window
                       completionHandler:
        ^( NSInteger _Result )
            {
            // TODO:
            } ];
    }

- ( IBAction ) tweetAction: ( id )_Sender
    {
    [ [ TWPBrain wiseBrain ] pushTweetUpdate: self->_tweetUpdateObject
                            successBlock: nil
                            errorBlock: nil ];
    }

@end // TWPTweetingCompleteBox class

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