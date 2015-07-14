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
#import "TWPUserAvatarCell.h"

// TWPUserAvatarWell class
@implementation TWPUserAvatarWell

@dynamic twitterUser;

#pragma mark Initializations
- ( instancetype ) initWithCoder:(NSCoder *)coder
    {
    if ( self = [ super initWithCoder: coder ] )
        self->_URLSession = [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];

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
    }

#pragma mark Accessors
- ( void ) setTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    [ self.cell setHighlighted: NO ];

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

    [ self.cell setHighlighted: NO ];
    [ NSApp sendAction: self.action to: self.target from: self ];
    }

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    [ super mouseEntered: _Event ];

    NSPoint eventLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];

    NSBezierPath* boundsPath = [ self.cell avatarOutlinePath ];
    if ( [ boundsPath containsPoint: eventLocation ] )
        [ self.cell setHighlighted: YES ];
    }

- ( void ) mouseExited: ( NSEvent* )_Event
    {
    [ super mouseExited: _Event ];

    if ( [ self.cell isHighlighted ] )
        [ self.cell setHighlighted: NO ];
    }

- ( void ) scrollWheel: ( NSEvent* )_Event
    {
    [ super scrollWheel: _Event ];
    [ self.cell setHighlighted: NO ];
    }

- ( void ) mouseMoved: ( nonnull NSEvent* )_Event
    {
    [ super mouseMoved: _Event ];
    NSPoint eventLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];

    NSBezierPath* boundsPath = [ self.cell avatarOutlinePath ];
    if ( [ boundsPath containsPoint: eventLocation ] )
        [ self.cell setHighlighted: YES ];
    else
        [ self.cell setHighlighted: NO ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    // TODO: Custom Drawing
    }

- ( Class ) cellClass
    {
    return [ TWPUserAvatarCell class ];
    }

@end // TWPUserAvatarWell class

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