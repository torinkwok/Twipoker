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

#import "TWPTimelineViewController.h"
#import "TWPTweetCellView.h"
#import "TWPTweetOperationsNotificationNames.h"
#import "TWPTextView.h"

@implementation TWPTimelineViewController

@synthesize isLoadingOlderTweets = _isLoadingOlderTweets;
@synthesize numberOfTweetsWillBeLoadedOnce = _numberOfTweetsWillBeLoadedOnce;

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil
                            bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        {
        self->_isLoadingOlderTweets = NO;
        self->_numberOfTweetsWillBeLoadedOnce = 20;

        SEL delegateSel = @selector( tweetOperationShouldBeUnretweeted: );
        if ( [ self respondsToSelector: delegateSel ] )
            [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                        selector: delegateSel
                                                            name: TWPTweetOperationShouldBeUnretweeted
                                                          object: nil ];
        }

    return self;
    }

#pragma mark Conforms to <TWPTimelineTableViewDelegate>
- ( NSView* ) tableView: ( NSTableView* )_TableView
     viewForTableColumn: ( NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    TWPTweetCellView* tweetCellView =
        ( TWPTweetCellView* )[ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    OTCTweet* tweet = ( OTCTweet* )( self->_data[ _Row ] );
    tweetCellView.tweet = tweet;

    return tweetCellView;
    }

- ( CGFloat ) tableView: ( nonnull NSTableView* )_TableView
            heightOfRow: ( NSInteger )_Row
    {
    TWPTweetCellView* tweetCellView = ( TWPTweetCellView* )[ self tableView: _TableView viewForTableColumn: _TableView.tableColumns.firstObject row: _Row ];

    NSTextStorage* textStorage = [ [ NSTextStorage alloc ] initWithAttributedString: tweetCellView.tweetTextView.tweetTextStorage ];
    NSSize size = NSMakeSize( _TableView.tableColumns.firstObject.width - 105 - 20, FLT_MAX );

    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: size ];
    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];

    [ layoutManager addTextContainer: textContainer ];
    [ textStorage addLayoutManager: layoutManager ];

    ( void )[ layoutManager glyphRangeForTextContainer: textContainer ];
    CGFloat height = [ tweetCellView fetchFuckingHeight: [ layoutManager usedRectForTextContainer: textContainer ].size.height ];

    return ( height > 100 ) ? height : 100;
    }

//- ( CGFloat ) _calculateTweetHeight: ( CGFloat )_WidthValue
//                          tableView: ( nonnull NSTableView* )_TableView
//                                row: ( NSUInteger )_Row
//    {
//    }

- ( void ) tableViewColumnDidResize: ( nonnull NSNotification* )_Notif
    {
    NSMutableIndexSet* indexesChanged = [ NSMutableIndexSet indexSet ];
    NSTableView* tableView = [ _Notif.userInfo[ @"NSTableColumn" ] tableView ];
    CGFloat oldWidth = [ _Notif.userInfo[ @"NSOldWidth" ] doubleValue ];

    for ( int _Index = 0; _Index < self->_data.count; _Index++ )
        {
        TWPTweetCellView* tweetCellView = ( TWPTweetCellView* )[ self tableView: tableView viewForTableColumn: tableView.tableColumns.firstObject row: _Index ];

        NSTextStorage* textStorage = [ [ NSTextStorage alloc ] initWithAttributedString: tweetCellView.tweetTextView.tweetTextStorage ];
        NSSize oldSize = NSMakeSize( oldWidth - 105 - 20, FLT_MAX );
        NSSize newSize = NSMakeSize( tableView.tableColumns.firstObject.width - 105 - 20, FLT_MAX );

        ////
        NSTextContainer* newTextContainer = [ [ NSTextContainer alloc ] initWithContainerSize: newSize ];
        NSLayoutManager* newLayoutManager = [ [ NSLayoutManager alloc ] init ];

        [ newLayoutManager addTextContainer: newTextContainer ];
        [ textStorage addLayoutManager: newLayoutManager ];

        ( void )[ newLayoutManager glyphRangeForTextContainer: newTextContainer ];
        CGFloat newHeight = [ tweetCellView fetchFuckingHeight: [ newLayoutManager usedRectForTextContainer: newTextContainer ].size.height ];

        newHeight = ( newHeight > 100 ) ? newHeight : 100;

        ////
        NSTextContainer* oldTextContainer = [ [ NSTextContainer alloc ] initWithContainerSize: oldSize ];
        NSLayoutManager* oldLayoutManager = [ [ NSLayoutManager alloc ] init ];

        [ oldLayoutManager addTextContainer: oldTextContainer ];
        [ textStorage addLayoutManager: oldLayoutManager ];

        ( void )[ oldLayoutManager glyphRangeForTextContainer: oldTextContainer ];
        CGFloat oldHeight = [ tweetCellView fetchFuckingHeight: [ oldLayoutManager usedRectForTextContainer: oldTextContainer ].size.height ];

        oldHeight = ( oldHeight > 100 ) ? oldHeight : 100;

        if ( newHeight != oldHeight )
            [ indexesChanged addIndex: _Index ];
        }

//    [ self.timelineTableView enumerateAvailableRowViewsUsingBlock:
//        ^( NSTableRowView* _RowView, NSInteger _Row )
//            {
//            [ indexesChanged addIndex: _Row ];
//            } ];

//    NSMutableIndexSet* indexesChanged = [ NSMutableIndexSet indexSetWithIndexesInRange: NSMakeRange( 0, self->_data.count ) ];
//    NSLog( @"Indexes Changed: %@\n\n\n\n", indexesChanged );
    [ ( ( NSTableColumn* )_Notif.userInfo[ @"NSTableColumn" ] ).tableView noteHeightOfRowsWithIndexesChanged: indexesChanged ];
    }

- ( NSUInteger ) _countOfAvailableRowViews
    {
    NSUInteger __block count = 0;
    [ self.timelineTableView enumerateAvailableRowViewsUsingBlock:
        ^( NSTableRowView* _RowView, NSInteger _Row )
            {
            count++;
            } ];

    return count;
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