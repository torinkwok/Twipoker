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

@import Foundation;

#define __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD_ \
    @throw [ NSException exceptionWithName: NSGenericException \
                         reason: [ NSString stringWithFormat: @"unimplemented pure virtual method `%@` in `%@` " \
                                                               "from instance: %p" \
                                                            , NSStringFromSelector( _cmd ) \
                                                            , NSStringFromClass( [ self class ] ) \
                                                            , self ] \
                       userInfo: nil ]


#define TWP_DEFAULT_RADIUS_CORNER 10.f

#define TWP_TWITTER_STARTING_COLOR [ NSColor colorWithSRGBRed: 145.f / 255 green: 199.f / 255 blue: 240.f / 255 alpha: 1.f ]
#define TWP_TWITTER_COLOR [ NSColor colorWithSRGBRed: 82.f / 255 green: 170.f / 255 blue: 238.f / 255 alpha: 1.f ]
#define TWP_PLACEHOLDER_COLOR [ NSColor colorWithSRGBRed: 125.f / 255 green: 125.f / 255 blue: 125.f / 255 alpha: 1.f ]

#define TWPPrintNSErrorForLog( _ErrorObject ) \
    if ( _ErrorObject ) \
        { \
        NSLog( @"Error Occured: (%s: LINE%d in %s):\n%@" \
             , __PRETTY_FUNCTION__ \
             , __LINE__ \
             , __FILE__ \
             , _ErrorObject \
             ); \
        }

NSString extern* const TwipokerAppID;

NSString extern* const TWPConsumerName;
NSString extern* const TWPConsumerKey;
NSString extern* const TWPConsumerSecret;

NSString extern* const TWPOAuthCallbackOutOfBand;

NSURL extern __strong* TWPUsersPermanentURL;

// Notification Names
NSString extern* const TWPTwipokerDidFinishLoginNotification;

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