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

#import "TWPTweetTextField.h"
#import "TWPTweetCellView.h"

@implementation TWPTweetTextField

@dynamic tweet;

- ( NSView* ) firstTweetCellSuperview
    {
    NSView* tweetCellView = self.superview;

    while ( true )
        {
        if ( [ tweetCellView isKindOfClass: [ TWPTweetCellView class ] ] )
            break;
        else
            tweetCellView = tweetCellView.superview;
        }

    return tweetCellView;
    }

#pragma mark Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    [ self setStringValue: self->_tweet.tweetText ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark Handling Event
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ super mouseDown: _Event ];
    [ NSApp sendAction: self.action to: self.target from: self ];
    }

- ( NSView* ) hitTest: ( NSPoint )_Point
    {
    if ( [ self mouse: [ self convertPoint: _Point fromView: self.superview ] inRect: self.bounds ] )
        return self;
    else
        return [ super hitTest: _Point ];
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