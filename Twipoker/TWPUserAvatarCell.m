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

#import "TWPUserAvatarCell.h"

// TWPUserAvatarCell class
@implementation TWPUserAvatarCell

@dynamic bezierPath;

#pragma mark Custom Drawing
- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( nonnull NSView* )_ControlView
    {
    NSRect drawingRect = NSInsetRect( _ControlView.bounds, 1.f, 1.f );

    if ( !self->_bezierPath )
        self->_bezierPath = [ NSBezierPath bezierPathWithOvalInRect: drawingRect ];

    [ self->_bezierPath addClip ];

    NSImage* image = ( NSImage* )[ self objectValue ];
    [ image drawInRect: NSInsetRect( _ControlView.bounds, 1.f, 1.f ) fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.f ];

    [ [ [ NSColor colorWithHTMLColor: @"C9C9C9" ] colorWithAlphaComponent: .5f ] setStroke ];
    [ self->_bezierPath stroke ];

    if ( self.isHighlighted )
        {
        [ [ [ NSColor grayColor ] colorWithAlphaComponent: .4f ] setFill ];
        [ self->_bezierPath fill ];
        }
    }

- ( NSBezierPath* ) bezierPath
    {
    return self->_bezierPath;
    }

@end // TWPUserAvatarCell class

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