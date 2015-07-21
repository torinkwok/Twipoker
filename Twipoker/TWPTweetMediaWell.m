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

#import "TWPTweetMediaWell.h"
#import "NSBezierPath+TwipokerDrawing.h"

// TWPTweetMediaWell class
@implementation TWPTweetMediaWell

@dynamic tweet;

#pragma mark Global Properties
+ ( NSSize ) defaultSize
    {
    return NSMakeSize( 272.f, 272.f * 0.61803398875f ); // Golden Ratio
    }

#pragma mark Initializations
+ ( instancetype ) tweetMediaWellWithTweet: ( OTCTweet* )_Tweet
    {
    return [ [ [ self class ] alloc ] initWithTweet: _Tweet ];
    }

- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet
    {
    if ( !_Tweet.media.count )
        return nil;

    NSSize defaultSize = [ [ self class ] defaultSize ];
    if ( self = [ super initWithFrame: NSMakeRect( 0, 0, defaultSize.width, defaultSize.height ) ] )
        {
        self->_tweet = _Tweet;
        [ self setNeedsDisplay: YES ];
        }

    return self;
    }

- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_URLSession = [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];
        self->_images = [ NSMutableArray array ];
        }

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    [ self->_images removeAllObjects ];
    [ self setNeedsDisplay: YES ];

    NSURL* mediaURLOverSSL = [ ( OTCMedia* )( self->_tweet.media.firstObject ) mediaURLOverSSL ];

    NSURLRequest* mediaRequest = [ NSURLRequest requestWithURL: mediaURLOverSSL ];
    NSCachedURLResponse* cachedRequest = [ [ NSURLCache sharedURLCache ] cachedResponseForRequest: mediaRequest ];

    void (^handleImageData)( NSData*, NSURLResponse*, NSError* ) =
        ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
            {
            NSImage* image = [ [ NSImage alloc ] initWithData: _ImageData ];
            [ self->_images addObject: image ];
            [ self performSelectorOnMainThread: @selector( setNeedsDisplay: ) withObject: @YES waitUntilDone: NO ];
            };

    if ( cachedRequest )
        handleImageData( cachedRequest.data, cachedRequest.response, nil );
    else
        {
        self->_dataTask = [ self->_URLSession dataTaskWithURL: mediaURLOverSSL
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

                    [ [ NSURLCache sharedURLCache ] storeCachedResponse: cache forRequest: mediaRequest ];
                    }
                } ];

        [ self->_dataTask resume ];
        }
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSBezierPath* roundedRectOulinePath =
        [ NSBezierPath bezierPathWithRoundedRect: _DirtyRect
                       withRadiusOfTopLeftCorner: 20.f
                                bottomLeftCorner: 20.f
                                  topRightCorner: 20.f
                               bottomRightCorner: 20.f
                                       isFlipped: NO ];
    [ [ NSColor whiteColor ] set ];
    [ roundedRectOulinePath stroke ];
    [ roundedRectOulinePath fill ];
    [ roundedRectOulinePath addClip ];

    if ( self->_images.count > 0 )
        {
        NSImage* image = [ self->_images firstObject ];
        NSSize currentSize = [ image size ];
        NSSize fitSize = NSZeroSize;

//        if ( NSHeight( self.bounds ) <= currentSize.height )
//            {
            fitSize = NSMakeSize( NSWidth( self.bounds ), ( NSWidth( self.bounds ) / currentSize.width ) * currentSize.height );
            [ image setSize: fitSize ];

            [ image drawInRect: _DirtyRect
                      fromRect: NSMakeRect( 0, ( fitSize.height - NSHeight( self.bounds ) ) / 2, NSWidth( self.bounds ), NSHeight( self.bounds ) )
                     operation: NSCompositeSourceOver
                      fraction: 1.f ];
//            }
//        else
//            {
//            fitSize = NSMakeSize( ( NSHeight( self.bounds ) / currentSize.height ) * currentSize.width, NSHeight( self.bounds ) );
//            [ image setSize: fitSize ];
//
//            [ image drawInRect: _DirtyRect
//                      fromRect: NSMakeRect( 0, 0, NSWidth( self.bounds ), NSHeight( self.bounds ) )
//                     operation: NSCompositeSourceOver
//                      fraction: 1.f ];
//            }
        }
    }

@end // TWPTweetMediaWell class

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