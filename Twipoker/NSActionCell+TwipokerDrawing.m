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

#import <objc/runtime.h>
#import "NSActionCell+TwipokerDrawing.h"

#pragma mark _TWPActionCellRounded Struct & Related Utility Functions
typedef struct
    {
    CGFloat radiusOfTopLeftCorner;
    CGFloat radiusOfBottomLeftCorner;
    CGFloat radiusOfTopRightCorner;
    CGFloat radiusOfBottomRightCorner;
    } _TWPActionCellRounded;

_TWPActionCellRounded _TWPActionCellRoundedCreateWithDefaultValues()
    {
    _TWPActionCellRounded currentRounded = { TWP_DEFAULT_RADIUS_CORNER
                                           , TWP_DEFAULT_RADIUS_CORNER
                                           , TWP_DEFAULT_RADIUS_CORNER
                                           , TWP_DEFAULT_RADIUS_CORNER
                                           };
    return currentRounded;
    }

NSValue* _TWPCocoaWrapperOfNewActionCellRoundedWithDefaultValues()
    {
    _TWPActionCellRounded rounded = _TWPActionCellRoundedCreateWithDefaultValues();
    NSValue* cocoaWrapper = [ NSValue valueWithBytes: &rounded objCType: @encode( _TWPActionCellRounded ) ];

    return cocoaWrapper;
    }

NSValue* _TWPCocoaWrapperOfActionCellRounded( _TWPActionCellRounded _Rounded )
    {
    NSValue* cocoaWrapperOfRadius = [ NSValue valueWithBytes: &_Rounded objCType: @encode( _TWPActionCellRounded ) ];
    return cocoaWrapperOfRadius;
    }

typedef NS_ENUM( NSUInteger, _TWPCornerPosition )
    { _TWPCornerPositionTopLeft
    , _TWPCornerPositionBottomLeft
    , _TWPCornerPositionTopRight
    , _TWPCornerPositionBottomRight
    };

#pragma mark NSActionCell + TwipokerDrawing
@implementation NSActionCell ( TwipokerDrawing )

@dynamic radiusOfTopLeftCorner;
@dynamic radiusOfBottomLeftCorner;
@dynamic radiusOfTopRightCorner;
@dynamic radiusOfBottomRightCorner;

void static* kRoundedKey = @"home.bedroom.TongKuo.Twipoker.constants.kRoundedKey";

#pragma mark Accessors
// Top Left
- ( void ) setRadiusOfTopLeftCorner: ( CGFloat )_RadiusValue
    {
    [ self _setRadius: _RadiusValue forCorner: _TWPCornerPositionTopLeft ];
    }

- ( CGFloat ) radiusOfTopLeftCorner
    {
    return [ self _radiusOfCorner: _TWPCornerPositionTopLeft ];
    }

// Bottom Left
- ( void ) setRadiusOfBottomLeftCorner: ( CGFloat )_RadiusValue
    {
    [ self _setRadius: _RadiusValue forCorner: _TWPCornerPositionBottomLeft ];
    }

- ( CGFloat ) radiusOfBottomLeftCorner
    {
    return [ self _radiusOfCorner: _TWPCornerPositionBottomLeft ];
    }

// Top Right
- ( void ) setRadiusOfTopRightCorner: ( CGFloat )_RadiusValue
    {
    [ self _setRadius: _RadiusValue forCorner: _TWPCornerPositionTopRight ];
    }

- ( CGFloat ) radiusOfTopRightCorner
    {
    return [ self _radiusOfCorner: _TWPCornerPositionTopRight ];
    }

// Bottom Right
- ( void ) setRadiusOfBottomRightCorner: ( CGFloat )_RadiusValue
    {
    [ self _setRadius: _RadiusValue forCorner: _TWPCornerPositionBottomRight ];
    }

- ( CGFloat ) radiusOfBottomRightCorner
    {
    return [ self _radiusOfCorner: _TWPCornerPositionBottomRight ];
    }

- ( CGFloat ) _radiusOfCorner: ( _TWPCornerPosition )_CornerPosition
    {
    _TWPActionCellRounded currentRounded;
    [ ( NSValue* )objc_getAssociatedObject( self, kRoundedKey ) getValue: &currentRounded ];

    CGFloat radiusValue = 0.f;

    switch ( _CornerPosition )
        {
        case _TWPCornerPositionTopLeft:     radiusValue = currentRounded.radiusOfTopLeftCorner;     break;
        case _TWPCornerPositionBottomLeft:  radiusValue = currentRounded.radiusOfBottomLeftCorner;  break;
        case _TWPCornerPositionTopRight:    radiusValue = currentRounded.radiusOfTopRightCorner;    break;
        case _TWPCornerPositionBottomRight: radiusValue = currentRounded.radiusOfBottomRightCorner; break;
        }

    return radiusValue;
    }

- ( void ) _setRadius: ( CGFloat )_RadiusValue
            forCorner: ( _TWPCornerPosition )_CornerPosition
    {
    _TWPActionCellRounded currentRounded;
    [ ( NSValue* )objc_getAssociatedObject( self, kRoundedKey ) getValue: &currentRounded ];

    switch ( _CornerPosition )
        {
        case _TWPCornerPositionTopLeft:     currentRounded.radiusOfTopLeftCorner     = _RadiusValue; break;
        case _TWPCornerPositionBottomLeft:  currentRounded.radiusOfBottomLeftCorner  = _RadiusValue; break;
        case _TWPCornerPositionTopRight:    currentRounded.radiusOfTopRightCorner    = _RadiusValue; break;
        case _TWPCornerPositionBottomRight: currentRounded.radiusOfBottomRightCorner = _RadiusValue; break;
        }

    objc_setAssociatedObject( self, kRoundedKey, _TWPCocoaWrapperOfActionCellRounded( currentRounded ), OBJC_ASSOCIATION_RETAIN );
    [ self.controlView setNeedsDisplay: YES ];
    }

#pragma mark Initialization
// We must implement all of the designated initializers.
// Those methods are: init, initWithCoder:, initTextCell:, and initImageCell:.
- ( instancetype ) init
    {
    if ( self = [ super init ] )
        [ self _doInitialCellSetup ];

    return self;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self _doInitialCellSetup ];

    return self;
    }

- ( instancetype ) initTextCell: ( NSString* )_String
    {
    if ( self = [ super initTextCell: _String ] )
        [ self _doInitialCellSetup ];

    return self;
    }

- ( instancetype ) initImageCell: ( NSImage* )_Image
    {
    if ( self = [ super initImageCell: _Image ] )
        [ self _doInitialCellSetup ];

    return self;
    }

- ( void ) _doInitialCellSetup
    {
    _TWPActionCellRounded rounded = _TWPActionCellRoundedCreateWithDefaultValues();
    objc_setAssociatedObject( self, kRoundedKey, _TWPCocoaWrapperOfActionCellRounded( rounded ), OBJC_ASSOCIATION_RETAIN );
    }

#pragma mark Deallocation
- ( void ) dealloc
    {
    // Clear the association represented by kRadiusOfCornerKey
    objc_setAssociatedObject( self, kRoundedKey, nil, OBJC_ASSOCIATION_RETAIN );
    }

@end // NSActionCell + TwipokerDrawing

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