
#import "DetectingTableView.h"

@implementation DetectingTableView

- (void)dealloc {
    [_trackingArea release];
    [super dealloc];
}


- (void)setMouseInside:(BOOL)value {
    
    if (mouseInside != value) {
        mouseInside = value;
        [self setNeedsDisplay:YES];
    }
}

- (BOOL)mouseInside {
    return mouseInside;
}

- (void) createTrackingArea
{
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
    
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation
                              fromView: nil];
    
    if (CGRectContainsPoint(NSRectToCGRect([self bounds]),NSPointToCGPoint(mouseLocation)))
    {
        [self mouseEntered: nil];
    }
    else
    {
        [self mouseExited: nil];
    }
}

//bugfix:mouseExited/mouseEntered isn't called when mouse exits from NStrackingArea by scrolling or doing animation
- (void)updateTrackingAreas {
    [self removeTrackingArea:_trackingArea];
    [self createTrackingArea];
    [super updateTrackingAreas];
    
}


- (void)mouseMoved:(NSEvent *)theEvent {
    NSLog(@"mouseMoved");
    [super mouseEntered:theEvent];
    self.mouseInside = YES;
    NSPoint selfPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger row = [self rowAtPoint:selfPoint];
    
    if ([self.delegate respondsToSelector:@selector(onMouseMovedAtRow:)])
    {
        [(id<DetectingTableViewDelegate>)self.delegate onMouseMovedAtRow:row];
    }
}


- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    self.mouseInside = YES;
    NSPoint selfPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger row = [self rowAtPoint:selfPoint];
    
    if ([self.delegate respondsToSelector:@selector(onMouseEnteredAtRow:)])
    {
        [(id<DetectingTableViewDelegate>)self.delegate onMouseEnteredAtRow:row];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    self.mouseInside = NO;
    //mouseExited计算出的row为-1
    //NSPoint selfPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger row = -1;
    
    if ([self.delegate respondsToSelector:@selector(onMouseExitedAtRow:) ])
    {
        [(id<DetectingTableViewDelegate>)self.delegate onMouseExitedAtRow:row];
    }
}


- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    // Forward the click to the row's cell view
    NSPoint selfPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger row = [self rowAtPoint:selfPoint];
    
    if ([self.delegate respondsToSelector:@selector(onMouseDownAtRow:) ])
    {
        [(id<DetectingTableViewDelegate>)self.delegate onMouseDownAtRow:row];
    }
}






@end