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

// Corresponding Values of TWPTimelineScrollViewTypeUserInfoKey
NSString* const TWPTimelineScrollViewTypeUserInfoKeyHome = @"TimelineScrollView.Type.UserInfoKey.Home";
NSString* const TWPTimelineScrollViewTypeUserInfoKeyFavorites = @"TimelineScrollView.Type.UserInfoKey.Favorites";
NSString* const TWPTimelineScrollViewTypeUserInfoKeyLists = @"TimelineScrollView.Type.UserInfoKey.Lists";
NSString* const TWPTimelineScrollViewTypeUserInfoKeyNotifications = @"TimelineScrollView.Type.UserInfoKey.Notifications";
NSString* const TWPTimelineScrollViewTypeUserInfoKeyMe = @"TimelineScrollView.Type.UserInfoKey.Me";
NSString* const TWPTimelineScrollViewTypeUserInfoKeyMessages = @"TimelineScrollView.Type.UserInfoKey.Messages";

// TWPTimelineScrollView class
@implementation TWPTimelineScrollView

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

            NSString* typeString = nil;
            if ( [ self.identifier isEqualToString: @"home" ] )
                typeString = TWPTimelineScrollViewTypeUserInfoKeyHome;

            else if ( [ self.identifier isEqualToString: @"favorites" ] )
                typeString = TWPTimelineScrollViewTypeUserInfoKeyFavorites;

            else if ( [ self.identifier isEqualToString: @"notifications" ] )
                typeString = TWPTimelineScrollViewTypeUserInfoKeyNotifications;

            // TODO: Waiting for Favs, Lists, Me and Messages

            // data source is now ready to load tweets... 🚀
            [ ( TWPTimelineScrollViewController* )self.timelineTableView.dataSource setIsLoadingOlderTweets: YES ];
            [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTimelineTableViewDataSourceShouldLoadOlderTweets
                                                                   object: @{ TWPTimelineScrollViewTypeUserInfoKey : typeString ?: [ NSNull null ]
                                                                            } ];
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