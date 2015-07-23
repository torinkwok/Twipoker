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
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "NSControl+TwipokerDrawing.h"
#import "NSActionCell+TwipokerDrawing.h"

@implementation NSControl ( TwipokerDrawing )

@dynamic radiusOfTopLeftCorner;
@dynamic radiusOfBottomLeftCorner;
@dynamic radiusOfTopRightCorner;
@dynamic radiusOfBottomRightCorner;

#pragma mark Accessors
// Top Left
- ( void ) setRadiusOfTopLeftCorner: ( CGFloat )_RadiusValue
    {
    ( ( NSActionCell* )( self.cell ) ).radiusOfTopLeftCorner = _RadiusValue;
    }

- ( CGFloat ) radiusOfTopLeftCorner
    {
    return ( ( NSActionCell* )( self.cell ) ).radiusOfTopLeftCorner;
    }

// Bottom Left
- ( void ) setRadiusOfBottomLeftCorner: ( CGFloat )_RadiusValue
    {
    ( ( NSActionCell* )( self.cell ) ).radiusOfBottomLeftCorner = _RadiusValue;
    }

- ( CGFloat ) radiusOfBottomLeftCorner
    {
    return ( ( NSActionCell* )( self.cell ) ).radiusOfBottomLeftCorner;
    }

// Top Right
- ( void ) setRadiusOfTopRightCorner: ( CGFloat )_RadiusValue
    {
    ( ( NSActionCell* )( self.cell ) ).radiusOfTopRightCorner = _RadiusValue;
    }

- ( CGFloat ) radiusOfTopRightCorner
    {
    return ( ( NSActionCell* )( self.cell ) ).radiusOfTopRightCorner;
    }

// Bottom Right
- ( void ) setRadiusOfBottomRightCorner: ( CGFloat )_RadiusValue
    {
    ( ( NSActionCell* )( self.cell ) ).radiusOfBottomRightCorner = _RadiusValue;
    }

- ( CGFloat ) radiusOfBottomRightCorner
    {
    return ( ( NSActionCell* )( self.cell ) ).radiusOfBottomRightCorner;
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