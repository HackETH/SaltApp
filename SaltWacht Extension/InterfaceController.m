//
//  InterfaceController.m
//  SaltWacht Extension
//
//  Created by Samuel Mueller on 30.04.16.
//  Copyright © 2016 HACKETH. All rights reserved.
//

#import "InterfaceController.h"
#import "MainRow.h"

@interface InterfaceController()
@property CLLocationManager *locmanager;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    NSError* error = nil; //do it always
    
    self.locmanager = [[CLLocationManager  alloc]init];
    [self.locmanager  requestWhenInUseAuthorization];

    self.locmanager.delegate = self;
    [self.locmanager requestLocation];

}


- (void)locationManager:(CLLocationManager *)locmanager didUpdateLocations:(NSArray *)locations {
    // Callback here with single location if location succeeds
    NSLog(@"succ");
    if (locmanager.location.coordinate.longitude != 0.0) {
        NSLog(@"ok");
        NSError* error = nil; //do it always
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www-saltapp.rhcloud.com/restaurants/discover?lat=%f&long=%f",locmanager.location.coordinate.latitude, locmanager.location.coordinate.longitude]]];
        if(data){
        NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSArray *sortedArray = [((NSArray *)((NSDictionary *)allData)[@"restaurants"]) sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)[obj1 valueForKey:@"rating"] floatValue]<[(NSString *)[obj2 valueForKey:@"rating"] floatValue];
        }];
        [self.table setNumberOfRows:sortedArray.count withRowType:@"MainRow"];
        //[self.table setNumberOfRows:1 withRowType:@"LastRow"]; //Maybe diese Zeile weg
        for (int i = 0; i<sortedArray.count; i++) {
            //do it async!!
            MainRow *row = [self.table rowControllerAtIndex:i];
            [row.label setText:sortedArray[i][@"name"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sortedArray[i][@"photos"][0][@"small_url"]]];
                if (imData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [row.imageView setImageData:imData];
                    });
                }
            });
            
        }
        }else{
            [self.table setNumberOfRows:1 withRowType:@"MainRow"];
            MainRow *row = [self.table rowControllerAtIndex:0];
            [row.imageView setImageNamed:@"Not Found"];
            [row.label setText:@"No Connection"];
        }
    }else{
        [self.table setNumberOfRows:1 withRowType:@"MainRow"];
        MainRow *row = [self.table rowControllerAtIndex:0];
        [row.imageView setImageNamed:@"Not Found"];
        [row.label setText:@"Allow Location"];

    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // Error here if no location can be found
    NSLog(@"fail");
    [self.table setNumberOfRows:1 withRowType:@"MainRow"];
    MainRow *row = [self.table rowControllerAtIndex:0];
    [row.imageView setImageNamed:@"Not Found"];
    [row.label setText:@"Allow Location"];
}



- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



