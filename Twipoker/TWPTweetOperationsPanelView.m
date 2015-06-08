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
#import "TWPRetweetSwitcher.h"
#import "TWPFavSwitcher.h"
#import "TWPRetweetOperationsPopover.h"
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

        self->_popover = [ TWPRetweetOperationsPopover popoverWithTweet: self->_tweet ];
        }

    return self;
    }

#pragma mark Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    // self->_tweet
    self->_tweet = _Tweet;

    // self->_popover
    if ( !self->_popover )
        self->_popover = [ TWPRetweetOperationsPopover popoverWithTweet: self->_tweet ];
    else
        [ self->_popover setTweet: self->_tweet ];

    // Buttons
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
    [ self->_popover showRelativeToRect: self.retweetButton.bounds
                                 ofView: self.retweetButton
                          preferredEdge: NSMaxYEdge ];
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