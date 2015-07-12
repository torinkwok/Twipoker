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
#import "TWPSharedUIElements.h"

@implementation TWPDirectMessagePreviewCellView

@synthesize senderAvatar;
@synthesize senderUserNameLabel;
@synthesize mostRecentDateLabel;
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
    [ mostRecentDateLabel setStringValue: mostRecentDM.dateCreated.description ];
    [ mostTweetPreview setStringValue: mostRecentDM.tweetText ];
    }

- ( void ) awakeFromNib
    {
    // The self->_trackingArea will be created with `NSTrackingInVisibleRect` option,
    // in which case the Application Kit handles the re-computation of self->_trackingArea
    self->_trackingAreaOptions = NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
                                    | NSTrackingInVisibleRect | NSTrackingAssumeInside | NSTrackingMouseMoved;

    self->_trackingArea =
        [ [ NSTrackingArea alloc ] initWithRect: self.bounds options: self->_trackingAreaOptions owner: self userInfo: nil ];

    [ self addTrackingArea: self->_trackingArea ];
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

- ( IBAction ) expandDMSessionButtonClickedAction: ( id )_Sender
    {
    [ self _postNotifForExpandingDMSession ];
    }

#pragma mark Private Interfaces
- ( void ) _postNotifForShowingUserProfile
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldShowUserProfile
                                                           object: self
                                                         userInfo: @{ kTwitterUser : self.senderUserNameLabel.twitterUser } ];
    }

- ( void ) _postNotifForExpandingDMSession
    {
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldExpandDMSession
                                                           object: self
                                                         userInfo: @{ kDirectMessageSession : self->_session } ];
    }

#pragma mark Handling Events
- ( void ) _showExpandDMSessionButton
    {
    [ self removeConstraints: self.constraints ];

    NSButton* expandButton = [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ];
    [ expandButton setTranslatesAutoresizingMaskIntoConstraints: NO ];
    }

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    [ super mouseEntered: _Event ];
    [ self addSubview: [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ] ];
    }

- ( void ) mouseExited: ( NSEvent* )_Event
    {
    [ super mouseExited: _Event ];
    [ [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ] removeFromSuperview ];
    }

- ( void ) scrollWheel: ( NSEvent* )_Event
    {
    [ [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ] removeFromSuperview ];
    [ super scrollWheel: _Event ];
    }

- ( void ) mouseMoved: ( nonnull NSEvent* )_TheEvent
    {
    if ( [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ].superview != self )
        [ self addSubview: [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ] ];

    [ super mouseMoved: _TheEvent ];
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