//
//  TWPUserAvatarCell.m
//  Twipoker
//
//  Created by Tong G. on 7/13/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import "TWPUserAvatarCell.h"

@implementation TWPUserAvatarCell

- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( nonnull NSView* )_ControlView
    {
    NSBezierPath* bezierPath = [ NSBezierPath bezierPathWithOvalInRect: NSInsetRect( _ControlView.bounds, 1.f, 1.f ) ];
    [ bezierPath addClip ];
    [ [ NSColor lightGrayColor ] setStroke ];
    [ bezierPath stroke ];

    NSImage* image = ( NSImage* )[ self objectValue ];
    [ image drawInRect: NSInsetRect( _ControlView.bounds, 1.f, 1.f )
              fromRect: NSZeroRect
             operation: NSCompositeSourceOver
              fraction: 1.f ];

    if ( self.isHighlighted )
        {
        [ [ [ NSColor grayColor ] colorWithAlphaComponent: .4f ] setFill ];
        [ bezierPath fill ];
        }
    }

- ( NSCellHitResult ) hitTestForEvent: ( NSEvent* )_Event
                               inRect: ( NSRect )_CellFrame
                               ofView: ( NSView* )_ControlView
    {
    NSLog( @"%@", _Event );
    return [ super hitTestForEvent: ( NSEvent* )_Event
                            inRect: ( NSRect )_CellFrame
                            ofView: ( NSView* )_ControlView ];
    }

@end
