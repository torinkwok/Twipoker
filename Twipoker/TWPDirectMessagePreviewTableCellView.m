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

#import "TWPDirectMessagePreviewTableCellView.h"
#import "TWPDirectMessageSession.h"
#import "TWPUserAvatarWell.h"

// Notifications Name
NSString* const TWPDirectMessagePreviewTableCellViewMouseDown = @"DirectMessagePreviewTable.Notif.MouseDown";

@implementation TWPDirectMessagePreviewTableCellView

@synthesize userAvatar;
@synthesize userNameLabel;
@synthesize dateLabel;
@synthesize contentPreview;

@dynamic session;

#pragma mark Accessors
- ( TWPDirectMessageSession* ) session
    {
    return self->_session;
    }

- ( void ) setSession: ( TWPDirectMessageSession* )_Session
    {
    self->_session = _Session;

    [ self.userAvatar setTwitterUser: self->_session.otherSideUser ];
    [ self.userNameLabel setStringValue: self->_session.otherSideUser.displayName ];

    OTCDirectMessage* mostRecentDM = [ self->_session mostRecentMessage ];
    [ dateLabel setStringValue: mostRecentDM.dateCreated.description ];
    [ contentPreview setStringValue: mostRecentDM.tweetText ];

    [ self setNeedsDisplay: YES ];
    }

#pragma mark Events Handling
- ( void ) mouseDown: ( NSEvent* )_Event
    {
//    NSLog( @"%@", _Event );

    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPDirectMessagePreviewTableCellViewMouseDown
                                                           object: self ];
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