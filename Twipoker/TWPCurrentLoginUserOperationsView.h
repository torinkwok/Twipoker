//
//  TWPCurrentLoginUserOperationsView.h
//  Twipoker
//
//  Created by Tong G. on 7/17/15.
//  Copyright © 2015 Tong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TWPCurrentLoginUserOperationsView : NSView

@property ( weak ) IBOutlet NSButton* editProfileButton;
@property ( weak ) IBOutlet NSButton* switchAccountButton;
@property ( weak ) IBOutlet NSButton* logoutButton;

@end
