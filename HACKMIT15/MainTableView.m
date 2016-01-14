//
//  MainTableView.m
//  HACKMIT15
//
//  Created by Samuel Mueller on 20.09.15.
//  Copyright (c) 2015 HACKETH. All rights reserved.
//

#import "MainTableView.h"

@implementation MainTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //resignFirstResponder for the UITextView
    
    //call didSelectRow of tableView again, by passing the touch to the super class
    [super touchesBegan:touches withEvent:event];
}

@end
