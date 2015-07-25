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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TWPTextView.h"
#import "NSColor+Objectwitter-C.h"
#import "TWPUIConstants.h"
#import "TWPTweetMediaWellController.h"
#import "TWPTweetMediaWell.h"

NSSize static sDefaultSize;
NSDictionary static* sDefaultTextAttributes;

// Private Interfaces
@interface TWPTextView ()

- ( NSTextView* ) _textView;
- ( void ) _updateConstraints;

+ ( CGFloat ) _textBlockDynamicHeightWithTextStorage: ( NSTextStorage* )_TextStorage blockWidth: ( CGFloat )_TextBlockWidth displaysMediaWell: ( BOOL )_DisplaysMediaWell;
+ ( CGFloat ) _textBlockDynamicHeightWithTextStorage: ( NSTextStorage* )_TextStorage blockWidth: ( CGFloat )_TextBlockWidth mediaWellHeight: ( CGFloat )_MediaWellHeight;

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

    if ( _Tweet.media )
        {
        if ( !self->_tweetMediaWellController )
            self->_tweetMediaWellController = [ TWPTweetMediaWellController mediaWellControllerWithTweet: self->_tweet ];
        else
            self->_tweetMediaWellController.tweet = self->_tweet;
        }
    else
        self->_tweetMediaWellController.tweet = nil;

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
        }

    [ self->_tweetTextStorage replaceCharactersInRange: NSMakeRange( 0, self->_tweetTextStorage.string.length )
                                            withString: self->_tweet.tweetText ];

    [ self->_tweetTextStorage addAttributes: [ [ self class ] defaultTextAttributes ]
                                      range: NSMakeRange( 0, self->_tweetTextStorage.string.length ) ];

    [ self _updateConstraints ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

+ ( NSDictionary* ) defaultTextAttributes
    {
    return sDefaultTextAttributes;
    }

+ ( CGFloat ) textBlockDynamicHeightWithText: ( NSString* )_Text
                                  blockWidth: ( CGFloat )_TextBlockWidth
                           displaysMediaWell: ( BOOL )_DisplaysMediaWell
    {
    NSTextStorage* textStorage = [ [ NSTextStorage alloc ] initWithString: _Text
                                                               attributes: [ [ self class ] defaultTextAttributes ] ];

    return [ [ self class ] _textBlockDynamicHeightWithTextStorage: textStorage
                                                        blockWidth: _TextBlockWidth
                                                 displaysMediaWell: _DisplaysMediaWell ];
    }

- ( CGFloat ) textBlockDynamicHeightWithWidth: ( CGFloat )_TextBlockWidth
    {
    CGFloat mediaWellHeight = 0.f;
    if ( self->_tweet.media )
        mediaWellHeight = _TextBlockWidth * ( 1.f / self->_aspectRatioConstraint.multiplier ) + 10.f;

    CGFloat fsckHeight = [ [ self class ] _textBlockDynamicHeightWithTextStorage: self->_tweetTextStorage
                                                                      blockWidth: _TextBlockWidth
                                                                 mediaWellHeight: mediaWellHeight ];
    return fsckHeight;
    }

#pragma mark Private Interfaces
- ( NSTextView* ) _textView
    {
    return self->_tweetTextStorage.layoutManagers.firstObject.textContainers.firstObject.textView;
    }

- ( void ) _updateConstraints
    {
    [ self removeConstraints: self.constraints ];

    NSTextView* textView = [ self _textView ];
    [ textView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ self addSubview: textView ];

    NSMutableDictionary* viewsDict = [ NSDictionaryOfVariableBindings( textView ) mutableCopy ];

    if ( self->_tweet.media )
        {
        NSView* mediaWell = self->_tweetMediaWellController.mediaWell;

        if ( mediaWell.superview != self )
            [ self addSubview: mediaWell ];

        [ viewsDict addEntriesFromDictionary: NSDictionaryOfVariableBindings( mediaWell ) ];

        NSArray* horizontalConstraints0 = [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView(>=textViewWidth)]|" options: 0 metrics: @{ @"textViewWidth" : @( [ [ self class ] defaultSize ].width ) } views: viewsDict ];
        NSArray* horizontalConstraints1 = [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[mediaWell(==textView)]|" options: 0 metrics: nil views: viewsDict ];

        self->_aspectRatioConstraint = [ NSLayoutConstraint
            constraintWithItem: mediaWell
                     attribute: NSLayoutAttributeWidth
                     relatedBy: NSLayoutRelationEqual
                        toItem: mediaWell
                     attribute: NSLayoutAttributeHeight
                    multiplier: 8.f / 5.f
                      constant: 0 ];

        [ self addConstraint: self->_aspectRatioConstraint ];
        NSArray* verticalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView(==textViewHeight)]-(==space@750)-[mediaWell]|"
                                                                                options: 0
                                                                                metrics: @{ @"textViewHeight" :  @( [ [ self class ] _textBlockDynamicHeightWithTextStorage: self->_tweetTextStorage
                                                                                                                                                       blockWidth: NSWidth( textView.frame )
                                                                                                                                                  mediaWellHeight: 0.f ] )
                                                                                          , @"space" : @( 10.f )
                                                                                          }
                                                                                  views: viewsDict ];
        [ self addConstraints: horizontalConstraints0 ];

        [ self addConstraints: horizontalConstraints1 ];
        [ self addConstraints: verticalConstraints ];
        }
    else
        {
        NSView* mediaWell = self->_tweetMediaWellController.mediaWell;
        [ mediaWell setTranslatesAutoresizingMaskIntoConstraints: NO ];

        if ( mediaWell.superview == self )
            [ mediaWell removeFromSuperview ];

        NSArray* horizontalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView(>=textViewWidth@750)]|" options: 0 metrics: @{ @"textViewWidth" : @( NSWidth( textView.frame ) ) } views: viewsDict ];
        NSArray* verticalConstraints = [ NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView(>=textViewHeight@750)]|" options: 0 metrics: @{ @"textViewHeight" :  @( NSHeight( textView.frame ) ) } views: viewsDict ];
        [ self addConstraints: horizontalConstraints ];
        [ self addConstraints: verticalConstraints ];
        }
    }

+ ( CGFloat ) _textBlockDynamicHeightWithTextStorage: ( NSTextStorage* )_TextStorage
                                          blockWidth: ( CGFloat )_TextBlockWidth
                                   displaysMediaWell: ( BOOL )_DisplaysMediaWell
    {
    CGFloat mediaWellHeight = 0.f;
    if ( _DisplaysMediaWell )
        mediaWellHeight = _TextBlockWidth * ( 5.f / 8.f ) + 10.f;

    return [ self _textBlockDynamicHeightWithTextStorage: _TextStorage
                                              blockWidth: _TextBlockWidth
                                         mediaWellHeight: mediaWellHeight ];
    }

+ ( CGFloat ) _textBlockDynamicHeightWithTextStorage: ( NSTextStorage* )_TextStorage
                                          blockWidth: ( CGFloat )_TextBlockWidth
                                     mediaWellHeight: ( CGFloat )_MediaWellHeight
    {
    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: NSMakeSize( _TextBlockWidth, FLT_MAX ) ];
    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];

    [ layoutManager addTextContainer: textContainer ];
    [ _TextStorage addLayoutManager: layoutManager ];

    ( void )[ layoutManager glyphRangeForTextContainer: textContainer ];
    CGFloat dynamicHeight = NSHeight( [ layoutManager usedRectForTextContainer: textContainer ] );
    dynamicHeight += _MediaWellHeight;

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