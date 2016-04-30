//
//  GlanceController.h
//  SaltWatchApp Extension
//
//  Created by Samuel Mueller on 29.04.16.
//  Copyright © 2016 HACKETH. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface GlanceController : WKInterfaceController <CLLocationManagerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageController;

@end
