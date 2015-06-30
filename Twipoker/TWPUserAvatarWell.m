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

#import "TWPUserAvatarWell.h"

@implementation TWPUserAvatarWell

@dynamic twitterUser;

- ( instancetype ) initWithCoder:(NSCoder *)coder
    {
    if ( self = [ super initWithCoder: coder ] )
        self->_URLSession = [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];

    return self;
    }

#pragma mark Accessors
- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    if ( self->_twitterUser != _TwitterUser )
        {
        [ self setImage: nil ];
        self->_twitterUser = _TwitterUser;

        NSURL* avatarURL = self->_twitterUser.originalAvatarImageURLOverSSL;

        NSURLRequest* avatarRequest = [ NSURLRequest requestWithURL: avatarURL ];
        NSCachedURLResponse* cachedRequest = [ [ NSURLCache sharedURLCache ] cachedResponseForRequest: avatarRequest ];

        void (^handleImageData)( NSData*, NSURLResponse*, NSError* ) =
            ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
                {
                NSImage* avatarImage = [ [ NSImage alloc ] initWithData: _ImageData ];
                [ self performSelectorOnMainThread: @selector( setImage: ) withObject: avatarImage waitUntilDone: NO ];
                };

        if ( cachedRequest )
            handleImageData( cachedRequest.data, cachedRequest.response, nil );
        else
            {
            self->_dataTask = [ self->_URLSession dataTaskWithURL: avatarURL
                                                completionHandler:
                ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
                    {
                    if ( _ImageData && _Response )
                        {
                        handleImageData( _ImageData, _Response, _Error );

                        NSCachedURLResponse* cache =
                            [ [ NSCachedURLResponse alloc ] initWithResponse: _Response
                                                                        data: _ImageData
                                                                    userInfo: nil
                                                               storagePolicy: NSURLCacheStorageAllowed ];

                        [ [ NSURLCache sharedURLCache ] storeCachedResponse: cache forRequest: avatarRequest ];
                        }
                    } ];

            [ self->_dataTask resume ];
            }
        }
    }

- ( OTCTwitterUser* ) twitterUser
    {
    return self->_twitterUser;
    }

#pragma mark Events Handling
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ super mouseDown: _Event ];
    [ NSApp sendAction: self.action to: self.target from: self ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    // TODO: Custom Drawing
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