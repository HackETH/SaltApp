//
//  MainRow.h
//  HACKMIT15
//
//  Created by Samuel Mueller on 30.04.16.
//  Copyright © 2016 HACKETH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface MainRow : NSObject
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *label;

@end
