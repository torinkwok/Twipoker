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
#import "TWPUIConstants.h"
#import "NSColor+Objectwitter-C.h"

NSSize static sDefaultSize;
NSDictionary static* sDefaultTextAttributes;

// Private Interfaces
@interface TWPTextView ()

- ( NSTextView* ) _textView;
+ ( CGFloat ) _textBlockDynamicHeightWithTextStorage: ( NSTextStorage* )_TextStorage blockWidth: ( CGFloat )_TextBlockWidth;

@end // Private Interfaces

// TWPTextView class
@implementation TWPTextView

@dynamic tweet;
@synthesize tweetTextStorage = _tweetTextStorage;

#pragma mark Default Text View Attributes
+ ( void ) setDefaultSize: ( NSSize )_Size
    {
    if ( !NSEqualSizes( sDefaultSize, _Size ) )
        sDefaultSize = _Size;
    }

+ ( NSSize ) defaultSize
    {
    return sDefaultSize;
    }

#pragma mark Initializations
+ ( void ) initialize
    {
    sDefaultSize = NSMakeSize( TWPTextViewDefaultWidth, TWPTextViewDefaultHeight );

    NSMutableParagraphStyle* paragraphStyle = [ [ NSParagraphStyle defaultParagraphStyle ] mutableCopy ];
    [ paragraphStyle setLineSpacing: 3.5f ];
    sDefaultTextAttributes = @{ NSParagraphStyleAttributeName : paragraphStyle
                              , NSFontAttributeName : [ NSFont fontWithName: @"Lato" size: 14.f ]
                              , NSForegroundColorAttributeName : [ NSColor colorWithHTMLColor: @"7C7D7A" ]
                              };
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

        [ self setNeedsUpdateConstraints: YES ];
        }

    [ self->_tweetTextStorage replaceCharactersInRange: NSMakeRange( 0, self->_tweetTextStorage.string.length )
                                            withString: self->_tweet.tweetText ];

    [ self->_tweetTextStorage addAttributes: [ [ self class ] defaultTextAttributes ]
                                      range: NSMakeRange( 0, self->_tweetTextStorage.string.length ) ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
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

+ ( NSDictionary* ) defaultTextAttributes
    {
    return sDefaultTextAttributes;
    }

+ ( CGFloat ) textBlockDynamicHeightWithText: ( NSString* )_Text blockWidth: ( CGFloat )_TextBlockWidth
    {
    NSTextStorage* textStorage = [ [ NSTextStorage alloc ] initWithString: _Text
                                                               attributes: [ [ self class ] defaultTextAttributes ] ];

    return [ [ self class ] _textBlockDynamicHeightWithTextStorage: textStorage
                                                        blockWidth: _TextBlockWidth ];
    }

- ( CGFloat ) textBlockDynamicHeightWithWidth: ( CGFloat )_TextBlockWidth
    {
    return [ [ self class ] _textBlockDynamicHeightWithTextStorage: self->_tweetTextStorage
                                                        blockWidth: _TextBlockWidth ];
    }

#pragma mark Private Interfaces
- ( NSTextView* ) _textView
    {
    return self->_tweetTextStorage.layoutManagers.firstObject.textContainers.firstObject.textView;
    }

+ ( CGFloat ) _textBlockDynamicHeightWithTextStorage: ( NSTextStorage* )_TextStorage
                                          blockWidth: ( CGFloat )_TextBlockWidth
    {
    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: NSMakeSize( _TextBlockWidth, FLT_MAX ) ];
    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];

    [ layoutManager addTextContainer: textContainer ];
    [ _TextStorage addLayoutManager: layoutManager ];

    ( void )[ layoutManager glyphRangeForTextContainer: textContainer ];
    CGFloat dynamicHeight = NSHeight( [ layoutManager usedRectForTextContainer: textContainer ] );

    return dynamicHeight;
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