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

#import "TWPTimelineUserNameLabel.h"

@implementation TWPTimelineUserNameLabel

@dynamic twitterUser;

#pragma mark Initialization
+ ( instancetype ) timelineUserNameLabelWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    if ( self = [ super init ] )
        [ self setTwitterUser: _TwitterUser ];

    return self;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self _initTimelineUserNameLabel ];

    return self;
    }

- ( instancetype ) initWithFrame: ( NSRect )_Frame
    {
    if ( self = [ super initWithFrame: _Frame ] )
        [ self _initTimelineUserNameLabel ];

    return self;
    }

- ( void ) _initTimelineUserNameLabel
    {
    self->_userDisplayNameCell = [ [ NSButtonCell alloc ] initTextCell: @"N/A" ];
    self->_userScreenNameCell = [ [ NSButtonCell alloc ] initTextCell: @"N/A" ];

    [ self->_userDisplayNameCell setBordered: NO ];
    [ self->_userScreenNameCell setBordered: NO ];

    [ self->_userDisplayNameCell setAlignment: NSLeftTextAlignment ];
    [ self->_userScreenNameCell setAlignment: NSLeftTextAlignment ];

    [ self->_userDisplayNameCell setFont: [ NSFont fontWithName: @"Lucida Grande" size: 13.f ] ];
    [ self->_userScreenNameCell setFont: [ NSFont fontWithName: @"Lucida Grande" size: 10.f ] ];
    }

#pragma mark Accessors
- ( OTCTwitterUser* ) twitterUser
    {
    return self->_twitterUser;
    }

- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    if ( self->_twitterUser != _TwitterUser )
        {
        self->_twitterUser = _TwitterUser;

        [ self->_userDisplayNameCell setTitle: self->_twitterUser.displayName ];
        [ self->_userScreenNameCell setTitle: self->_twitterUser.screenName ];

        [ self setNeedsDisplay: YES ];
        }
    }

#pragma mark Customize Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSString* displayNameString = self->_userDisplayNameCell.title;
    NSString* screenNameString = self->_userScreenNameCell.title;

    NSSize displayNameStringSizeWithAttrs =
        [ displayNameString sizeWithAttributes: @{ NSFontNameAttribute : self->_userDisplayNameCell.font } ];

    NSSize screenNameStringSizeWithAttrs =
        [ screenNameString sizeWithAttributes: @{ NSFontNameAttribute : self->_userScreenNameCell.font } ];

    NSRect displayNameRect = NSMakeRect( NSMinX( self.bounds ), NSMinY( self.bounds )
                                       , displayNameStringSizeWithAttrs.width, displayNameStringSizeWithAttrs.height );

    NSRect screenNameRect = NSMakeRect( NSMinX( self.bounds ) + NSWidth( displayNameRect ) + 5.f, NSMinY( self.bounds )
                                      , screenNameStringSizeWithAttrs.width, screenNameStringSizeWithAttrs.height );

//    NSLog( @"Display Name: %@", displayNameString );
//    NSLog( @"Screen Name: %@", screenNameString );
//    NSLog( @"Display Name Rect: %@", NSStringFromRect( displayNameRect ) );
//    NSLog( @"Screen Name Rect: %@", NSStringFromRect( screenNameRect ) );
//    NSLog( @"..." );

//    NSRectFill( displayNameRect );
//    NSRectFill( screenNameRect );

    [ self->_userDisplayNameCell drawWithFrame: displayNameRect inView: self ];
    [ self->_userScreenNameCell drawWithFrame: screenNameRect inView: self ];
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