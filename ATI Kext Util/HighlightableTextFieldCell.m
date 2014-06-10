

#import "HighlightableTextFieldCell.h"

@implementation HighlightableTextFieldCell
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if([self isHighlighted])
        color = [NSColor redColor];
    else
        color = [NSColor greenColor];
    
    [color set];
    
    NSRectFill(cellFrame);
    [[self title] drawInRect:cellFrame withAttributes:nil];
}
@end
