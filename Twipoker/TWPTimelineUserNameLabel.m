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

        NSSize displayNameStringSizeWithAttrs =
            [ self->_twitterUser.displayName sizeWithAttributes: @{ NSFontNameAttribute : [ NSFont fontWithName: @"Heiti SC" size: 20.f ] } ];

        NSSize screenNameStringSizeWithAttrs =
            [ self->_twitterUser.screenName sizeWithAttributes: @{ NSFontNameAttribute : [ NSFont fontWithName: @"Heiti SC" size: 10.f ] } ];

        self->_displayNameStringRect = NSMakeRect( NSMinX( self.bounds ), NSMinY( self.bounds )
                                                 , displayNameStringSizeWithAttrs.width, displayNameStringSizeWithAttrs.height
                                                 );

        self->_screenNameStringRect = NSMakeRect( NSMinX( self.bounds ) + NSWidth( self->_displayNameStringRect ) + 5.f, NSMinY( self.bounds )
                                                , screenNameStringSizeWithAttrs.width, screenNameStringSizeWithAttrs.height
                                                );

        [ self setNeedsDisplay: YES ];
        }
    }

#pragma mark Customize Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSAttributedString* attributedDisplayNameString =
        [ [ NSAttributedString alloc ] initWithString: self->_twitterUser.displayName
                                           attributes: @{ NSFontNameAttribute : [ NSFont fontWithName: @"Heiti SC" size: 20.f ]
                                                        , NSForegroundColorAttributeName : [ NSColor colorWithSRGBRed: 102.f / 255 green: 117.f / 255 blue: 100.f / 255 alpha: 1.f ]
                                                        } ];

    [ attributedDisplayNameString drawInRect: self->_displayNameStringRect ];

    NSAttributedString* attributedScreenNameString =
        [ [ NSAttributedString alloc ] initWithString: self->_twitterUser.screenName
                                           attributes: @{ NSFontNameAttribute : [ NSFont fontWithName: @"Heiti SC" size: 10.f ]
                                                        , NSForegroundColorAttributeName : [ NSColor colorWithSRGBRed: 102.f / 255 green: 117.f / 255 blue: 100.f / 255 alpha: 1.f ]
                                                        } ];

    [ attributedScreenNameString drawInRect: self->_screenNameStringRect ];
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