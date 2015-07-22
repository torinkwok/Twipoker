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
        self->_maxNumOfImages = 4;
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
#define Hor_Gap 5.f
#define Ver_Gap 5.f
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    CGFloat corner = 20.f;
    NSBezierPath* roundedRectOulinePath =
        [ NSBezierPath bezierPathWithRoundedRect: _DirtyRect
                       withRadiusOfTopLeftCorner: corner bottomLeftCorner: corner topRightCorner: corner bottomRightCorner: corner
                                       isFlipped: NO ];
    [ [ NSColor whiteColor ] set ];
    [ roundedRectOulinePath stroke ];
    [ roundedRectOulinePath fill ];
    [ roundedRectOulinePath addClip ];

    if ( self->_images.count > 0 )
        {
        NSLog( @"Index 0: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 1 ] );
        NSLog( @"\n" );

        NSLog( @"Index 0 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 2 ] );
        NSLog( @"Index 1 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 2 ] );
        NSLog( @"\n" );

        NSLog( @"Index 0 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 3 ] );
        NSLog( @"Index 1 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 3 ] );
        NSLog( @"Index 2 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 3 ] );
        NSLog( @"\n" );

        NSLog( @"Index 0 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 4 ] );
        NSLog( @"Index 1 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 4 ] );
        NSLog( @"Index 2 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 4 ] );
        NSLog( @"Index 3 Image: %g", [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: 4 ] );
        NSLog( @"========" );

        NSImage* image = [ self->_images firstObject ];

        NSSize originalSize = [ image size ];
        NSSize fitSize = NSMakeSize( [ self _fitWidthOfImageAtIndex: 0 basedOnNumOfImages: self->_images.count ]
                                   , ( NSWidth( self.bounds ) / originalSize.width ) * originalSize.height );
        BOOL shouldFitHeight = NO;
        if ( fitSize.height < NSHeight( self.bounds ) )
            {
            fitSize.height = [ self _fitHeightOfImageAtIndex: 0 basedOnNumOfImages: self->_images.count ];
            fitSize.width = ( fitSize.height / originalSize.height ) * originalSize.width;
            shouldFitHeight = YES;
            }

        [ image setSize: fitSize ];
        [ image drawInRect: _DirtyRect
                  fromRect: shouldFitHeight ? NSMakeRect( ( fitSize.width - NSWidth( self.bounds ) ) / 2, 0, NSWidth( self.bounds ), NSHeight( self.bounds ) )
                                            : NSMakeRect( 0, ( fitSize.height - NSHeight( self.bounds ) ) / 2, NSWidth( self.bounds ), NSHeight( self.bounds ) )
                 operation: NSCompositeSourceOver
                  fraction: 1.f ];
        }
    }

- ( CGFloat ) _fitWidthOfImageAtIndex: ( NSUInteger )_ImageIndex
                   basedOnNumOfImages: ( NSUInteger )_NumOfImages
    {
    NSParameterAssert( _ImageIndex < _NumOfImages );

    CGFloat fitWidth = NSWidth( self.bounds );

    if ( _NumOfImages > 1 )
        fitWidth = ( fitWidth - Hor_Gap ) / 2.f;

//    if ( _NumOfImages <= self->_maxNumOfImages )
//        {
//        switch ( _ImageIndex )
//            {
//            case 0:
//                {
//                if ( _NumOfImages != 1 )
//                    fitWidth = ( NSWidth( self.bounds ) - Hor_Gap ) / 2.f;
//                } break;
//
//            default:
//                {
//                fitWidth = ( NSWidth( self.bounds ) - Hor_Gap ) / 2.f;
//                } break;
//            }
//        }

    return fitWidth;
    }

- ( CGFloat ) _fitHeightOfImageAtIndex: ( NSUInteger )_ImageIndex
                    basedOnNumOfImages: ( NSUInteger )_NumOfImages
    {
    NSParameterAssert( _ImageIndex < _NumOfImages );

    CGFloat fitHeight = NSHeight( self.bounds );
    if ( _NumOfImages <= self->_maxNumOfImages )
        {
        switch ( _ImageIndex )
            {
            case 0:
                {
                if ( _NumOfImages == self->_maxNumOfImages )
                    fitHeight = ( NSHeight( self.bounds ) - Ver_Gap ) / 2.f;
                } break;

            case 1:
                {
                if ( _NumOfImages >= 3 )
                    fitHeight = ( NSHeight( self.bounds ) - Ver_Gap ) / 2.f;
                } break;

            default:
                {
                fitHeight = ( NSHeight( self.bounds ) - Ver_Gap ) / 2.f;
                } break;
            }
        }

    return fitHeight;
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