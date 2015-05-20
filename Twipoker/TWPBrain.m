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

#import "TWPBrain.h"
#import "TWPLoginUsersManager.h"

#import "_TWPMonitoringUserID.h"

// TWPBrain class
@implementation TWPBrain

#pragma mark Initializations
+ ( instancetype ) wiseBrain
    {
    return [ [ [ self class ] alloc ] init ];
    }

TWPBrain static __strong* sWiseBrain;
- ( instancetype ) init
    {
    if ( !sWiseBrain )
        {
        if ( self = [ super init ] )
            {
            // Home Timeline
            // Single-user stream, containing roughly all of the data corresponding with
            // the current authenticating user’s view of Twitter.
            self->_authingUserTimelineStream = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;
            self->_authingUserTimelineStream.delegate = self;

            [ self->_authingUserTimelineStream fetchUserStreamIncludeMessagesFromFollowedAccounts: @NO
                                                                                   includeReplies: @NO
                                                                                  keywordsToTrack: nil
                                                                            locationBoundingBoxes: nil ];
            // Global Timeline
            // Streams of the public data flowing through Twitter.
            self->_publicTimelineFilterStream = [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI;
            self->_publicTimelineFilterStream.delegate = self;
            [ self->_publicTimelineFilterStream fetchStatusesFilterKeyword: @"@NSTongG" users: nil locationBoundingBoxes: nil ];

            sWiseBrain = self;
            }
        }

    return sWiseBrain;
    }

#pragma mark Registration of Limbs
- ( void ) registerLimb: ( NSObject <TWPLimb>* )_NewLimb
              forUserID: ( NSString* )_UserID
            brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    // TODO;
    }

- ( void ) removeLimb: ( NSObject <TWPLimb>* )_NewLimb
            forUserID: ( NSString* )_UserID
          brainSignal: ( TWPBrainSignalTypeMask )_BrainSignals
    {
    // TODO:
    }

#pragma mark Conforms to <OTCSTTwitterStreamingAPIDelegate> protocol
- ( void ) twitterAPI: ( STTwitterAPI* )_TwitterAPI didReceiveTweet: ( OTCTweet* )_ReceivedTweet
    {
    // TODO:
    }

- ( void )   twitterAPI: ( STTwitterAPI* )_TwitterAPI
    tweetHasBeenDeleted: ( NSString* )_DeletedTweetID
                 byUser: ( NSString* )_UserID
                     on: ( NSDate* )_DeletionDate
    {
    // TODO:
    }

@end // TWPBrain class

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