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

    void (^handleImageData)( NSData*, NSURLResponse*, NSError* ) =
        ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
            {
            NSImage* image = [ [ NSImage alloc ] initWithData: _ImageData ];
            [ self->_images addObject: image ];
            [ self performSelectorOnMainThread: @selector( setNeedsDisplay: ) withObject: @YES waitUntilDone: NO ];
            };

    for ( int _Index = 0; _Index < self->_tweet.media.count; _Index++ )
        {
        OTCMedia* tweetMedia = self->_tweet.media[ _Index ];
        NSURL* mediaURLOverSSL = tweetMedia.mediaURLOverSSL;

        NSURLRequest* mediaRequest = [ NSURLRequest requestWithURL: mediaURLOverSSL ];
        NSCachedURLResponse* cachedRequest = [ [ NSURLCache sharedURLCache ] cachedResponseForRequest: mediaRequest ];

        if ( cachedRequest )
            handleImageData( cachedRequest.data, cachedRequest.response, nil );
        else
            {
            NSURLSessionTask* dataTask = [ self->_URLSession dataTaskWithURL: mediaURLOverSSL
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

            [ dataTask resume ];

            switch ( _Index )
                {
                case 0: dataTask = self->_imageDataTask0 = dataTask; break;
                case 1: dataTask = self->_imageDataTask1 = dataTask; break;
                case 2: dataTask = self->_imageDataTask2 = dataTask; break;
                case 3: dataTask = self->_imageDataTask3 = dataTask; break;
                }
            }
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

    CGFloat corner = 20.f;
    NSBezierPath* roundedRectOulinePath =
        [ NSBezierPath bezierPathWithRoundedRect: _DirtyRect
                       withRadiusOfTopLeftCorner: corner bottomLeftCorner: corner topRightCorner: corner bottomRightCorner: corner
                                       isFlipped: NO ];
    [ [ NSColor whiteColor ] set ];
    [ roundedRectOulinePath stroke ];
    [ roundedRectOulinePath fill ];
    [ roundedRectOulinePath addClip ];

    for ( int _ImageIndex = 0; _ImageIndex < self->_images.count; _ImageIndex++ )
        {
        NSImage* image = self->_images[ _ImageIndex ];

        BOOL fittedHeight = NO;
        NSSize fitSize = [ self _fitSizeOfImageAtIndex: _ImageIndex basedOnNumOfImages: self->_tweet.media.count fittedHeight: &fittedHeight ];
        [ image setSize: fitSize ];

        NSRect dstRect = [ self _destRectInWhichToDrawImageAtIndex: _ImageIndex basedOnNumOfImages: self->_tweet.media.count ];
        [ image drawInRect: dstRect
                  fromRect: fittedHeight ? NSMakeRect( ( fitSize.width - NSWidth( dstRect ) ) / 2, 0, NSWidth( dstRect ), NSHeight( dstRect ) )
                                           : NSMakeRect( 0, ( fitSize.height - NSHeight( dstRect ) ) / 2, NSWidth( dstRect ), NSHeight( dstRect ) )
                 operation: NSCompositeSourceOver
                  fraction: 1.f ];
        }
    }

- ( NSSize ) _fitSizeOfImageAtIndex: ( NSUInteger )_ImageIndex
                 basedOnNumOfImages: ( NSUInteger )_NumOfImages
                       fittedHeight: ( BOOL* )_FittedHeight
    {
    BOOL fittedHeight = NO;
    NSRect dstRect = [ self _destRectInWhichToDrawImageAtIndex: _ImageIndex basedOnNumOfImages: _NumOfImages ];

    NSSize originalImageSize = [ self->_images[ _ImageIndex ] size ];
    NSSize fitImageSize = NSMakeSize( NSWidth( dstRect ), ( NSWidth( dstRect ) / originalImageSize.width ) * originalImageSize.height );

    if ( fitImageSize.height < [ self _fitHeightOfImageAtIndex: _ImageIndex basedOnNumOfImages: self->_images.count ] )
        {
        fitImageSize.height = [ self _fitHeightOfImageAtIndex: _ImageIndex basedOnNumOfImages: self->_images.count ];
        fitImageSize.width = ( fitImageSize.height / originalImageSize.height ) * originalImageSize.width;

        fittedHeight = YES;
        }

    *_FittedHeight = fittedHeight;
    return fitImageSize;
    }

// Calculate the source rectangle specifying the portion of the image you want to draw.
// The coordinates of this rectangle must be specified using the image's own coordinate system.
// If this method returns NSZeroRect, the entire image is drawn.
- ( NSRect ) _srcRectOfPortionOfImageAtIndex: ( NSUInteger )_ImageIndex
                          basedOnNumOfImages: ( NSUInteger )_NumOfImages
                                imageFitSize: ( NSSize )_FitSize
                                fittedHeight: ( BOOL )_FittedHeight
    {
//    NSParameterAssert( _ImageIndex < _NumOfImages );

    NSRect srcRect = NSZeroRect;
    NSRect dstRect = [ self _destRectInWhichToDrawImageAtIndex: _ImageIndex basedOnNumOfImages: _NumOfImages ];

    switch ( _ImageIndex )
        {
        case 0:
            {
            if ( _NumOfImages == 1 )
                {
                srcRect = _FittedHeight ? NSMakeRect( ( _FitSize.width - NSWidth( dstRect ) ) / 2, 0, NSWidth( self.bounds ), NSHeight( self.bounds ) )
                                           : NSMakeRect( 0, ( _FitSize.height - NSHeight( self.bounds ) ) / 2, NSWidth( self.bounds ), NSHeight( self.bounds ) );
                }
            else if ( _NumOfImages == 2 || _NumOfImages == 3 )
                {
                srcRect = _FittedHeight ? NSMakeRect( ( _FitSize.width - NSWidth( dstRect ) ) / 2, 0, NSWidth( dstRect ), NSHeight( dstRect ) )
                                           : NSMakeRect( 0, ( _FitSize.height - NSHeight( dstRect ) ) / 2, NSWidth( dstRect ), NSHeight( dstRect ) );
                }
            else if ( _NumOfImages == 4 )
                {
                srcRect = _FittedHeight ? NSMakeRect( ( _FitSize.width - NSWidth( dstRect ) ) / 2, 0, NSWidth( dstRect ), NSHeight( dstRect ) )
                                           : NSMakeRect( 0, ( _FitSize.height - NSHeight( dstRect ) ) / 2, NSWidth( dstRect ), NSHeight( dstRect ) );
                }
            } break;

        case 1:
            {
            // TODO:
            } break;

        case 2:
            {
            // TODO:
            } break;

        case 3:
            {
            // TODO:
            } break;
        }

    return srcRect;
    }

// Calculate the rectangle in which to draw the image, specified in the current coordinate system.
- ( NSRect ) _destRectInWhichToDrawImageAtIndex: ( NSUInteger )_ImageIndex
                             basedOnNumOfImages: ( NSUInteger )_NumOfImages
    {
//    NSParameterAssert( _ImageIndex < _NumOfImages );

    NSRect dstRect = self.bounds;

    switch ( _ImageIndex )
        {
        case 0:
            {
            if ( _NumOfImages == 1 )
                {
                ;
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

- ( CGFloat ) _fitWidthOfImageAtIndex: ( NSUInteger )_ImageIndex
                   basedOnNumOfImages: ( NSUInteger )_NumOfImages
    {
//    NSParameterAssert( _ImageIndex < _NumOfImages );

    CGFloat fitWidth = NSWidth( self.bounds );

    if ( _NumOfImages > 1 )
        fitWidth = ( fitWidth - Hor_Gap ) / 2.f;

    return fitWidth;
    }

- ( CGFloat ) _fitHeightOfImageAtIndex: ( NSUInteger )_ImageIndex
                    basedOnNumOfImages: ( NSUInteger )_NumOfImages
    {
//    NSParameterAssert( _ImageIndex < _NumOfImages );

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