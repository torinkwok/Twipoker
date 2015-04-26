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
#import "TWPTimelineTableView.h"
#import "TWPTimelineScrollViewController.h"

// Notification Names
NSString* const TWPTimelineScrollViewTypeUserInfoKey = @"TimelineScrollView.TypeUserInfoKey";

// Type of scroll view controller
NSString* const TWPTimelineScrollViewTypeHome = @"TimelineScrollView.Type.UserInfoKey.Home";
NSString* const TWPTimelineScrollViewTypeFavorites = @"TimelineScrollView.Type.UserInfoKey.Favorites";
NSString* const TWPTimelineScrollViewTypeLists = @"TimelineScrollView.Type.UserInfoKey.Lists";
NSString* const TWPTimelineScrollViewTypeNotifications = @"TimelineScrollView.Type.UserInfoKey.Notifications";
NSString* const TWPTimelineScrollViewTypeMe = @"TimelineScrollView.Type.UserInfoKey.Me";
NSString* const TWPTimelineScrollViewTypeMessages = @"TimelineScrollView.Type.UserInfoKey.Messages";

@interface TWPTimelineScrollView ()
@property ( copy, readwrite ) NSString* type;
@end

// TWPTimelineScrollView class
@implementation TWPTimelineScrollView

@synthesize type;

- ( void ) awakeFromNib
    {
    if ( [ self.identifier isEqualToString: @"home" ] )
        self.type = TWPTimelineScrollViewTypeHome;

    else if ( [ self.identifier isEqualToString: @"favorites" ] )
        self.type = TWPTimelineScrollViewTypeFavorites;

    else if ( [ self.identifier isEqualToString: @"lists" ] )
        self.type = TWPTimelineScrollViewTypeNotifications;

    else if ( [ self.identifier isEqualToString: @"notifications" ] )
        self.type = TWPTimelineScrollViewTypeNotifications;

    else if ( [ self.identifier isEqualToString: @"me" ] )
        self.type = TWPTimelineScrollViewTypeMe;

    else if ( [ self.identifier isEqualToString: @"messages" ] )
        self.type = TWPTimelineScrollViewTypeMessages;
    }

#pragma mark Accessors
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

    if ( currentScrollLocation.y != 0
            && currentScrollLocation.y >= ( NSMaxY( boundsOfDocumentView ) - NSHeight( boundsOfClipView ) ) )
        {
        // Our data source must be not loading older tweets...
        if ( ![ ( TWPTimelineScrollViewController* )self.timelineTableView.dataSource isLoadingOlderTweets ] )
            {
            NSLog( @"> Loading..." );

            // data source is now ready to load tweets... 🚀
            [ ( TWPTimelineScrollViewController* )self.timelineTableView.dataSource setIsLoadingOlderTweets: YES ];
            [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTimelineTableViewDataSourceShouldLoadOlderTweets
                                                                   object: @{ TWPTimelineScrollViewTypeUserInfoKey : self.type } ];
            }
        }
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