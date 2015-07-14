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

// TWPDateIndicatorView class
@implementation TWPDateIndicatorView

@dynamic tweet;

#pragma mark Initializations
+ ( void ) initialize
    {
    sDefaultTextAttributes = @{ NSFontAttributeName : [ NSFont fontWithName: @"Lato" size: 12.f ]
                              , NSForegroundColorAttributeName : [ NSColor colorWithHTMLColor: @"66757F" ]
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

    NSDateComponentsFormatter* dateComponentsFormatter = [ [ NSDateComponentsFormatter alloc ] init ];
    [ dateComponentsFormatter setUnitsStyle: NSDateComponentsFormatterUnitsStyleAbbreviated ];

    NSDate* postDate = [ self->_tweet dateCreated ];
    NSTimeInterval secInterval = [ [ NSDate date ] timeIntervalSinceDate: postDate ];
    CGFloat minInterval = secInterval / 60;
    CGFloat hrsInterval = minInterval / 60;
    CGFloat dayInterval = hrsInterval / 24;

    NSString* formattedString = nil;

    if ( secInterval < 59 )
        {
        [ dateComponentsFormatter setAllowedUnits: NSCalendarUnitSecond ];
        formattedString = [ dateComponentsFormatter stringFromTimeInterval: secInterval ];
        }
    else if ( minInterval < 59 )
        {
        [ dateComponentsFormatter setAllowedUnits: NSCalendarUnitMinute ];
        formattedString = [ dateComponentsFormatter stringFromTimeInterval: secInterval ];
        }
    else if ( hrsInterval < 23 )
        {
        [ dateComponentsFormatter setAllowedUnits: NSCalendarUnitHour | NSCalendarUnitMinute ];
        formattedString = [ dateComponentsFormatter stringFromTimeInterval: secInterval ];
        }
    else if ( dayInterval < 6 )
        {
        [ dateComponentsFormatter setAllowedUnits: NSCalendarUnitDay ];
        formattedString = [ dateComponentsFormatter stringFromTimeInterval: secInterval ];
        }
    else
        {
        NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
        [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
        formattedString = [ [ dateFormatter stringFromDate: postDate ] mutableCopy ];

        NSCalendar* currentCalendar = [ NSCalendar currentCalendar ];
        NSDateComponents* components = nil;

        components = [ currentCalendar components: NSCalendarUnitYear fromDate: postDate ];
        NSInteger postYear = components.year;

        components = [ currentCalendar components: NSCalendarUnitYear fromDate: [ NSDate date ] ];
        NSInteger thisYear = components.year;

        if ( postYear == thisYear )
            // Jul 15, 2015, delete ", 2015"
            [ ( NSMutableString* )formattedString deleteCharactersInRange: NSMakeRange( formattedString.length - 6, 6 ) ];
        }

    NSSize stringSizeWithAttributes = [ formattedString sizeWithAttributes: sDefaultTextAttributes ];
    [ formattedString drawAtPoint: NSMakePoint( NSWidth( self.frame ) - stringSizeWithAttributes.width, 0 )
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