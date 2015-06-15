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

#import "TWPRetweetOperationsPopover.h"
#import "TWPRetweetOperationsView.h"
#import "TWPRetweetOperationsViewController.h"
#import "TWPRetweetSwitcher.h"
#import "TWPBrain.h"
#import "TWPRetweetUpdateObject.h"
#import "TWPQuoteRetweetBoxController.h"

// Private Interfaces
@interface TWPRetweetOperationsPopover ()
- ( NSButton* ) _retweetButton;
- ( NSButton* ) _quoteRetweetButton;
@end // Private Interfaces

@implementation TWPRetweetOperationsPopover

@synthesize attachingView;

@synthesize tweet = _tweet;

#pragma mark Initlaizations
+ ( instancetype ) popoverWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super init ] )
        {
        self.tweet = _Tweet;

        self.contentViewController = [ TWPRetweetOperationsViewController controller ];
        [ [ self _retweetButton ] setTarget: self ];
        [ [ self _retweetButton ] setAction: @selector( retweetAction: ) ];

        [ [ self _quoteRetweetButton ] setTarget: self ];
        [ [ self _quoteRetweetButton ] setAction: @selector( quoteRetweetAction: ) ];

        self.behavior = NSPopoverBehaviorTransient;
        }

    return self;
    }

- ( void ) showRelativeToRect: ( NSRect )_PositioningRect
                       ofView: ( NSView* )_PositioningView
                preferredEdge: ( NSRectEdge )_PreferredEdge
    {
    self.attachingView = _PositioningView;
    [ super showRelativeToRect: _PositioningRect
                        ofView: _PositioningView
                 preferredEdge: _PreferredEdge ];
    }

#pragma mark Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark IBActions
- ( IBAction ) retweetAction: ( id )_Sender
    {
    TWPRetweetUpdateObject* newRetweetUpdateObject = [ TWPRetweetUpdateObject retweetUpdateWithTweet: self->_tweet ];

    [ [ TWPBrain wiseBrain ] postRetweetUpdate: newRetweetUpdateObject
                                  successBlock:
        ^( OTCTweet* _Retweet )
            {
        #if DEBUG
            NSLog( @"Retweet: %@", _Retweet );
        #endif
            [ self setTweet: _Retweet ];
            } errorBlock: ^( NSError* _Error )
                            {
                            NSLog( @"%@", _Error );
                            } ];

    [ self close ];
    }

- ( IBAction ) quoteRetweetAction: ( id )_Sender
    {
    // Create a Tweet update object that replies to self->_tweet
    TWPRetweetUpdateObject* newRetweetUpdateObject = [ TWPRetweetUpdateObject retweetUpdateWithTweet: self->_tweet comment: nil ];

    self->_quoteRetweetBoxController = [ TWPQuoteRetweetBoxController tweetBoxControllerWithRetweetUpdate: newRetweetUpdateObject ];
    [ self.attachingView.window beginSheet: self->_quoteRetweetBoxController.window
                         completionHandler:
        ^( NSModalResponse _ReturnCode )
            {
            // TODO: Do something
            } ];

    [ self close ];
    }

#pragma mark Private Interfaces
- ( NSButton* ) _retweetButton
    {
    return ( ( TWPRetweetOperationsView* )( self.contentViewController.view ) ).retweetButton;
    }

- ( NSButton* ) _quoteRetweetButton
    {
    return ( ( TWPRetweetOperationsView* )( self.contentViewController.view ) ).quoteRetweetButton;
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