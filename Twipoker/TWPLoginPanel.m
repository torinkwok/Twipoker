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

#import "TWPLoginPanel.h"
#import "TWPTextField.h"

@implementation TWPLoginPanel

#pragma mark Initialization & Deallocation
- ( void ) awakeFromNib
    {
    self.showsBaselineSeparator = NO;
    self.titleBarDrawingBlock =
        ^( BOOL _DrawsAsMainWindow, CGRect _DrawingRect, CGRectEdge _Edge, CGPathRef _ClippingPath )
            {
            CGContextRef cgContext = [ [ NSGraphicsContext currentContext ] graphicsPort ];

            if ( _ClippingPath )
                {
                CGContextAddPath( cgContext, _ClippingPath );
                CGContextClip( cgContext );
                }

            NSColor* endColor = [ NSColor colorWithSRGBRed: 121.f / 255 green: 187.f / 255 blue: 237.f / 255 alpha: 1.f ];

            NSGradient* titleBarGradient = [ [ NSGradient alloc ] initWithColorsAndLocations: TWP_TWITTER_STARTING_COLOR, .4f, endColor, 1.f, nil ];
            NSBezierPath* titleBarPath = [ NSBezierPath bezierPathWithRect: _DrawingRect ];

            [ titleBarGradient drawInBezierPath: titleBarPath relativeCenterPosition: NSMakePoint( 0.F, 0.F ) ];
            };
    }

#pragma mark Custom Behavior
- ( BOOL ) isMovableByWindowBackground
    {
    return YES;
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