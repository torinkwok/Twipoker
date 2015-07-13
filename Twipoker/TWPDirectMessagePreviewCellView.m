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

// Private Interfaces
@interface TWPDirectMessagePreviewCellView ()
@property ( assign, readwrite, setter = setShowingExpandButton: ) BOOL isShowingExpandButton;
@end // Private Interfaces

// TWPDirectMessagePreviewCellView class
@implementation TWPDirectMessagePreviewCellView

@synthesize senderAvatar = _senderAvatar;
@synthesize senderUserNameLabel = _senderUserNameLabel;
@synthesize mostRecentDateLabel = _mostRecentDateLabel;
@synthesize mostTweetPreview = _mostTweetPreview;

@dynamic session;

@dynamic isShowingExpandButton;

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
    [ self.mostRecentDateLabel setStringValue: mostRecentDM.dateCreated.description ];
    [ self.mostTweetPreview setStringValue: mostRecentDM.tweetText ];

    self.isShowingExpandButton = NO;
    }

- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        self->_isShowingExpandButton = NO;

    return self;
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

    self->_hiddenExpandButtonConstraints = self.constraints;
    }

#pragma mark Dynamic Accessors
- ( void ) setShowingExpandButton: ( BOOL )_IsShowingExpandButton
    {
    self->_isShowingExpandButton = _IsShowingExpandButton;
    [ self setNeedsUpdateConstraints: YES ];
    }

- ( BOOL ) isShowingExpandButton
    {
    return self->_isShowingExpandButton;
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
    self.isShowingExpandButton = NO;
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: TWPTwipokerShouldShowUserProfile
                                                           object: self
                                                         userInfo: @{ kTwitterUser : self.senderUserNameLabel.twitterUser } ];
    }

#pragma mark Handling Events

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    [ super mouseEntered: _Event ];
    self.isShowingExpandButton = YES;
    }

- ( void ) mouseExited: ( NSEvent* )_Event
    {
    [ super mouseExited: _Event ];
    self.isShowingExpandButton = NO;
    }

- ( void ) scrollWheel: ( NSEvent* )_Event
    {
    [ super scrollWheel: _Event ];
    self.isShowingExpandButton = NO;
    }

- ( void ) mouseMoved: ( nonnull NSEvent* )_TheEvent
    {
    [ super mouseMoved: _TheEvent ];
    self.isShowingExpandButton = YES;
    }

#pragma mark Handling Constraints-Based Auto Layout
- ( void ) updateConstraints
    {
    [ super updateConstraints ];

    TWPExpandDMSessionButton* expandButton = [ [ TWPSharedUIElements sharedElements ] expandDMSessionButton ];

    if ( self->_isShowingExpandButton )
        {
        if ( expandButton.superview != self )
            {
            [ expandButton setDMSession: self->_session ];
            [ self addSubview: expandButton ];

            [ self removeConstraints: self.constraints ];

            TWPUserAvatarWell* avatar = self.senderAvatar;
            TWPTimelineUserNameButton* senderNameLabel = self.senderUserNameLabel;
            [ senderNameLabel removeConstraints: senderNameLabel.constraints ];
            NSTextField* dateLabel = self.mostRecentDateLabel;
            NSTextField* dmPreview = self.mostTweetPreview;
            [ dmPreview removeConstraints: dmPreview.constraints ];
            NSDictionary* viewsDict = NSDictionaryOfVariableBindings( avatar, senderNameLabel, dateLabel, dmPreview, expandButton );
            if ( !self->_showingExpandButtonConstraints.count )
                {
                self->_showingExpandButtonConstraints = [ NSMutableArray array ];

                NSArray* horizontalLayoutConstraints0 = [ NSLayoutConstraint
                    constraintsWithVisualFormat: @"H:|-(==leadingSpace)"
                                                  "-[avatar(==avatarWidth)]"
                                                  "-(==space_avatarTrailing_senderNamelabelLeading)"
                                                  "-[senderNameLabel(>=senderNameLabelWidth)]"
                                                  "-(>=space_senderNameLabelTrailing_expandButtonLeading)"
                                                  "-[expandButton(==expandButtonWidth)]|"
                                        options: 0
                                        metrics: @{ @"leadingSpace" : @( NSMinX( avatar.frame ) )
                                                  , @"avatarWidth" : @( NSWidth( avatar.frame ) )
                                                  , @"space_avatarTrailing_senderNamelabelLeading" : @( NSMinX( senderNameLabel.frame ) - NSMaxX( avatar.frame ) )
                                                  , @"senderNameLabelWidth" : @( NSMaxX( self.frame ) - NSWidth( expandButton.frame ) - 20.f - NSMinX( senderNameLabel.frame ) )
                                                  , @"space_senderNameLabelTrailing_expandButtonLeading" : @( NSWidth( self.frame ) - NSMaxX( senderNameLabel.frame ) - NSWidth( expandButton.frame ) )
                                                  , @"expandButtonWidth" : @( NSWidth( expandButton.frame ) )
                                                  }
                                          views: viewsDict ];

                NSArray* horizontalLayoutConstraints1 = [ NSLayoutConstraint
                    constraintsWithVisualFormat: @"H:|-(==leadingSpace)"
                                                  "-[avatar(==avatarWidth)]"
                                                  "-(==space_avatarTrailing_dmPreviewLeading)"
                                                  "-[dmPreview(>=dmPreviewWidth)]"
                                                  "-(==space_dmPreviewTrailing_expandButtonLeading)"
                                                  "-[expandButton(==expandButtonWidth)]|"
                                        options: 0
                                        metrics: @{ @"leadingSpace" : @( NSMinX( avatar.frame ) )
                                                  , @"avatarWidth" : @( NSWidth( avatar.frame ) )
                                                  , @"space_avatarTrailing_dmPreviewLeading" : @( NSMinX( dmPreview.frame ) - NSMaxX( avatar.frame ) )
                                                  , @"dmPreviewWidth" : @( NSWidth( dmPreview.frame ) )
                                                  , @"space_dmPreviewTrailing_expandButtonLeading" : @( NSWidth( self.frame ) - NSMaxX( dmPreview.frame ) - NSWidth( expandButton.frame ) )
                                                  , @"expandButtonWidth" : @( NSWidth( expandButton.frame ) )
                                                  }
                                          views: viewsDict ];

                NSArray* verticalLayoutConstraints0 = [ NSLayoutConstraint
                    constraintsWithVisualFormat: @"V:|-(==topSpace)"
                                                  "-[avatar(==avatarHeight)]"
                                                  "-(>=space_avatarBottom_superViewBottom)-|"
                                        options: 0
                                        metrics: @{ @"topSpace" : @( NSMaxY( self.frame ) - NSMaxY( avatar.frame ) )
                                                  , @"avatarHeight" : @( NSHeight( avatar.frame ) )
                                                  , @"space_avatarBottom_superViewBottom" : @( NSMinY( avatar.frame ) - NSMinY( self.frame ) )
                                                  }
                                          views: viewsDict ];

//                NSArray* verticalLayoutConstraints1 = [ NSLayoutConstraint
//                    constraintsWithVisualFormat: @"V:|-(==topSpace)"
//                                                  "-[senderNameLabel(==senderNameLabelHeight)]"
//                                                  "-(>=space_senderNameLabelBottom_dmPreviewTop)"
//                                                  "-[dmPreview(==dmPreviewHeight)]
//                                        options: 0
//                                        metrics: @{ @"topSpace" : @( NSMaxY( self.frame ) - NSMaxY( avatar.frame ) )
//                                                  , @"avatarHeight" : @( NSHeight( avatar.frame ) )
//                                                  , @"space_avatarBottom_superView" : @( NSMinY( avatar.frame ) - NSMinY( self.frame ) )
//                                                  }
//                                          views: viewsDict ];

                [ self->_showingExpandButtonConstraints addObjectsFromArray: horizontalLayoutConstraints0 ];
                [ self->_showingExpandButtonConstraints addObjectsFromArray: horizontalLayoutConstraints1 ];
                [ self->_showingExpandButtonConstraints addObjectsFromArray: verticalLayoutConstraints0 ];
                }

            [ self addConstraints: self->_showingExpandButtonConstraints ];
            }
        }
    else
        {
        if ( expandButton.superview == self )
            {
            [ expandButton setDMSession: nil ];
            [ expandButton removeFromSuperview ];
            }
        }
    }

@end // TWPDirectMessagePreviewCellView class

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