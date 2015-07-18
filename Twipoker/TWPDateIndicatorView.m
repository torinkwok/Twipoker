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

#import "TWPDateIndicatorView.h"

NSDictionary static* sDefaultTextAttributes;

// Private Interfaces
@interface TWPDateIndicatorView ()
- ( void ) _updateTime;
@end // Private Interfaces

// TWPDateIndicatorView class
@implementation TWPDateIndicatorView

@dynamic tweet;

#pragma mark Initializations
+ ( void ) initialize
    {
    sDefaultTextAttributes = @{ NSFontAttributeName : [ NSFont fontWithName: @"Lato" size: 12.f ]
                              , NSForegroundColorAttributeName : [ NSColor colorWithHTMLColor: @"9B9B9B" ]
                              };
    }

#pragma mark Dynamic Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;
    [ self setNeedsDisplay: YES ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    [ self _updateTime ];
    }

- ( void ) updateTime
    {
    [ self setNeedsDisplay: YES ];
    }

#pragma mark Private Interfaces
- ( void ) _updateTime
    {
    NSDateComponentsFormatter* dateComponentsFormatter = [ [ NSDateComponentsFormatter alloc ] init ];
    [ dateComponentsFormatter setUnitsStyle: NSDateComponentsFormatterUnitsStyleAbbreviated ];

    NSDate* postDate = [ self->_tweet dateCreated ];
    NSTimeInterval secInterval = [ [ NSDate date ] timeIntervalSinceDate: postDate ];
    CGFloat minInterval = secInterval / 60;
    CGFloat hrsInterval = minInterval / 60;
    CGFloat dayInterval = hrsInterval / 24;

    NSString* formattedDateString = nil;
    NSCalendarUnit allowedUnits = 0;
    BOOL isOverYearInterval = NO;

    if ( secInterval < 60 )             allowedUnits = NSCalendarUnitSecond;
        else if ( minInterval < 60 )    allowedUnits = NSCalendarUnitMinute;
        else if ( hrsInterval < 24 )    allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute;
        else if ( dayInterval < 7 )     allowedUnits = NSCalendarUnitDay;
    else                                isOverYearInterval = YES;

    if ( !isOverYearInterval )
        {
        [ dateComponentsFormatter setAllowedUnits: allowedUnits ];
        formattedDateString = [ dateComponentsFormatter stringFromTimeInterval: secInterval ];
        }
    else
        {
        NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
        [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
        formattedDateString = [ [ dateFormatter stringFromDate: postDate ] mutableCopy ];

        NSCalendar* currentCalendar = [ NSCalendar currentCalendar ];
        NSDateComponents* components = nil;

        components = [ currentCalendar components: NSCalendarUnitYear fromDate: postDate ];
        NSInteger postYear = components.year;

        components = [ currentCalendar components: NSCalendarUnitYear fromDate: [ NSDate date ] ];
        NSInteger thisYear = components.year;

        if ( postYear == thisYear )
            // Jul 15, 2015, delete ", 2015"
            [ ( NSMutableString* )formattedDateString deleteCharactersInRange: NSMakeRange( formattedDateString.length - 6, 6 ) ];
        }

    NSSize stringSizeWithAttributes = [ formattedDateString sizeWithAttributes: sDefaultTextAttributes ];
    [ formattedDateString drawAtPoint: NSMakePoint( 0.f + 4.f , ( NSHeight( self.frame ) - stringSizeWithAttributes.height ) / 2 + 1.5f /* magic constant*/ )
                   withAttributes: sDefaultTextAttributes ];
    }

@end // TWPDateIndicatorView class

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