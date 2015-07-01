
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

#import "TWPFavSwitcher.h"

NSString static* const kImageNameUnfaved = @"twitter-fav-button-normal";
NSString static* const kImageNameFaved = @"twitter-fav-button-highlighting";

@implementation TWPFavSwitcher

@dynamic tweet;
@dynamic isSelected;

- ( void ) awakeFromNib
    {
    self.imagePosition = NSImageOverlaps;
    self.bordered = NO;

    self->_unfavedImage = [ NSImage imageNamed: kImageNameUnfaved ];
    self->_favedImage = [ NSImage imageNamed: kImageNameFaved ];

    [ self->_unfavedImage setSize: NSMakeSize( 16.f, 14.f ) ];
    [ self->_favedImage setSize: NSMakeSize( 16.f, 14.f ) ];
    }

#pragma mark Accessors
- ( void ) setTweet: ( OTCTweet* )_Tweet
    {
    self->_tweet = _Tweet;

    [ self setImage: self->_tweet.isFavoritedByMe ? self->_favedImage : self->_unfavedImage ];
    }

- ( OTCTweet* ) tweet
    {
    return self->_tweet;
    }

- ( BOOL ) isSelected
    {
    return self->_tweet.isFavoritedByMe;
    }

#pragma mark Custom Drawings
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    
    // Drawing code here.
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