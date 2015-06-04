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

#import "TWPTimelineScrollView.h"

// TWPTimelineScrollView class
@implementation TWPTimelineScrollView

#pragma mark Accessors
@synthesize delegate;
@dynamic timelineTableView;

- ( TWPTimelineTableView* ) timelineTableView
    {
    return ( TWPTimelineTableView* )[ self documentView ];
    }

#pragma mark Overrides
- ( void ) reflectScrolledClipView: ( NSClipView* )_ClipView
    {
    [ super reflectScrolledClipView: _ClipView ];

    NSRect boundsOfDocumentView = [ self.documentView bounds ];
    NSRect boundsOfClipView = [ self.contentView bounds ];

    NSPoint currentScrollLocation = boundsOfClipView.origin;

    if ( currentScrollLocation.y != 0 )
        {
        if ( currentScrollLocation.y >= ( NSMaxY( boundsOfDocumentView ) - NSHeight( boundsOfClipView ) ) )
            {
            if ( self.delegate && [ self.delegate respondsToSelector: @selector( timelineScrollView:shouldFetchOlderTweets: ) ] )
                [ self.delegate timelineScrollView: self shouldFetchOlderTweets: _ClipView ];
            }
        }
    }

- ( void ) setFrame: ( NSRect )_Frame
    {
    NSLog( @"%s: %@", __PRETTY_FUNCTION__, NSStringFromRect( _Frame ) );
    NSRect newFrame = _Frame;
    newFrame.origin.y = 0;
    [ super setFrame: newFrame ];
    NSLog( @"%s: %@", __PRETTY_FUNCTION__, NSStringFromRect( newFrame ) );
    }

@end // TWPTimelineScrollView class

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