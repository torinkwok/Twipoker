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
    CGFloat minimumHeight = NSHeight( tweetCellView.bounds );

    NSTextStorage* textStorage = [ [ NSTextStorage alloc ] initWithAttributedString: tweetCellView.tweetTextView.tweetTextStorage ];
    NSSize size = NSMakeSize( _TableView.tableColumns.firstObject.width - 105 - 20, FLT_MAX );

    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: size ];
    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];

    [ layoutManager addTextContainer: textContainer ];
    [ textStorage addLayoutManager: layoutManager ];

    // FIXME
    ( void )[ layoutManager glyphRangeForTextContainer: textContainer ];
    CGFloat height = [ tweetCellView fetchFuckingHeight: [ layoutManager usedRectForTextContainer: textContainer ].size.height ];
    return ( height > minimumHeight ) ? height : minimumHeight;
    }

- ( void ) tableViewColumnDidResize: ( nonnull NSNotification* )_Notif
    {
    NSMutableIndexSet* indexesChanged = [ NSMutableIndexSet indexSet ];
    [ self.timelineTableView enumerateAvailableRowViewsUsingBlock:
        ^( NSTableRowView* _RowView, NSInteger _Row )
            {
            [ indexesChanged addIndex: _Row ];
            } ];

    [ ( ( NSTableColumn* )_Notif.userInfo[ @"NSTableColumn" ] ).tableView noteHeightOfRowsWithIndexesChanged: indexesChanged ];
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