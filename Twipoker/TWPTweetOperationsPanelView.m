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

#import "TWPTweetOperationsPanelView.h"
#import "TWPLoginUsersManager.h"
#import "TWPBrain.h"

#import "TWPReplyButton.h"
#import "TWPRetweetButton.h"
#import "TWPFavButton.h"
#import "TWPRetweetOperationsViewController.h"

@implementation TWPTweetOperationsPanelView

@dynamic tweet;

@synthesize replyButton;
@synthesize retweetButton;
@synthesize favButton;

#pragma mark Initializations
+ ( instancetype ) panelWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super init ] )
        {
        [ self setTweet: _Tweet ];
        [ self setNeedsDisplay: YES ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    NSButton* popoverRetweetButton = self.retweetButton.retweetOperationsViewController.retweetButton;
    NSButton* popoverQuoteRetweetButton = self.retweetButton.retweetOperationsViewController.quoteRetweetButton;

    NSLog( @"%@", popoverRetweetButton.title );
    NSLog( @"%@\n\n", popoverQuoteRetweetButton.title );
    [ popoverRetweetButton setAction: @selector( retweetAction: ) ];
    [ popoverQuoteRetweetButton setAction: @selector( quoteRetweetAction: ) ];

    [ popoverRetweetButton setTarget: self ];
    [ popoverQuoteRetweetButton setTarget: self ];
    }

#pragma mark Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;

    SInt64 currentUserID = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].userID.longLongValue;
    [ self.retweetButton setEnabled: _Tweet.author.ID != currentUserID ];

    [ self.favButton setState: _Tweet.isFavoritedByMe ];
    [ self.retweetButton setState: _Tweet.isRetweetedByMe ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark IBActions
- ( IBAction ) showRetweetPopoverAction: ( id )_Sender
    {
    [ self.retweetButton showRetweetPopover ];
    }

- ( IBAction ) favOrUnfavAction: ( id )_Sender
    {
    NSCellStateValue state = self.favButton.state;

    switch ( state )
        {
        case NSOnState:
            {
            [ [ TWPBrain wiseBrain ] favTweet: self.tweet
                                 successBlock:
                ^( OTCTweet* _FavedTweet )
                    {
                #if DEBUG
                    NSLog( @"Just faved Tweet: %@", _FavedTweet );
                #endif
                    [ self setTweet: _FavedTweet ];
                    } errorBlock: ^( NSError* _Error )
                                    {
                                    NSLog( @"%@", _Error );
                                    } ];
            } break;

        case NSOffState:
            {
            [ [ TWPBrain wiseBrain ] unfavTweet: self.tweet
                                   successBlock:
                ^( OTCTweet* _UnfavedTweet )
                    {
                #if DEBUG
                    NSLog( @"Just unfaved Tweet: %@", _UnfavedTweet );
                #endif
                    [ self setTweet: _UnfavedTweet ];
                    } errorBlock: ^( NSError* _Error )
                                    {
                                    NSLog( @"%@", _Error );
                                    } ];
            } break;
        }
    }

- ( IBAction ) retweetAction: ( id )_Sender
    {
    NSLog( @"Retweet %@", self->_tweet );
    }

- ( IBAction ) quoteRetweetAction: ( id )_Sender
    {
    NSLog( @"Quote Retweet %@", self->_tweet );
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