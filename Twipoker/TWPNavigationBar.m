//
//  TWPNavigationBar.m
//  Twipoker
//
//  Created by Tong G. on 4/30/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "TWPNavigationBar.h"

@implementation TWPNavigationBar

- ( void ) awakeFromNib
    {
//    self.wantsLayer = YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    }

- ( BOOL ) allowsVibrancy
    {
    return YES;
    }

- ( BOOL ) wantsLayer
    {
    return YES;
    }

@end
