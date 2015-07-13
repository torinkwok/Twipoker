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

@synthesize senderAvatar;
@synthesize senderUserNameLabel;
@synthesize mostRecentDateLabel;
@synthesize mostTweetPreview;

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
    [ mostRecentDateLabel setStringValue: mostRecentDM.dateCreated.description ];
    [ mostTweetPreview setStringValue: mostRecentDM.tweetText ];

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

    self->_alternateConstraints = [ NSMutableArray array ];
    NSLayoutConstraint* dmTextViewTrailingConstraint =
        [ NSLayoutConstraint constraintWithItem: self.mostTweetPreview
                                      attribute: NSLayoutAttributeTrailing
                                      relatedBy: NSLayoutRelationGreaterThanOrEqual
                                         toItem: self
                                      attribute: NSLayoutAttributeTrailing
                                     multiplier: 1.f
                                       constant: 20.f + NSWidth( [ TWPSharedUIElements sharedElements ].expandDMSessionButton.frame ) ];

    NSLayoutConstraint* senderUserNameTrailingConstraint =
        [ NSLayoutConstraint constraintWithItem: self.senderUserNameLabel
                                      attribute: NSLayoutAttributeTrailing
                                      relatedBy: NSLayoutRelationGreaterThanOrEqual
                                         toItem: self
                                      attribute: NSLayoutAttributeTrailing
                                     multiplier: 1.f
                                       constant: 20.f + NSWidth( [ TWPSharedUIElements sharedElements ].expandDMSessionButton.frame ) ];

    NSLayoutConstraint* dmPreviewTextViewWidthConstraint =
        [ NSLayoutConstraint constraintWithItem: self.mostTweetPreview
                                      attribute: NSLayoutAttributeWidth
                                      relatedBy: NSLayoutRelationGreaterThanOrEqual
                                         toItem: self
                                      attribute: NSLayoutAttributeWidth
                                     multiplier: 1.f
                                       constant: NSWidth( self.mostTweetPreview.frame ) ];

    TWPExpandDMSessionButton* expandButton = [ TWPSharedUIElements sharedElements ].expandDMSessionButton;
    NSLayoutConstraint* expandButtonWidthConstraints =
        [ NSLayoutConstraint constraintWithItem: expandButton
                                      attribute: NSLayoutAttributeWidth
                                      relatedBy: NSLayoutRelationEqual
                                         toItem: expandButton
                                      attribute: NSLayoutAttributeWidth
                                     multiplier: 1.f
                                       constant: NSWidth( expandButton.frame ) ];

    NSLayoutConstraint* expandButtonHeightConstraints =
        [ NSLayoutConstraint constraintWithItem: expandButton
                                      attribute: NSLayoutAttributeHeight
                                      relatedBy: NSLayoutRelationEqual
                                         toItem: expandButton
                                      attribute: NSLayoutAttributeHeight
                                     multiplier: 1.f
                                       constant: NSHeight( expandButton.frame ) ];

    [ self->_alternateConstraints addObjectsFromArray:
        @[ dmTextViewTrailingConstraint, senderUserNameTrailingConstraint, dmPreviewTextViewWidthConstraint
         , expandButtonWidthConstraints, expandButtonHeightConstraints
         ] ];

    for ( NSLayoutConstraint* _Constraint in self->_alternateConstraints )
        {
        [ self addConstraint: _Constraint ];
        [ _Constraint setActive: NO ];
        }
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

            [ self.dmTextViewTrailing_equal_cellViewTrailing_constraint setActive: NO ];
            [ self.dateFormatterTrailing_equal_cellViewTrailing_constraint setActive: NO ];
            [ self.dateFormatterLeading_greaterThanOrEqual_senderNameLabelTrailing_constraint setActive: NO ];
            [ self.dmPreviewTextViewWidth_greaterThanOrEqual_constraint setActive: NO ];

            for ( NSLayoutConstraint* _Constraint in self->_alternateConstraints )
                [ _Constraint setActive: YES ];
            }
        }
    else
        {
        if ( expandButton.superview == self )
            {
            [ expandButton setDMSession: nil ];
            [ expandButton removeFromSuperview ];

            [ self.dmTextViewTrailing_equal_cellViewTrailing_constraint setActive: YES ];
            [ self.dateFormatterTrailing_equal_cellViewTrailing_constraint setActive: YES ];
            [ self.dateFormatterLeading_greaterThanOrEqual_senderNameLabelTrailing_constraint setActive: YES ];
            [ self.dmPreviewTextViewWidth_greaterThanOrEqual_constraint setActive: YES ];

            for ( NSLayoutConstraint* _Constraint in self->_alternateConstraints )
                [ _Constraint setActive: NO ];
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