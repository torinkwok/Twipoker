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

#import "TWPNavBarTotemView.h"

// TWPNavBarTotemView class
@implementation TWPNavBarTotemView

@dynamic content;

@synthesize imageContentView = _imageContentView;
@synthesize textContentView = _textContentView;

#pragma mark Dynamic Accessors
- ( void ) setContent: ( id )_Content
    {
    if ( self->_content != _Content )
        {
        self->_content = _Content;

        [ self setSubviews: @[] ];
        [ self removeConstraints: self.constraints ];

        NSView* contentView = nil;
        if ( [ self->_content isKindOfClass: [ NSImage class ] ] )
            {
            [ self->_imageContentView setImage: ( NSImage* )( self->_content ) ];
            [ self addSubview: self->_imageContentView ];
            contentView = self->_imageContentView;
            self->_typeStatus = TWPNavBarTotemViewTypeStatusImage;
            }

        else if ( [ self->_content isKindOfClass: [ NSString class ] ] )
            {
            NSSize sizeWithAttributes = [ self->_content sizeWithAttributes:
                @{ NSFontAttributeName : [ NSFont fontWithName: @"Lucida Grande" size: 15.f ] } ];

            [ self->_textContentView setFrame: NSMakeRect( NSMinX( self->_textContentView.frame )
                                                         , NSMinY( self->_textContentView.frame )
                                                         , sizeWithAttributes.width
                                                         , sizeWithAttributes.height
                                                         ) ];

            [ self->_textContentView setStringValue: ( NSString* )( self->_content ) ];
            [ self addSubview: self->_textContentView ];
            contentView = self->_textContentView;
            self->_typeStatus = TWPNavBarTotemViewTypeStatusText;
            }

        NSDictionary* viewsDict = NSDictionaryOfVariableBindings( contentView );
        [ contentView setTranslatesAutoresizingMaskIntoConstraints: NO ];

        NSLayoutConstraint* centerHorizontallyConstraint = [ NSLayoutConstraint
            constraintWithItem: self
                     attribute: NSLayoutAttributeCenterX
                     relatedBy: NSLayoutRelationEqual
                        toItem: contentView
                     attribute: NSLayoutAttributeCenterX
                    multiplier: 1.f
                      constant: 0.f ];

        NSArray* centerVerticallyConstraints = [ NSLayoutConstraint
            constraintsWithVisualFormat: @"V:|-(>=space)-[contentView(==contentViewHeight)]-(>=space)-|"
                                options: 0
                                metrics: @{ @"space" : @( ( NSHeight( self.frame ) - NSHeight( contentView.frame ) ) / 2 )
                                          , @"contentViewHeight" : @( NSHeight( contentView.frame ) )
                                          }
                                  views: viewsDict ];

        [ self addConstraint: centerHorizontallyConstraint ];
        [ self addConstraints: centerVerticallyConstraints ];
        }
    }

- ( id ) content
    {
    return self->_content;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    
    [ [ NSColor whiteColor ] set ];
    NSRectFill( _DirtyRect );
    }

@end // TWPNavBarTotemView class

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