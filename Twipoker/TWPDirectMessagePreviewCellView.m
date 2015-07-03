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

#import "TWPDirectMessagePreviewCellView.h"
#import "TWPDirectMessageSession.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameButton.h"

@implementation TWPDirectMessagePreviewCellView

@synthesize senderAvatar;
@synthesize senderUserNameLabel;
@synthesize mostDateLabel;
@synthesize mostTweetPreview;

@dynamic session;

#pragma mark Accessors
- ( TWPDirectMessageSession* ) session
    {
    return self->_session;
    }

- ( void ) setSession: ( TWPDirectMessageSession* )_Session
    {
    self->_session = _Session;

    [ self.senderAvatar setTwitterUser: self->_session.otherSideUser ];
    [ self.senderUserNameLabel setTwitterUser: self->_session.otherSideUser ];

    OTCDirectMessage* mostRecentDM = [ self->_session mostRecentMessage ];
    [ mostDateLabel setStringValue: mostRecentDM.dateCreated.description ];
    [ mostTweetPreview setStringValue: mostRecentDM.tweetText ];

    [ self setNeedsDisplay: YES ];
    }

- ( void ) awakeFromNib
    {
    [ self.window visualizeConstraints: self.constraints ];
    }

#pragma mark IBAction
- ( IBAction ) userNameLabelClickedAction: ( id )_Sender
    {
    [ self _postNotifForShowingUserProfile ];
    }

- ( IBAction ) userAvatarClickedAction: ( id )_Sender
    {
    [ self _postNotifForShowingUserProfile ];
    }

#pragma mark Private Interfaces
- ( void ) _postNotifForShowingUserProfile
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldShowUserProfile
                                                           object: self
                                                         userInfo: @{ kTwitterUser : self.senderUserNameLabel.twitterUser } ];
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