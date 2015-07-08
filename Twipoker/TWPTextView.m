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
#import "NSColor+Objectwitter-C.h"

// Private Interfaces
@interface TWPTextView ()
- ( NSTextView* ) _textView;
@end // Private Interfaces

// TWPTextView class
@implementation TWPTextView

@dynamic tweet;
@synthesize tweetTextStorage = _tweetTextStorage;
@dynamic paragraphStyle;
@dynamic textBlockHeight;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    self->_paragraphStyle = [ [ NSParagraphStyle defaultParagraphStyle ] mutableCopy ];
    [ self->_paragraphStyle setLineSpacing: 3.5f ];
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( nonnull OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    if ( !self->_tweetTextStorage )
        {
        self->_tweetTextStorage = [ [ NSTextStorage alloc ] initWithString: self->_tweet.tweetText ];

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
        [ [ self _textView ] setEditable: NO ];
        [ [ self _textView ] setSelectable: NO ];
        [ [ self _textView ] setFont: [ [ NSFontManager sharedFontManager ] convertWeight: .5f ofFont: [ NSFont fontWithName: @"Lucida Grande" size: 14.f ] ] ];
        [ [ self _textView ] setTextColor: [ NSColor colorWithHTMLColor: @"66757F" ] ];
        [ [ self _textView ] setBackgroundColor: [ NSColor grayColor ] ];

        [ self setNeedsUpdateConstraints: YES ];
        }

    [ self->_tweetTextStorage replaceCharactersInRange: NSMakeRange( 0, self->_tweetTextStorage.string.length )
                                            withString: self->_tweet.tweetText ];

    [ self->_tweetTextStorage addAttributes: @{ NSParagraphStyleAttributeName : self->_paragraphStyle
                                              , NSFontAttributeName : [ NSFont fontWithName: @"Lato" size: 14.f ]
                                              }
                                      range: NSMakeRange( 0, self->_tweetTextStorage.string.length ) ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

- ( NSParagraphStyle* ) paragraphStyle
    {
    return [ self->_paragraphStyle copy ];
    }

- ( CGFloat ) textBlockHeight
    {
//    NSLayoutManager* firstLayoutManager = self->_tweetTextStorage.layoutManagers.firstObject;
//    NSTextContainer* firstTextContainer = firstLayoutManager.textContainers.firstObject;

//    NSLog( @"New Width: %g", NSWidth( [ self _textView ].frame ) );
    NSTextStorage* textStorage = [ [ NSTextStorage alloc ] initWithAttributedString: self->_tweetTextStorage ];
    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: NSMakeSize( NSWidth( self.bounds ), FLT_MAX ) ];
    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];

    [ layoutManager addTextContainer: textContainer ];
    [ textStorage addLayoutManager: layoutManager ];

    // FIXME
    ( void )[ layoutManager glyphRangeForTextContainer: textContainer ];
    return [ layoutManager usedRectForTextContainer: textContainer ].size.height;
//    return firstTextContainer.containerSize.height;
    }

#pragma mark Constraints-Based Auto Layout
- ( void ) updateConstraints
    {
    [ super updateConstraints ];
    [ self removeConstraints: self.constraints ];

    NSTextView* textView = [ self _textView ];
    [ textView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self addSubview: textView ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( textView );
    NSArray* horizontalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView(>=textViewWidth@750)]|" options: 0 metrics: @{ @"textViewWidth" : @( NSWidth( textView.frame ) ) } views: viewsDict ];
    NSArray* verticalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView(>=textViewHeight@750)]|" options: 0 metrics: @{ @"textViewHeight" :  @( NSHeight( textView.frame ) ) } views: viewsDict ];
    [ self addConstraints: horizontalConstraints ];
    [ self addConstraints: verticalConstraints ];
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