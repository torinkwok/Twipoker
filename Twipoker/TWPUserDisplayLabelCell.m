//
//  TWPUserDisplayLabelCell.m
//  Twipoker
//
//  Created by Tong G. on 5/2/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "TWPUserDisplayLabelCell.h"

@implementation TWPUserDisplayLabelCell

- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( NSView* )_ControlView
    {
    [ [ NSColor grayColor ] set ];
    [ super drawWithFrame: _CellFrame inView: _ControlView ];
    }

@end
