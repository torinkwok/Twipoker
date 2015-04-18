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

#import "TWPWindow.h"

@implementation TWPWindow

#pragma mark Initialization & Deallocation
- ( instancetype ) initWithContentRect: ( NSRect )_FrameRect
                             styleMask: ( NSUInteger )_StyleMask
                               backing: ( NSBackingStoreType )_BufferingType
                                 defer: ( BOOL )_Flag
    {
    if ( self = [ super initWithContentRect: _FrameRect
                                  styleMask: _StyleMask
                                    backing: _BufferingType
                                      defer: _Flag ] )
        [ self _createTwitterStyleWindow ];

    return self;
    }

- ( instancetype ) initWithContentRect: ( NSRect )_FrameRect
                             styleMask: ( NSUInteger )_StyleMask
                               backing: ( NSBackingStoreType )_BufferingType
                                 defer: ( BOOL )_Flag
                                screen: ( NSScreen* )_Screen
    {
    if ( self = [ super initWithContentRect: _FrameRect
                                  styleMask: _StyleMask
                                    backing: _BufferingType
                                      defer: _Flag
                                     screen: _Screen ] )
        [ self _createTwitterStyleWindow ];

    return self;
    }

- ( void ) _createTwitterStyleWindow
    {
    self.titleBarHeight = 40.f;
    self.trafficLightButtonsLeftMargin = 15.f;

    self.titleBarDrawingBlock =
        ^( BOOL _DrawsAsMainWindow, CGRect _DrawingRect, CGRectEdge _Edge, CGPathRef _ClippingPath )
            {
            CGContextRef cgContext = [ [ NSGraphicsContext currentContext ] graphicsPort ];

            if ( _ClippingPath )
                {
                CGContextAddPath( cgContext, _ClippingPath );
                CGContextClip( cgContext );
                }

            NSBezierPath* outlinePath = [ NSBezierPath bezierPathWithRect: _DrawingRect ];
            [ TWP_TWITTER_COLOR set ];
            [ outlinePath fill ];
            };
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