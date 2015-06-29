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

#import <Cocoa/Cocoa.h>

@class TWPUserAvatarWell;
@class TWPCuttingLineView;
@class TWPUserProfileCountButton;

@interface TWPTwitterUserProfileView : NSView
    {
@private
    OTCTwitterUser __strong* _twitterUser;
    }

@property ( weak ) IBOutlet NSButton* hideButton;
@property ( weak ) IBOutlet TWPCuttingLineView* cuttingLineView;

@property ( weak ) IBOutlet TWPUserAvatarWell* userAvatar;
@property ( weak ) IBOutlet NSTextField* userDisplayNameField;
@property ( weak ) IBOutlet NSTextField* userScreenNameField;
@property ( weak ) IBOutlet NSTextField* bioField;
@property ( weak ) IBOutlet NSTextField* locationField;
@property ( weak ) IBOutlet NSTextField* websiteField;

@property ( weak ) IBOutlet TWPUserProfileCountButton* tweetsCountButton;
@property ( weak ) IBOutlet TWPUserProfileCountButton* followersCountButton;
@property ( weak ) IBOutlet TWPUserProfileCountButton* followingCountButton;

@property ( weak ) IBOutlet NSButton* tweetToUserButton;
@property ( weak ) IBOutlet NSButton* sendADirectMessageButton;
@property ( weak ) IBOutlet NSButton* addOrRemoveFromListsButton;

@property ( weak ) IBOutlet NSButton* iDoNotLikeThisGuyButton;

@property ( strong, readwrite ) OTCTwitterUser* twitterUser;

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