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

#define Hor_Gap 5.f
#define Ver_Gap 5.f

static inline CGFloat kHalfOfWidthTakeAccountOfGap( NSRect _Rect )
    {
    return ( NSWidth( _Rect ) - Hor_Gap ) / 2;
    }

static inline CGFloat kHalfOfHeightTakeAccountOfGap( NSRect _Rect )
    {
    return ( NSHeight( _Rect ) - Ver_Gap ) / 2;
    }

static inline CGFloat kMidXTakeAccountOfGap( NSRect _Rect )
    {
    return kHalfOfWidthTakeAccountOfGap( _Rect ) + Hor_Gap;
    }

static inline CGFloat kMidYTakeAccountOfGap( NSRect _Rect )
    {
    return kHalfOfHeightTakeAccountOfGap( _Rect ) + Ver_Gap;
    }

// _TWPTweetMediaData class
@interface _TWPTweetMediaData : NSObject

@property ( strong, readwrite ) NSURLSessionTask* mediaDataTask;
@property ( strong, readwrite ) NSImage* mediaData;

@property ( assign, readwrite ) NSSize size;

@end

@implementation _TWPTweetMediaData

@synthesize mediaDataTask;
@synthesize mediaData;

@dynamic size;

#pragma mark Dynamic Accessors
- ( NSSize ) size
    {
    return self.mediaData.size;
    }

- ( void ) setSize: ( NSSize )_Size

    {
    [ self.mediaData setSize: _Size ];
    }

@end // _TWPTweetMediaData class

// ============================================================================ //

// Private Interfaces
@interface TWPTweetMediaWell ()

@property ( strong, readonly ) NSArray* _tweetMediaData;

- ( NSSize ) _fitSizeOfImageAtIndex: ( NSUInteger )_ImageIndex
                 basedOnNumOfImages: ( NSUInteger )_NumOfImages
                       fittedHeight: ( BOOL* )_FittedHeight;

// Calculate the rectangle in which to draw the image, specified in the current coordinate system.
- ( NSRect ) _destRectInWhichToDrawImageAtIndex: ( NSUInteger )_ImageIndex
                             basedOnNumOfImages: ( NSUInteger )_NumOfImages;

@end // Private Interfaces

// TWPTweetMediaWell class
@implementation TWPTweetMediaWell
    {
@protected
    _TWPTweetMediaData __strong* _imageDataUpperLeft;
    _TWPTweetMediaData __strong* _imageDataUpperRight;
    _TWPTweetMediaData __strong* _imageDataBottomLeft;
    _TWPTweetMediaData __strong* _imageDataBottomRight;
    }

@dynamic tweet;
@dynamic media;

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

        self->_imageDataUpperLeft = [ [ _TWPTweetMediaData alloc ] init ];
        self->_imageDataUpperRight = [ [ _TWPTweetMediaData alloc ] init ];
        self->_imageDataBottomLeft = [ [ _TWPTweetMediaData alloc ] init ];
        self->_imageDataBottomRight = [ [ _TWPTweetMediaData alloc ] init ];
        }

    return self;
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;

    [ self setNeedsDisplay: YES ];

    void (^handleMediaData)( NSData*, NSURLResponse*, NSError* ) =
        ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
            {
            NSImage* image = [ [ NSImage alloc ] initWithData: _ImageData ];

            NSUInteger URLIndex = 0U;
            for ( int _Index = 0; _Index < self.media.count; _Index++ )
                if ( [ ( ( OTCMedia* )self.media[ _Index ] ).mediaURLOverSSL.absoluteString
                        isEqualToString: _Response.URL.absoluteString ] )
                    URLIndex = _Index;

            if ( URLIndex < self._tweetMediaData.count )
                [ self._tweetMediaData[ URLIndex ] setMediaData: image ];

            [ self performSelectorOnMainThread: @selector( setNeedsDisplay: ) withObject: @YES waitUntilDone: NO ];
            };

    for ( int _Index = 0; _Index < self.media.count; _Index++ )
        {
        OTCMedia* tweetMedia = self.media[ _Index ];
        NSURL* mediaURLOverSSL = tweetMedia.mediaURLOverSSL;

        NSURLRequest* mediaRequest = [ NSURLRequest requestWithURL: mediaURLOverSSL ];
        NSCachedURLResponse* cachedRequest = [ [ NSURLCache sharedURLCache ] cachedResponseForRequest: mediaRequest ];

        if ( cachedRequest )
            handleMediaData( cachedRequest.data, cachedRequest.response, nil );
        else
            {
            NSURLSessionTask* dataTask = [ self->_URLSession dataTaskWithURL: mediaURLOverSSL
                                                           completionHandler:
                ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
                    {
                    if ( _ImageData && _Response )
                        {
                        handleMediaData( _ImageData, _Response, _Error );

                        NSCachedURLResponse* cache =
                            [ [ NSCachedURLResponse alloc ] initWithResponse: _Response
                                                                        data: _ImageData
                                                                    userInfo: nil
                                                               storagePolicy: NSURLCacheStorageAllowed ];

                        [ [ NSURLCache sharedURLCache ] storeCachedResponse: cache forRequest: mediaRequest ];
                        }
                    } ];

            switch ( _Index )
                {
                case 0: dataTask = self->_imageDataUpperLeft.mediaDataTask = dataTask;   break;
                case 1: dataTask = self->_imageDataUpperRight.mediaDataTask = dataTask;  break;
                case 2: dataTask = self->_imageDataBottomLeft.mediaDataTask = dataTask;  break;
                case 3: dataTask = self->_imageDataBottomRight.mediaDataTask = dataTask; break;
                }

            [ dataTask resume ];
            }
        }
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

- ( NSArray* ) media
    {
    return self->_tweet.media;
    }

#pragma mark Custom Drawing
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

    for ( int _MediaDataIndex = 0; _MediaDataIndex < self._tweetMediaData.count; _MediaDataIndex++ )
        {
        _TWPTweetMediaData* mediaData = self._tweetMediaData[ _MediaDataIndex ];

        BOOL fittedHeight = NO;
        NSSize fitSize = [ self _fitSizeOfImageAtIndex: _MediaDataIndex basedOnNumOfImages: self.media.count fittedHeight: &fittedHeight ];
        [ mediaData setSize: fitSize ];

        NSRect dstRect = [ self _destRectInWhichToDrawImageAtIndex: _MediaDataIndex basedOnNumOfImages: self.media.count ];
        [ mediaData.mediaData drawInRect: dstRect
                                fromRect: fittedHeight ? NSMakeRect( ( fitSize.width - NSWidth( dstRect ) ) / 2, 0, NSWidth( dstRect ), NSHeight( dstRect ) )
                                                       : NSMakeRect( 0, ( fitSize.height - NSHeight( dstRect ) ) / 2, NSWidth( dstRect ), NSHeight( dstRect ) )
                               operation: NSCompositeSourceOver
                                fraction: 1.f ];
        }
    }

#pragma mark Private Interfaces
- ( NSArray* ) _tweetMediaData
    {
    // Init with "imageData0, imageData1, nil, imageData2, nil"
    // =>
    // @[ imageData0, imageData1 ]
    NSArray* tweetMediaData = [ NSArray arrayWithObjects: self->_imageDataUpperLeft
                                                        , self->_imageDataUpperRight
                                                        , self->_imageDataBottomLeft
                                                        , self->_imageDataBottomRight
                                                        , nil ];
    return tweetMediaData;
    }

- ( NSSize ) _fitSizeOfImageAtIndex: ( NSUInteger )_MediaDataIndex
                 basedOnNumOfImages: ( NSUInteger )_NumOfImages
                       fittedHeight: ( BOOL* )_FittedHeight
    {
    BOOL fittedHeight = NO;
    NSRect dstRect = [ self _destRectInWhichToDrawImageAtIndex: _MediaDataIndex basedOnNumOfImages: _NumOfImages ];

    NSSize originalImageSize = [ self._tweetMediaData[ _MediaDataIndex ] size ];
    NSSize fitImageSize = NSMakeSize( NSWidth( dstRect ), ( NSWidth( dstRect ) / originalImageSize.width ) * originalImageSize.height );

    if ( fitImageSize.height < NSHeight( dstRect ) )
        {
        fitImageSize.height = NSHeight( dstRect );
        fitImageSize.width = ( fitImageSize.height / originalImageSize.height ) * originalImageSize.width;

        fittedHeight = YES;
        }

    *_FittedHeight = fittedHeight;
    return fitImageSize;
    }

// Calculate the rectangle in which to draw the image, specified in the current coordinate system.
- ( NSRect ) _destRectInWhichToDrawImageAtIndex: ( NSUInteger )_ImageIndex
                             basedOnNumOfImages: ( NSUInteger )_NumOfImages
    {
    NSRect dstRect = self.bounds;

    switch ( _ImageIndex )
        {
        case 0:
            {
            if ( _NumOfImages == 1 )
                {
                ; // Do nothing
                }
            else if ( _NumOfImages == 2 || _NumOfImages == 3 )
                {
                dstRect = NSMakeRect( NSMinX( self.bounds )
                                    , NSMinY( self.bounds )
                                    , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                    , NSHeight( self.frame )
                                    );
                }
            else if ( _NumOfImages > 3 )
                {
                dstRect = NSMakeRect( NSMinX( self.bounds )
                                    , kMidYTakeAccountOfGap( self.bounds )
                                    , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                    , kHalfOfHeightTakeAccountOfGap( self.bounds )
                                    );
                }
            } break;


        case 1:
            {
            if ( _NumOfImages == 2 )
                {
                dstRect = NSMakeRect( kMidXTakeAccountOfGap( self.bounds )
                                    , NSMinY( self.frame )
                                    , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                    , NSHeight( self.frame )
                                    );
                }
            else if ( _NumOfImages > 2 )
                {
                dstRect = NSMakeRect( kMidXTakeAccountOfGap( self.bounds )
                                    , kMidYTakeAccountOfGap( self.bounds )
                                    , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                    , kHalfOfHeightTakeAccountOfGap( self.bounds )
                                    );
                }
            } break;

        case 2:
            {
            if ( _NumOfImages == 3 )
                {
                dstRect = NSMakeRect( kMidXTakeAccountOfGap( self.bounds )
                                    , NSMinY( self.bounds )
                                    , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                    , kHalfOfHeightTakeAccountOfGap( self.bounds )
                                    );
                }
            else if ( _NumOfImages > 3 )
                {
                dstRect = NSMakeRect( NSMinX( self.bounds )
                                    , NSMinY( self.bounds )
                                    , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                    , kHalfOfHeightTakeAccountOfGap( self.bounds )
                                    );
                }
            } break;

        case 3:
            {
            dstRect = NSMakeRect( kMidXTakeAccountOfGap( self.bounds )
                                , NSMinY( self.bounds )
                                , kHalfOfWidthTakeAccountOfGap( self.bounds )
                                , kHalfOfHeightTakeAccountOfGap( self.bounds )
                                );
            } break;
        }

    return dstRect;
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