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
#import "TWPTweetOperationsNotificationNames.h"

#import "TWPReplyButton.h"
#import "TWPRetweetSwitcher.h"
#import "TWPFavSwitcher.h"
#import "TWPRetweetOperationsPopover.h"
#import "TWPRetweetOperationsViewController.h"

#import "TWPTweetUpdateObject.h"
#import "TWPNormalTweetBoxController.h"

@implementation TWPTweetOperationsPanelView

@dynamic tweet;

@synthesize replyButton;
@synthesize retweetSwitcher;
@synthesize favSwitcher;

@dynamic isShowingRetweetOperationsPopover;

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

        self->_popover = [ TWPRetweetOperationsPopover popoverWithTweet: self->_tweet delegate: self ];
        }

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    // self->_tweet
    self->_tweet = _Tweet;

    // self->_popover
    if ( !self->_popover )
        self->_popover = [ TWPRetweetOperationsPopover popoverWithTweet: self->_tweet delegate: self ];
    else
        [ self->_popover setTweet: self->_tweet ];

    // Buttons
    [ self.retweetSwitcher setTweet: _Tweet ];
    [ self.favSwitcher setTweet: _Tweet ];

    self->_isShowingRetweetOperationsPopover = NO;
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

- ( BOOL ) isShowingRetweetOperationsPopover
    {
    return self->_isShowingRetweetOperationsPopover;
    }

#pragma mark IBActions
- ( IBAction ) showRetweetPopoverAction: ( id )_Sender
    {
    if ( self.retweetSwitcher.isSelected )
        [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTweetOperationShouldBeUnretweeted
                                                               object: self
                                                             userInfo: @{ kOriginalTweet : self->_tweet ?: [ NSNull null ] } ];
    else
        [ self->_popover showRelativeToRect: self.retweetSwitcher.bounds
                                     ofView: self.retweetSwitcher
                              preferredEdge: NSMaxYEdge ];
    }

- ( IBAction ) favOrUnfavAction: ( id )_Sender
    {
    if ( self.favSwitcher.isSelected )
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
        }
    else
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

        }
    }

- ( IBAction ) replyCurrentTweetAction: ( id )_Sender
    {
    // Create a Tweet update object that replies to self->_tweet
    TWPTweetUpdateObject* newTweetUpdateObject = [ TWPTweetUpdateObject tweetUpdate ];
    newTweetUpdateObject.replyToTweet = self->_tweet;

    self->_tweetBoxController = [ TWPNormalTweetBoxController tweetBoxControllerWithTweetUpdate: newTweetUpdateObject ];
    [ self.window beginSheet: self->_tweetBoxController.window
           completionHandler:
        ^( NSModalResponse _ReturnCode )
            {
            // TODO: Do something
            } ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ [ NSColor whiteColor ] set ];
    NSRectFill( _DirtyRect );
    }

#pragma mark Conforms to <TWPRetweetOperationsPopoverDelegate>
- ( void ) popoverWillShow: ( NSNotification* )_Notif
    {
    self->_isShowingRetweetOperationsPopover = YES;
    }

- ( void ) popoverWillClose: ( NSNotification* )_Notif
    {
    self->_isShowingRetweetOperationsPopover = NO;
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