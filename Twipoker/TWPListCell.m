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

#import "TWPListCell.h"
#import "TWPUserAvatarWell.h"
#import "TWPTimelineUserNameLabel.h"
#import "TWPTweetTextField.h"

@implementation TWPListCell

@synthesize creatorAvatar;
@synthesize listNameLabel;
@synthesize listDescriptionLabel;
@synthesize membersCountLabel;

@dynamic twitterList;

#pragma mark Initialization
+ ( instancetype ) listCellWithTwitterList: ( OTCList* )_TwitterList
    {
    return [ [ [ self class ] alloc ] initWithTwitterList: _TwitterList ];
    }

- ( instancetype ) initWithTwitterList: ( OTCList* )_TwitterList
    {
    if ( self = [ super init ] )
        [ self setTwitterList: _TwitterList ];

    return self;
    }

#pragma mark Accessors
- ( void ) setTwitterList: ( OTCList* )_TwitterList
    {
    if ( self->_twitterList != _TwitterList )
        {
        self->_twitterList = _TwitterList;

        [ [ self creatorAvatar ] setTwitterUser: self->_twitterList.creator ];
        [ [ self listNameLabel ] setStringValue: self->_twitterList.shortenName ];
        [ [ self listDescriptionLabel ] setStringValue: self->_twitterList.descriptionSetByCreator ];
        [ [ self membersCountLabel ] setStringValue: [ NSString stringWithFormat: @"%lu Members", self->_twitterList.memberCount ] ];
        }
    }

- ( OTCList* ) twitterList
    {
    return self->_twitterList;
    }

- ( OTCTwitterUser* ) creator
    {
    return self->_twitterList.creator;
    }

#pragma mark Events Handling
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ super mouseDown: _Event ];
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: @"fucking-notif"
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