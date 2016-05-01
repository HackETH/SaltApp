//
//  GlanceController.m
//  SaltWatchApp Extension
//
//  Created by Samuel Mueller on 29.04.16.
//  Copyright © 2016 HACKETH. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *label;
@property CLLocationManager *locmanager;
@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.locmanager = [[CLLocationManager  alloc]init];
    
    [self.locmanager  requestWhenInUseAuthorization];
    self.locmanager.delegate = self;
    [self.locmanager requestLocation];
    NSLog(@"hi");
    //for saving all of received data in non-serialized view

    
}
- (void)locationManager:(CLLocationManager *)locmanager didUpdateLocations:(NSArray *)locations {
    // Callback here with single location if location succeeds
    NSLog(@"succ");
    if (locmanager.location.coordinate.longitude != 0.0) {
        NSLog(@"ok");
        NSError* error = nil; //do it always

        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www-saltapp.rhcloud.com/restaurants/discover?lat=%f&long=%f",locmanager.location.coordinate.latitude, locmanager.location.coordinate.longitude]]];
        if (data) {
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSArray *sortedArray = [((NSArray *)((NSDictionary *)allData)[@"restaurants"]) sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)[obj1 valueForKey:@"rating"] floatValue]<[(NSString *)[obj2 valueForKey:@"rating"] floatValue];
            }];
            NSData *imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sortedArray[0][@"photos"][0][@"small_url"]]];
            [self.imageController setImageData:imData];
            [self.label setText:sortedArray[0][@"name"] ];
        }else{
            [self.label setText:@"No Connection"];
            [self.imageController setImageNamed:@"Not Found"];
        }
        
    }else{
        [self.label setText:@"Allow Location"];
        [self.imageController setImageNamed:@"Not Found"];

    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // Error here if no location can be found
    NSLog(@"fail");
    [self.label setText:@"Allow Location"];
    [self.imageController setImageNamed:@"Not Found"];


}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    
    [self.locmanager  requestWhenInUseAuthorization];
    self.locmanager.delegate = self;
    [self.locmanager requestLocation];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



