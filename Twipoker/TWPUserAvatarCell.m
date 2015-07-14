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

@dynamic avatarOutlinePath;

- ( void ) awakeFromNib
    {
    self->_avatarStrokeColor = [ [ NSColor colorWithHTMLColor: @"C9C9C9" ] colorWithAlphaComponent: .5f ];
    self->_avatarFillColor = [ [ NSColor grayColor ] colorWithAlphaComponent: .4f ];
    }

#pragma mark Custom Drawing
- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( nonnull NSView* )_ControlView
    {
    if ( !self->_avatarOutlinePath )
        {
        self->_avatarOutlinePath = [ NSBezierPath bezierPathWithOvalInRect: NSInsetRect( _ControlView.bounds, 1.f, 1.f ) ];
        [ self->_avatarOutlinePath setLineWidth: 1.f ];
        }

    [ self->_avatarOutlinePath addClip ];

    NSImage* image = ( NSImage* )[ self objectValue ];
    [ image drawInRect: _ControlView.bounds fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.f ];

    [ self->_avatarStrokeColor setStroke ];
    [ self->_avatarOutlinePath stroke ];

    if ( self.isHighlighted )
        {
        [ self->_avatarFillColor setFill ];
        [ self->_avatarOutlinePath fill ];
        }
    }

- ( NSBezierPath* ) avatarOutlinePath
    {
    return self->_avatarOutlinePath;
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