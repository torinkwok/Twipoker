//
//  NSString+Twipoker.m
//  Twipoker
//
//  Created by Tong G. on 6/14/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "NSString+Twipoker.h"

@implementation NSString ( Twipoker )

- ( BOOL ) hasAtLeastOneNonChar: ( NSString* )_SingleChar
    {
    if ( !_SingleChar )
        return NO;

    BOOL atLeastOneNonSpace = NO;
    NSString* testChar = ( _SingleChar.length > 1 ) ? [ _SingleChar substringToIndex: 1 ] : _SingleChar;

    for ( int _Index = 0; _Index < self.length; _Index++ )
        {
        NSString* subchar = [ self substringWithRange: NSMakeRange( _Index, 1 ) ];

        if ( ![ subchar isEqualToString: testChar ] )
            {
            atLeastOneNonSpace = YES;
            break;
            }
        }

    return atLeastOneNonSpace;
    }

@end
