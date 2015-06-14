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

// Private Interfaces
@interface TWPRetweetOperationsPopover ()
- ( NSButton* ) _retweetButton;
- ( NSButton* ) _quoteRetweetButton;
@end // Private Interfaces

@implementation TWPRetweetOperationsPopover

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
    [ [ TWPBrain wiseBrain ] retweet: self.tweet
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
    [ [ TWPBrain wiseBrain ] quoteRetweet: self.tweet
                            withComment: @"🍉"
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