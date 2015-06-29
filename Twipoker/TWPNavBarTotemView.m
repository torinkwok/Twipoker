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

#pragma mark Initializations
- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        {
        self->_imageContentView = [ [ NSImageView alloc ] initWithFrame: NSMakeRect( 0, 0, 20.f, 20.f ) ];

        self->_textContentView = [ [ NSTextField alloc ] initWithFrame: NSMakeRect( 0, 0, 30, 20 ) ];
        [ self->_textContentView setDrawsBackground: NO ];
        [ self->_textContentView setBordered: NO ];
        [ self->_textContentView setFont: [ NSFont fontWithName: @"Lucida Grande" size: 15.f ] ];
        [ self->_textContentView setStringValue: @"" ];
        }

    return self;
    }

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

        [ contentView setTranslatesAutoresizingMaskIntoConstraints: NO ];
        NSLayoutConstraint* centerVerticallyConstraint = [ NSLayoutConstraint
            constraintWithItem: self
                     attribute: NSLayoutAttributeCenterY
                     relatedBy: NSLayoutRelationEqual
                        toItem: contentView
                     attribute: NSLayoutAttributeCenterY
                    multiplier: 1.f
                      constant: 0.f ];

        NSLayoutConstraint* centerHorizontallyConstraint = [ NSLayoutConstraint
            constraintWithItem: self
                     attribute: NSLayoutAttributeCenterX
                     relatedBy: NSLayoutRelationEqual
                        toItem: contentView
                     attribute: NSLayoutAttributeCenterX
                    multiplier: 1.f
                      constant: 0.f ];

        [ self addConstraint: centerVerticallyConstraint ];
        [ self addConstraint: centerHorizontallyConstraint ];

        [ self.window visualizeConstraints: self.constraints ];
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