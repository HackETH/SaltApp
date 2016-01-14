//
//  MainImageScrollView.m
//  HACKMIT15
//
//  Created by Samuel Mueller on 22.11.15.
//  Copyright © 2015 HACKETH. All rights reserved.
//

#import "MainImageScrollView.h"

@implementation MainImageScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"yo");
    
    [[self superview]touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesEnded:touches withEvent:event];
}


@end
