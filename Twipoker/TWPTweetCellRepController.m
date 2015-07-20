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

#import "TWPTweetCellRepController.h"

@interface TWPTweetCellRepController ()
- ( void ) _postNotifForShowingUserProfile;
@end

@implementation TWPTweetCellRepController

@dynamic tweet;
@dynamic rep;

#pragma mark Dynamic Accessors
- ( OTCTweet* ) tweet
    {
    return [ self rep ].tweet;
    }

- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    [ [ self rep ] setTweet: _Tweet ];
    }

- ( OTCTwitterUser* ) author
    {
    return self.tweet.author;
    }

- ( TWPTweetCellRep* ) rep
    {
    return ( TWPTweetCellRep* )( self.view );
    }

#pragma mark Initializations
+ ( instancetype ) repControllerWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( self = [ super initWithNibName: @"TWPTweetClearCellRep" bundle: [ NSBundle mainBundle ] ] )
        ;

    return self;
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