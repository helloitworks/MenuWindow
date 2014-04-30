
#import "RoundWindowFrameView.h"
#import "NSBezierPath+PXRoundedRectangleAdditions.h"

@implementation RoundWindowFrameView
@dynamic allCornersRounded, proMode;

//
// drawRect:
//
// Draws the frame of the window.
//
- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
	[[NSColor clearColor] set];
	NSRectFill([self bounds]);
    
	if (proMode == NO) {
		NSBezierPath *path;
		
		if (allCornersRounded)
			path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:5];
		else
			path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:5 inCorners:OSBottomLeftCorner | OSBottomRightCorner];
		
		
		NSGradient* aGradient = [[[NSGradient alloc] initWithColorsAndLocations:
					[NSColor colorWithDeviceWhite:1 alpha:0.97], (CGFloat)0.0,
					[NSColor colorWithDeviceWhite:1 alpha:0.97], (CGFloat)1.0,
					nil] autorelease];
		[aGradient drawInBezierPath:path angle:90];
	} else {
		NSBezierPath *path;
		
		if (allCornersRounded)
			path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:5];
		else
			path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:5 inCorners:OSBottomLeftCorner | OSBottomRightCorner];
		
		NSGradient* aGradient = [[[NSGradient alloc] initWithColorsAndLocations:
								  [NSColor colorWithDeviceWhite:0 alpha:0.97], (CGFloat)0.0,
								  [NSColor colorWithDeviceWhite:0 alpha:0.97], (CGFloat)1.0,
								  nil] autorelease];
		[aGradient drawInBezierPath:path angle:90];
	}
}

#pragma mark Dynamics

- (BOOL)allCornersRounded {
	return allCornersRounded;
}

- (void)setAllCornersRounded:(BOOL)flag {
	allCornersRounded = flag;
	[self setNeedsDisplay:YES];
}

- (BOOL)proMode {
	return proMode;
}

- (void)setProMode:(BOOL)flag {
	proMode = flag;
	[self setNeedsDisplay:YES];
}

@end
