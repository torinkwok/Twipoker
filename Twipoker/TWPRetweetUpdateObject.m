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

#import "TWPRetweetUpdateObject.h"
#import "NSString+Twipoker.h"

@implementation TWPRetweetUpdateObject

@synthesize retweetType = _retweetType;

@synthesize tweetToBeRetweeted;
@dynamic comment;

#pragma mark Initialzations
+ ( instancetype ) retweetUpdateWithTweet: ( OTCTweet* )_ToBeRetweeted
                                  comment: ( NSString* )_Comment
    {
    return [ [ self alloc ] initWithTweet: _ToBeRetweeted comment: _Comment ];
    }

+ ( instancetype ) retweetUpdateWithTweet: ( OTCTweet* )_ToBeRetweeted
    {
    return [ [ self alloc ] initWithTweet: _ToBeRetweeted comment: nil ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_ToBeRetweeted
                         comment: ( NSString* )_Comment
    {
    if ( !_ToBeRetweeted )
        return nil;

    if ( self = [ super init ] )
        {
        self.tweetToBeRetweeted = _ToBeRetweeted;
        self.comment = _Comment;
        }

    return self;
    }

#pragma mark Accessors
- ( void ) setComment: ( NSString* )_NewComment
    {
    self->_comment = _NewComment;
    self->_retweetType = [ self->_comment hasAtLeastOneNonChar: @" " ] ? TWPRetweetTypeOfficialQuote : TWPRetweetTypeNormal;
    }

- ( NSString* ) comment
    {
    return self->_comment;
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