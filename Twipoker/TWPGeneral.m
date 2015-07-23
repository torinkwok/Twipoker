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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TWPGeneral.h"
#import "Objectwitter-C.h"

NSString* const TwipokerAppID = @"home.bedroom.TongKuo.Twipoker";

NSString* const TWPConsumerName = @"Twipoker";
NSString* const TWPConsumerKey = @"4BIbHVLsffbHqrWK77fHtdFA7";
NSString* const TWPConsumerSecret = @"FZJav5ZrY8HsuW8l4Sx4N0yWuYy4IsG4l5H5sxiggG3a5vbUvl";

NSString* const TWPOAuthCallbackOutOfBand = @"oob";

NSURL __strong* TWPUsersPermanentURL;

__attribute__( ( constructor ) )
static void s_init()
    {
    NSURL* applicationSupportURL = [ [ [ NSFileManager defaultManager ] URLsForDirectory: NSApplicationSupportDirectory inDomains: NSUserDomainMask ] firstObject ];

    TWPUsersPermanentURL = [ applicationSupportURL URLByAppendingPathComponent: @"users.plist" ];
    }

// Notification Names
NSString* const TWPTwipokerDidFinishLoginNotification = @"home.bedroom.TongKuo.Twipoker.Notif.DidFinishLogin";

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