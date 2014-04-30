@protocol DetectingTableViewDelegate<NSTableViewDelegate>
- (void)onMouseEnteredAtRow:(NSUInteger)rowIndex;
- (void)onMouseExitedAtRow:(NSUInteger)rowIndex;
- (void)onMouseMovedAtRow:(NSUInteger)rowIndex;

- (void)onMouseDownAtRow:(NSUInteger)rowIndex;
@end


@interface DetectingTableView : NSTableView
{
@private
    BOOL mouseInside;
    NSTrackingArea *_trackingArea;
}

- (void)updateTrackingAreas;
@end