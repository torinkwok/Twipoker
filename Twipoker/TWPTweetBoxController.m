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

#import "TWPTweetBoxController.h"
#import "TWPBrain.h"
#import "TWPTweetUpdateObject.h"

@interface TWPTweetBoxController ()

@end

@implementation TWPTweetBoxController

@synthesize tweetButton;
@synthesize cancelButton;

@synthesize tweetUpdateObject = _tweetUpdateObject;

@synthesize tweetTextView;

@synthesize uploadMediaButton;

#pragma mark Initializations
+ ( instancetype ) tweetBoxControllerWithTweetUpdate: ( TWPTweetUpdateObject* )_TweetUpdateObject
    {
    return [ [ [ self class ] alloc ] initWithTweetUpdate: _TweetUpdateObject ];
    }

- ( instancetype ) initWithTweetUpdate: ( TWPTweetUpdateObject* )_TweetUpdateObject
    {
    if ( self = [ super initWithWindowNibName: @"TWPTweetingBox" ] )
        self->_tweetUpdateObject = _TweetUpdateObject;

    return self;
    }

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

- ( void ) awakeFromNib
    {
    if ( self->_tweetUpdateObject.tweetText )
        // NSParameterAssert( string )
        [ self.tweetTextView setString: self->_tweetUpdateObject.tweetText ];
    }

#pragma mark IBActions
- ( IBAction ) cancelButtonClickedAction: ( id )_Sender
    {
    [ self.window.sheetParent endSheet: self.window returnCode: NSModalResponseCancel ];
    }

- ( IBAction ) postButtonClickedAction: ( id )_Sender
    {
    [ [ TWPBrain wiseBrain ] pushTweetUpdate: self->_tweetUpdateObject
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
    [ self _clearTweetUpdateObject ];
    [ self.window.sheetParent endSheet: self.window returnCode: NSModalResponseOK ];
    }

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

- ( void ) _clearTweetUpdateObject
    {
    self->_tweetUpdateObject.tweetText = nil;
    self->_tweetUpdateObject.mediaURLs = nil;
    }

#pragma mark Conforms to <NSTextViewDelegate>
- ( void ) textDidChange: ( NSNotification* )_Notif
    {
    NSText* text = ( NSText* )( _Notif.object );

    NSString* currentText = text.string;
    [ self->_tweetUpdateObject setTweetText: currentText ];
    [ self.tweetButton setEnabled: currentText.length > 0 ];
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