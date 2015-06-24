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

#import "TWPTweetCellView.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameButton.h"
#import "TWPTweetTextField.h"
#import "TWPTweetOperationsPanelView.h"
#import "TWPActionNotifications.h"

// Notification Names
NSString* const TWPTweetCellViewShouldDisplayDetailOfTweet = @"TweetCellView.Notif.ShouldDisplayDetailOfTweet";

// User Info Keys
NSString* const TWPTweetCellViewTweetUserInfoKey = @"TweetCellView.UserInfoKey.Tweet";

// Private Interfaces
@interface TWPTweetCellView ()
- ( void ) _postNotifForShowingUserProfile;
@end // Private Interfaces

// TWPTweetCellView class
@implementation TWPTweetCellView

@synthesize authorAvatarWell;
@synthesize userNameLabel;
@synthesize tweetTextLabel;

@synthesize tweetOperationsPanel;

@dynamic tweet;
@dynamic author;

#pragma mark Initialization
+ ( instancetype ) tweetCellViewWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super init ] )
        [ self setTweet: _Tweet ];

    return self;
    }

- ( void ) awakeFromNib
    {
//    [ self removeConstraints: self.constraints ];
//
//    NSView* avatar = self.authorAvatarWell;
//    NSView* nameLabel = self.userNameLabel;
//    NSView* tweetText = self.tweetTextLabel;
//    NSView* operationsPanel = self.tweetOperationsPanel;
//
//    [ avatar setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ nameLabel setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ tweetText setTranslatesAutoresizingMaskIntoConstraints: NO ];
//    [ operationsPanel setTranslatesAutoresizingMaskIntoConstraints: NO ];
//
//    NSLog( @"%@", NSStringFromSize( nameLabel.frame.size ) );
//    NSLog( @"%@", NSStringFromSize( nameLabel.intrinsicContentSize ) );
//
//    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( avatar, nameLabel, tweetText, operationsPanel, self );
//    NSArray* horizontalConstraints0 = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|-(==space)"
//                                      "-[avatar(==avatarWidth)]"
//                                      "-(==paddingBetweenAvatarAndUserName)"
//                                      "-[nameLabel(==nameLabelWidth)]"
//                                      "-(>=paddingBetweenLabelAndOperationsPanel)"
//                                      "-[operationsPanel(==operationsPanelWidth)]"
//                                      "-(==space)-|"
//                            options: 0
//                            metrics: @{ @"space" : @( NSMinX( avatar.frame ) )
//                                      , @"avatarWidth" : @( NSWidth( avatar.frame ) )
//                                      , @"paddingBetweenAvatarAndUserName" : @( NSMinX( nameLabel.frame ) - NSMaxX( avatar.frame ) )
//                                      , @"paddingBetweenLabelAndOperationsPanel" : @( NSMinX( operationsPanel.frame ) - NSMaxX( nameLabel.frame ) )
//                                      , @"nameLabelWidth" : @( NSWidth( nameLabel.frame ) )
//                                      , @"operationsPanelWidth" : @( NSWidth( operationsPanel.frame ) )
//                                      }
//                              views: viewsDict ];
//
//    NSArray* horizontalConstraints1 = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"H:|-(==space)"
//                                      "-[avatar(==avatarWidth)]"
//                                      "-(==paddingBetweetAvatarAndTweet)"
//                                      "-[tweetText(>=tweetTextWidth)]"
//                                      "-(==space)-|"
//                            options: 0
//                            metrics: @{ @"space" : @( NSMinX( avatar.frame ) )
//                                      , @"avatarWidth" : @( NSWidth( avatar.frame ) )
//                                      , @"paddingBetweetAvatarAndTweet" : @( NSMinX( tweetText.frame ) - NSMaxX( avatar.frame ) )
//                                      , @"tweetTextWidth" : @( NSWidth( tweetText.frame ) )
//                                      }
//                              views: viewsDict ];
//
//    NSArray* verticalConstraints0 = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"V:|-(==topSpace)-[avatar(==avatarHeight)]-(>=bottomSpace)-|"
//                            options: 0
//                            metrics: @{ @"topSpace" : @( NSHeight( self.frame ) - NSMaxY( avatar.frame ) )
//                                      , @"avatarHeight" : @( NSHeight( avatar.frame ) )
//                                      , @"bottomSpace" : @( NSMinY( avatar.frame ) )
//                                      }
//                              views: viewsDict ];
//
//    NSArray* verticalConstraints1 = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"V:|-(==topSpace)-[nameLabel(==nameLabelHeight)]-(==paddingWithNameAndTweetText)-[tweetText(>=tweetTextHeight)]-(>=bottomSpace)-|"
//                            options: 0
//                            metrics: @{ @"topSpace" : @( NSHeight( self.frame ) - NSMaxY( avatar.frame ) )
//                                      , @"nameLabelHeight" : @( NSHeight( nameLabel.frame ) )
//                                      , @"tweetTextHeight" : @( NSHeight( tweetText.frame ) )
//                                      , @"bottomSpace" : @( NSMinY( avatar.frame ) )
//                                      , @"paddingWithNameAndTweetText" : @( NSMinY( nameLabel.frame ) - NSMaxY( tweetText.frame ) )
//                                      }
//                              views: viewsDict ];
//
//    NSArray* verticalConstraints2 = [ NSLayoutConstraint
//        constraintsWithVisualFormat: @"V:|-(==topSpace)-[operationsPanel(==operationsPanelHeight)]-(==paddingWithNameAndTweetText)-[tweetText(>=tweetTextHeight)]-(>=bottomSpace)-|"
//                            options: 0
//                            metrics: @{ @"topSpace" : @( NSHeight( self.frame ) - NSMaxY( avatar.frame ) )
//                                      , @"operationsPanelHeight" : @( NSHeight( operationsPanel.frame ) )
//                                      , @"tweetTextHeight" : @( NSHeight( tweetText.frame ) )
//                                      , @"bottomSpace" : @( NSMinY( avatar.frame ) )
//                                      , @"paddingWithNameAndTweetText" : @( NSMinY( nameLabel.frame ) - NSMaxY( tweetText.frame ) )
//                                      }
//                              views: viewsDict ];
//
//    [ self addConstraints: horizontalConstraints0 ];
//    [ self addConstraints: horizontalConstraints1 ];
//    [ self addConstraints: verticalConstraints0 ];
//    [ self addConstraints: verticalConstraints1 ];
//    [ self addConstraints: verticalConstraints2 ];
//
//    [ self.window visualizeConstraints: self.constraints ];
    }

#pragma mark Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;

    [ [ self authorAvatarWell ] setTwitterUser: self->_tweet.author ];
    [ [ self userNameLabel ] setTwitterUser: self->_tweet.author ];
    [ [ self tweetTextLabel ] setTweet: self->_tweet ];

    [ [ self tweetOperationsPanel ] setTweet: self->_tweet ];

    [ self setNeedsDisplay: YES ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

- ( OTCTwitterUser* ) author
    {
    return self.tweet.author;
    }

#pragma mark Events Handling
- ( NSView* ) hitTest: ( NSPoint )_Point
    {
    NSPoint location = [ self convertPoint: _Point fromView: self.superview ];
    NSArray* subviews = [ self subviews ];

    NSView* hitTestView = nil;
    for ( NSView* subview in subviews )
        {
        NSRect subviewFrame = subview.frame;
        if ( [ self mouse: location inRect: subviewFrame ] )
            hitTestView = [ subview hitTest: location ];
        }

    return hitTestView;
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
                                                         userInfo: @{ kTwitterUser : self.author } ];
    }

@end // TWPTweetCellView class

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