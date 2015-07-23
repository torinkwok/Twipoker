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

#import "TWPTimelineUserNameButton.h"
#import "NSColor+Objectwitter-C.h"

@implementation TWPTimelineUserNameButton

@dynamic twitterUser;

- ( void ) awakeFromNib
    {
    self.bordered = NO;
    }

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

- ( instancetype ) initWithFrame: ( NSRect )_Frame
    {
    if ( self = [ super initWithFrame: _Frame ] )
        [ self _init ];

    return self;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self _init ];

    return self;
    }

- ( void ) _init
    {
    self->_fontOfDisplayName = [ NSFont fontWithName: @"Lato" size: 14.f ];
    self->_colorOfDisplayName = [ NSColor colorWithHTMLColor: @"5B5C59" ];

    self->_fontOfScreenName = [ NSFont fontWithName: @"Lato" size: 12.5f ];
    self->_colorOfScreenName = [ NSColor colorWithHTMLColor: @"A5A5A5" ];
    }

#pragma mark Accessors
- ( OTCTwitterUser* ) twitterUser
    {
    return self->_twitterUser;
    }

- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    self->_twitterUser = _TwitterUser;

    NSSize displayNameStringSizeWithAttrs =
        [ self->_twitterUser.displayName sizeWithAttributes: @{ NSFontAttributeName : self->_fontOfDisplayName } ];

    NSSize screenNameStringSizeWithAttrs =
        [ self->_twitterUser.screenName sizeWithAttributes: @{ NSFontAttributeName : self->_fontOfScreenName } ];

    self->_displayNameStringRect = NSMakeRect( NSMinX( self.bounds )
                                            , NSMinY( self.bounds )
                                             , displayNameStringSizeWithAttrs.width
                                             , displayNameStringSizeWithAttrs.height
                                             );

    self->_screenNameStringRect = NSMakeRect( NSMinX( self.bounds )
                                            , NSMinY( self.bounds ) + displayNameStringSizeWithAttrs.height
                                            , screenNameStringSizeWithAttrs.width
                                            , screenNameStringSizeWithAttrs.height
                                            );
    self->_attributedDisplayNameString =
        [ [ NSAttributedString alloc ] initWithString: self->_twitterUser.displayName
                                           attributes: @{ NSFontAttributeName : self->_fontOfDisplayName
                                                        , NSForegroundColorAttributeName : self->_colorOfDisplayName
                                                        } ];
    self->_attributedScreenNameString =
        [ [ NSAttributedString alloc ] initWithString: self->_twitterUser.screenName
                                           attributes: @{ NSFontAttributeName : self->_fontOfScreenName
                                                        , NSForegroundColorAttributeName : self->_colorOfScreenName
                                                        } ];
    [ self setNeedsDisplay: YES ];
    }

#pragma mark Customize Drawing
- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ self->_attributedDisplayNameString drawInRect: self->_displayNameStringRect ];
    [ self->_attributedScreenNameString drawInRect: self->_screenNameStringRect ];
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