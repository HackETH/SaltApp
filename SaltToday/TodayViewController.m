//
//  TodayViewController.m
//  SaltToday
//
//  Created by Samuel Mueller on 29.04.16.
//  Copyright © 2016 HACKETH. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#define AF_APP_EXTENSIONS
@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    // Perform any setup necessary in order to update the view.
    CLLocationManager *locmanager = [[CLLocationManager  alloc]init];
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([locmanager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locmanager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locmanager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locmanager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    NSString *address = [NSString stringWithFormat:@"http://www-saltapp.rhcloud.com/restaurants/discover?lat=%f&long=%f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *sortedArray = [((NSArray *)((NSDictionary *)responseObject)[@"restaurants"]) sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)[obj1 valueForKey:@"rating"] floatValue]<[(NSString *)[obj2 valueForKey:@"rating"] floatValue];
        }];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ is around the corner",sortedArray[0][@"name"]];
        for (int i =0; i<4; i++) {
            [(UIImageView *)_imV[i] setImageWithURL:[NSURL URLWithString:sortedArray[0][@"photos"][i][@"small_url"]]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"tError: %@", error);
        
    }];
    
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}



@end
