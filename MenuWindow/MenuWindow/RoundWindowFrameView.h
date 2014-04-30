#import <Cocoa/Cocoa.h>


@interface RoundWindowFrameView : NSView
{
	BOOL allCornersRounded;
	BOOL proMode;
}

@property (nonatomic, assign) BOOL allCornersRounded;
@property (nonatomic, assign) BOOL proMode;

@end
