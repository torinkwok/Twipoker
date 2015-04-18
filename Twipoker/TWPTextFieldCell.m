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

#import "TWPTextField.h"
#import "TWPTextFieldCell.h"
#import "TWPLoginPanel.h"
#import "NSBezierPath+TwipokerDrawing.h"
#import "NSActionCell+TwipokerDrawing.h"

#pragma mark _TWPFieldEditorForLoginPanel
@interface _TWPFieldEditorForLoginPanel : NSTextView
@end // _TWPFieldEditorForLoginPanel

@implementation TWPTextFieldCell

#pragma mark Initialization & Deallocation
- ( void ) awakeFromNib
    {
    [ self setDrawsBackground: NO ];

    self.focusRingType = NSFocusRingTypeNone;
    }

#pragma mark Custom Drawing
- ( NSRect ) titleRectForBounds:( NSRect )_Bounds
    {
    NSRect offsetBounds = _Bounds;
    offsetBounds.origin.x += TWP_DEFAULT_RADIUS_CORNER;
    offsetBounds.size.width -= 20.f;
    offsetBounds.origin.y += 8.f;

    return offsetBounds;
    }

- ( void ) selectWithFrame: ( NSRect )_CellFrame
                    inView: ( NSView* )_ControlView
                    editor: ( NSText* )_FieldEditor
                  delegate: ( id )_DelegateObject
                     start: ( NSInteger )_SelStart
                    length: ( NSInteger )_SelLength
    {
    [ super selectWithFrame: [ self titleRectForBounds: _CellFrame ]
                     inView: _ControlView
                     editor: _FieldEditor
                   delegate: _DelegateObject
                      start: _SelStart
                     length: _SelLength ];
    }


- ( void ) editWithFrame: ( NSRect )_CellFrame
                  inView: ( NSView* )_ControlView
                  editor: ( NSText* )_FieldEditor
                delegate: ( id )_DelegateObject
                   event: ( NSEvent* )_Event
    {
    [ super editWithFrame: [ self titleRectForBounds: _CellFrame ]
                   inView: _ControlView
                   editor: _FieldEditor
                 delegate: _DelegateObject
                    event: _Event ];
    }

- ( void ) endEditing: ( NSText* )_FieldEditor
    {
    [ super endEditing: _FieldEditor ];
    [ self.controlView.superview setNeedsDisplay: YES ];
    }

#pragma mark Custom Drawing
- ( void ) drawInteriorWithFrame: ( NSRect )_CellFrame
                          inView: ( NSView* )_ControlView
    {
    NSTextField* fieldEditor = ( NSTextField* )[ _ControlView.window fieldEditor: NO forObject: _ControlView ];

    if ( ( id )( fieldEditor.delegate ) != _ControlView )
        {
        NSString* contentToBeDrawn = nil;

        NSMutableDictionary* drawingAttributes =
            [ NSMutableDictionary dictionaryWithObjectsAndKeys: fieldEditor.font, NSFontAttributeName, nil ];

        if ( self.stringValue.length > 0 )
            {
            contentToBeDrawn = self.stringValue;
            drawingAttributes[ NSForegroundColorAttributeName ] = self.textColor;
            }
        else if ( self.stringValue.length == 0 && self.placeholderString.length > 0 )
            {
            contentToBeDrawn = self.placeholderString;
            drawingAttributes[ NSForegroundColorAttributeName ] = TWP_PLACEHOLDER_COLOR;
            }

        [ contentToBeDrawn drawInRect: NSInsetRect( fieldEditor.frame, 2.f, 0 ) withAttributes: drawingAttributes ];
        }
    }

- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( NSView* )_ControlView
    {
    [ NSGraphicsContext saveGraphicsState ];
    [ [ NSGraphicsContext currentContext ] setShouldAntialias: YES ];

    NSBezierPath* outlinePath = [ NSBezierPath bezierPathWithRoundedRect: _CellFrame
                                               withRadiusOfTopLeftCorner: self.radiusOfTopLeftCorner
                                                        bottomLeftCorner: self.radiusOfBottomLeftCorner
                                                          topRightCorner: self.radiusOfTopRightCorner
                                                       bottomRightCorner: self.radiusOfBottomRightCorner
                                                               isFlipped: _ControlView.isFlipped ];
    [ outlinePath setLineWidth: 1.5f ];
    [ outlinePath setFlatness: .1f ];

    NSShadow* innerShadowTop = [ [ NSShadow alloc ] init ];
    [ innerShadowTop setShadowOffset: NSMakeSize( 0.f, -1.f ) ];
    [ innerShadowTop setShadowBlurRadius: 2.f ];
    [ innerShadowTop setShadowColor: [ NSColor colorWithSRGBRed: 0 green: 0 blue: 0 alpha: .3f ] ];

    NSShadow* innerShadowBottom = [ [ NSShadow alloc ] init ];
    [ innerShadowBottom setShadowOffset: NSMakeSize( .5f, 1.f ) ];
    [ innerShadowBottom setShadowBlurRadius: 2.f ];
    [ innerShadowBottom setShadowColor: [ NSColor colorWithSRGBRed: 0 green: 0 blue: 0 alpha: .3f ] ];

    NSColor* strokeColor = [ NSColor colorWithSRGBRed: 71.f / 255 green: 134.f / 255 blue: 183.f / 255 alpha: .7f ];
    [ strokeColor setStroke ];

    NSColor* fillColor = [ NSColor colorWithSRGBRed: 253.f / 255 green: 250.f / 255 blue: 250.f / 255 alpha: 1.f ];
    [ fillColor setFill ];

    [ outlinePath fill ];

    [ outlinePath addClip ];

    [ innerShadowBottom set ];
    [ outlinePath stroke ];

    [ innerShadowTop set ];
    [ outlinePath stroke ];
    [NSGraphicsContext restoreGraphicsState];

    [ self drawInteriorWithFrame: _CellFrame inView: _ControlView ];
    }

- ( void ) drawFocusRingMaskWithFrame: ( NSRect )_CellFrame
                               inView: ( NSView* )_ControlView
    {
    [ super drawFocusRingMaskWithFrame: _CellFrame
                                inView: _ControlView ];
    }

- ( NSText* ) setUpFieldEditorAttributes: ( NSText* )_FieldEditor
    {
    NSTextView* fieldEditor = ( NSTextView* )[ super setUpFieldEditorAttributes: _FieldEditor ];
    [ fieldEditor setInsertionPointColor: TWP_PLACEHOLDER_COLOR ];

    return fieldEditor;
    }

_TWPFieldEditorForLoginPanel __strong* _fieldEditor;
- ( NSTextView* ) fieldEditorForView: ( NSView* )_ControlView
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    _fieldEditor = [ [ _TWPFieldEditorForLoginPanel alloc ] init ];
                    } );

    return _fieldEditor;
    }

@end

#pragma mark _TWPFieldEditorForLoginPanel
@implementation _TWPFieldEditorForLoginPanel

- ( BOOL ) isFieldEditor
    {
    return YES;
    }

- ( void ) drawInsertionPointInRect: ( NSRect )_Rect
                              color: ( NSColor* )_Color
                           turnedOn: ( BOOL )_DrawInsertionPoint
    {
    [ super drawInsertionPointInRect: _Rect color: _Color turnedOn: YES ];
    }

@end // _TWPFieldEditorForLoginPanel

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