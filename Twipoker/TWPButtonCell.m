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

#import "TWPButtonCell.h"
#import "NSBezierPath+TwipokerDrawing.h"
#import "NSAffineTransform+TwipokerDrawing.h"

#import "_TWPButtonCell.h"

@implementation TWPButtonCell

- ( void ) awakeFromNib
    {
    [ self setButtonType: NSMomentaryPushInButton ];
    }


#pragma mark Custom Drawing
- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( NSView* )_ControlView
    {
    NSBezelStyle bezelStyleOfReceiver = self.bezelStyle;

    switch ( bezelStyleOfReceiver )
        {
        case NSHelpButtonBezelStyle:
            [ super drawWithFrame: _CellFrame inView: _ControlView ];
            break;

        default:
            [ self _drawTexturedRoundedButtonWithFrame: _CellFrame withTwipokerStyleInView: _ControlView ];
            break;
        }
    }

- ( void ) drawInteriorWithFrame: ( NSRect )_CellFrame
                          inView: ( NSView* )_ControlView
    {
    NSBezelStyle bezelStyleOfReceiver = self.bezelStyle;
    switch ( bezelStyleOfReceiver )
        {
        case NSHelpButtonBezelStyle:
            [ super drawInteriorWithFrame: _CellFrame inView: _ControlView ];
            break;

        default:
            [ self _drawInteriorWithFrame: _CellFrame withTwipokerStyleInView: _ControlView ];
            break;
        }
    }

@end

#pragma mark TWPButtonCell + _TWPButtonCellDrawing
@implementation TWPButtonCell ( _TWPButtonCellDrawing )

- ( void ) _drawTexturedRoundedButtonWithFrame: ( NSRect )_CellFrame
                       withTwipokerStyleInView: ( NSView* )_ControlView
    {
    [ NSGraphicsContext saveGraphicsState ];
    [ [ NSGraphicsContext currentContext ] setShouldAntialias: YES ];

    NSBezierPath* outlinePath = [ NSBezierPath bezierPathWithRoundedRect: self.controlView.bounds
                                               withRadiusOfTopLeftCorner: self.radiusOfTopLeftCorner
                                                        bottomLeftCorner: self.radiusOfBottomLeftCorner
                                                          topRightCorner: self.radiusOfTopRightCorner
                                                       bottomRightCorner: self.radiusOfBottomRightCorner
                                                               isFlipped: _ControlView.isFlipped ];

    [ outlinePath transformUsingAffineTransform: [ NSAffineTransform flipTransformForRect: _CellFrame ] ];

    [ outlinePath addClip ];
    outlinePath.flatness = .1f;
    outlinePath.lineWidth = 1.7f;

    NSColor* startingColor = nil;
    NSColor* endingColor = nil;
    NSShadow* buttonInnerShadowTop = nil;
    NSShadow* buttonInnerShadowBottom = nil;

    BOOL const isNowHighlighted = self.isHighlighted;

    if ( isNowHighlighted )
        {
        startingColor = [ NSColor colorWithSRGBRed: 248.f / 255 green: 248.f / 255 blue: 248.f / 255 alpha: 1.f ];
        endingColor = [ NSColor colorWithSRGBRed: 190.f / 255 green: 190.f / 255 blue: 190.f / 255 alpha: 1.f ];

        NSColor* pressedShadowColor = [ [ NSColor blackColor ] colorWithAlphaComponent: .5f ];
        buttonInnerShadowTop = [ [ NSShadow alloc ] init ];
        [ buttonInnerShadowTop setShadowOffset: NSMakeSize( .2f, .2f ) ];
        [ buttonInnerShadowTop setShadowColor: pressedShadowColor ];
        [ buttonInnerShadowTop setShadowBlurRadius: 3.f ];

        buttonInnerShadowBottom = [ [ NSShadow alloc ] init ];
        [ buttonInnerShadowBottom setShadowOffset: NSMakeSize( -.2f, -.2f ) ];
        [ buttonInnerShadowBottom setShadowColor: pressedShadowColor ];
        [ buttonInnerShadowBottom setShadowBlurRadius: 3.f ];
        }
    else
        {
        startingColor = [ NSColor whiteColor ];
        endingColor = [ NSColor colorWithSRGBRed: 211.f / 255 green: 208.f / 255 blue: 208.f / 255 alpha: 1.f ];
        }

    NSGradient* gradient = [ [ NSGradient alloc ] initWithColorsAndLocations: startingColor, .1f, endingColor, 1.f, nil ];
    [ gradient drawInBezierPath: outlinePath angle: 90.f ];

    NSColor* strokeColor = [ NSColor colorWithSRGBRed: 71.f / 255 green: 134.f / 255 blue: 183.f / 255 alpha: isNowHighlighted ? .7f : 1.f ];
    [ strokeColor setStroke ];

    if ( isNowHighlighted )
        {
        [ buttonInnerShadowBottom set ];
        [ outlinePath stroke ];
        [ buttonInnerShadowTop set ];
        [ outlinePath stroke ];
        }
    else
        [ outlinePath stroke ];

    [ NSGraphicsContext restoreGraphicsState ];

    [ self drawInteriorWithFrame: _CellFrame inView: _ControlView ];
    }

- ( void ) _drawInteriorWithFrame: ( NSRect )_CellFrame
          withTwipokerStyleInView: ( NSView* )_ControlView
    {
    NSMutableAttributedString* contentToBeRendered = [ self.attributedTitle mutableCopy ];

    NSRangePointer effectiveRanges = malloc( sizeof( NSRange ) );
    NSAssert( effectiveRanges, @"" );
    effectiveRanges[ 0 ] = NSMakeRange( 0, contentToBeRendered.length );

    NSMutableDictionary* attributes = [ [ contentToBeRendered attributesAtIndex: 0 effectiveRange: effectiveRanges ] mutableCopy ];
    free( effectiveRanges );

    NSColor* contentColor = nil;
    if ( self.isEnabled )
        contentColor = [ [ NSColor blackColor ] colorWithAlphaComponent: .6f ];
    else
        contentColor = [ [ NSColor grayColor ] colorWithAlphaComponent: .8f ];

    attributes[ NSForegroundColorAttributeName ] = contentColor;

    NSShadow* shadow = [ [ NSShadow alloc ] init ];
    [ shadow setShadowOffset: NSMakeSize( 0.f, -1.2f ) ];
    [ shadow setShadowColor: [ NSColor whiteColor ] ];
    attributes[ NSShadowAttributeName ] = shadow;

    NSSize sizeOfContent = [ contentToBeRendered.string sizeWithAttributes: attributes ];
    NSRect drawInRect = NSMakeRect( ( NSWidth( _ControlView.bounds ) - sizeOfContent.width ) / 2
                                  , ( NSHeight( _ControlView.bounds ) - sizeOfContent.height ) / 2
                                  , sizeOfContent.width
                                  , sizeOfContent.height
                                  );

    [ contentToBeRendered.string drawInRect: drawInRect withAttributes: attributes ];
    }

@end // TWPButtonCell + _TWPButtonCellDrawing

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