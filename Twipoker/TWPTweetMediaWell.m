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

#import "TWPTweetMediaWell.h"
#import "NSBezierPath+TwipokerDrawing.h"

// TWPTweetMediaWell class
@implementation TWPTweetMediaWell

@dynamic tweet;

#pragma mark Global Properties
+ ( NSSize ) defaultSize
    {
    return NSMakeSize( 272.f, 272.f * 0.61803398875f ); // Golden Ratio
    }

#pragma mark Initializations
+ ( instancetype ) tweetMediaWellWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( !_Tweet.media.count )
        return nil;

    NSSize defaultSize = [ [ self class ] defaultSize ];
    if ( self = [ super initWithFrame: NSMakeRect( 0, 0, defaultSize.width, defaultSize.height ) ] )
        {
        self->_tweet = _Tweet;
        [ self setNeedsDisplay: YES ];
        }

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    [ self setNeedsDisplay: YES ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSBezierPath* roundedRectOulinePath =
        [ NSBezierPath bezierPathWithRoundedRect: _DirtyRect
                       withRadiusOfTopLeftCorner: 30.f
                                bottomLeftCorner: 30.f
                                  topRightCorner: 30.f
                               bottomRightCorner: 30.f
                                       isFlipped: NO ];
    [ [ NSColor grayColor ] set ];
    [ roundedRectOulinePath stroke ];
    [ roundedRectOulinePath fill ];
    }

@end // TWPTweetMediaWell class

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