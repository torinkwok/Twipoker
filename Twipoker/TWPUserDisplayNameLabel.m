//
//  TWPUserDisplayNameLabel.m
//  Twipoker
//
//  Created by Tong G. on 5/2/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "TWPUserDisplayNameLabel.h"

@implementation TWPUserDisplayNameLabel

#pragma mark Events Handling
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ super mouseDown: _Event ];
    [ NSApp sendAction: self.action to: self.target from: self ];
    }

@end
