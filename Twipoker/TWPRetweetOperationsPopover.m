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

// Private Interfaces
@interface TWPRetweetOperationsPopover ()
- ( TWPRetweetOperationsView* ) _operationsView;
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
        self->_tweet = _Tweet;

        self.contentViewController = [ TWPRetweetOperationsViewController controller ];
        [ [ self _operationsView ].retweetButton setTarget: self ];
        [ [ self _operationsView ].retweetButton setAction: @selector( retweetAction: ) ];

        [ [ self _operationsView ].quoteRetweetButton setTarget: self ];
        [ [ self _operationsView ].quoteRetweetButton setAction: @selector( quoteRetweetAction: ) ];

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
    NSLog( @"Retweet %@", self->_tweet );
    }

- ( IBAction ) quoteRetweetAction: ( id )_Sender
    {
    NSLog( @"Quote Retweet %@", self->_tweet );
    }

#pragma mark Private Interfaces
- ( TWPRetweetOperationsView* ) _operationsView
    {
    return ( TWPRetweetOperationsView* )( self.contentViewController.view );
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