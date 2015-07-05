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

#import "TWPTextView.h"

// Private Interfaces
@interface TWPTextView ()
- ( NSTextView* ) _textView;
@end // Private Interfaces

// TWPTextView class
@implementation TWPTextView

@dynamic tweet;
@synthesize tweetTextStorage = _tweetTextStorage;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    // TODO:
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( nonnull OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    if ( !self->_tweetTextStorage )
        {
        self->_tweetTextStorage  = [ [ NSTextStorage alloc ] initWithString: self->_tweet.tweetText ];

        NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];
        [ self->_tweetTextStorage addLayoutManager: layoutManager ];

        NSRect frame = self.frame;
        NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: frame.size ];

        // textContainer should follow changes to the width of its text view
        [ textContainer setWidthTracksTextView: YES ];
        // textContainer should follow changes to the height of its text view
        [ textContainer setHeightTracksTextView: YES ];

        [ layoutManager addTextContainer: textContainer ];

        ( void )[ [ NSTextView alloc ] initWithFrame: frame textContainer: textContainer ];
        [ self setNeedsUpdateConstraints: YES ];
        }

    [ [ self _textView ] setString: self->_tweet.tweetText ];
    }

- ( void ) updateConstraints
    {
    [ self removeConstraints: self.constraints ];

    NSTextView* textView = [ self _textView ];
    [ textView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self addSubview: textView ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( textView );
    NSArray* horizontalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView(>=textViewWidth)]|" options: 0 metrics: @{ @"textViewWidth" : @( NSWidth( textView.frame ) ) } views: viewsDict ];
    NSArray* verticalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView(>=textViewHeight)]|" options: 0 metrics: @{ @"textViewHeight" :  @( NSHeight( textView.frame ) ) } views: viewsDict ];
    [ self addConstraints: horizontalConstraints ];
    [ self addConstraints: verticalConstraints ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark Private Interfaces
- ( NSTextView* ) _textView
    {
    return self->_tweetTextStorage.layoutManagers.firstObject.textContainers.firstObject.textView;
    }

@end // TWPTextView class

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