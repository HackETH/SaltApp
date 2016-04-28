//
//  MainViewController.m
//  HACKMIT15
//
//  Created by Samuel Mueller on 19.09.15.
//  Copyright (c) 2015 HACKETH. All rights reserved.
//


#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "TLYShyNavBarManager.h"
#import "SIAlertView.h"
#import <Google/Analytics.h>
#import "PreviewViewController.h"

//@import GoogleMaps;


#import "MainViewController.h"
#import "StandardTableViewCell.h"
#import<CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>




@interface MainViewController ()
@property NSUInteger placesCount;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong,nonatomic) NSArray *offsetArray;
@property double longitude;
@property double latitude;
@property int rowcount;
@property bool isFood;
@property NSIndexPath *expandedRow;
@property CLLocation *currentLocation;
@property CLLocationManager *locationManager;
@property BOOL notfirstTime;
@property NSString *sessionId;
@property NSString *nextUrl;
@property (weak, nonatomic) IBOutlet UIView *googleMapView;

@end

@implementation MainViewController 
//{
//    GMSMapView *mapView_;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([self.traitCollection
         respondsToSelector:@selector(forceTouchCapability)] &&
        (self.traitCollection.forceTouchCapability ==
         UIForceTouchCapabilityAvailable))
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    
    
    self.isFood = true;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self.tableView sendSubviewToBack:refreshControl];
    [self setNeedsStatusBarAppearanceUpdate];

   //self.shyNavBarManager.scrollView = self.tableView;
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                          NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"BrandonText-Light" size:24.0f],
                                                           
                                                            }];
    // Do any additional setup after loading the view.

    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [self.locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [self.locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Main View"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

- (UIViewController *)previewingContext:
(id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location {
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    PreviewViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"preview"];
    
    return viewController;
}



- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    
    
    //TODO - Adjust for Food/Drink
    
    if (self.isFood) {
        
    
    NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/discover?lat=%f&long=%f",self.latitude,self.longitude];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self gotPlaces:(NSDictionary *)responseObject[@"restaurants"]];
            self.nextUrl = ((NSDictionary *)responseObject[@"next_url"]);
            NSLog(@"%@",responseObject);
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tError: %@", error);
            [refreshControl endRefreshing];
        }];
    
    } else {
        
        NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/discover?lat=%f&long=%f",self.latitude,self.longitude];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self gotPlaces:(NSDictionary *)responseObject[@"restaurants"]];
            self.nextUrl = ((NSDictionary *)responseObject[@"next_url"]);
            NSLog(@"%@",responseObject);
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tError: %@", error);
            [refreshControl endRefreshing];
        }];
        
    }


    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
    if (self.currentLocation != nil) {
        self.longitude = self.currentLocation.coordinate.longitude;
        self.latitude = self.currentLocation.coordinate.latitude;
    }
//
//    //New York
//    self.longitude = -73.985174;
//    self.latitude = 40.764189;
//
//    //Singapore
//    self.longitude = 103.845533;
//    self.latitude = 1.280635;
//
//
    //Paris
//    self.longitude = 11.638880;
//    self.latitude = 48.081061;

    
    
    NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/discover?lat=%f&long=%f",self.latitude,self.longitude];
    //NSLog(@"%f %f",self.latitude,self.longitude);
    if (!self.notfirstTime) {
        self.notfirstTime = YES;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self gotPlaces:(NSDictionary *)responseObject[@"restaurants"]];
            self.nextUrl = ((NSDictionary *)responseObject[@"next_url"]);
            
            
            NSLog(@"%@",responseObject);
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error ) {
            NSLog(@"tError: %@", error);
            [self.activityIndicator stopAnimating];
        }];
    }
    
}

-(void)gotPlaces:(NSArray *)placesArray{
    self.placesCount = placesArray.count;
    if (!self.placesCount || self.placesCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Nothing is open!" message:@"In your area currently nothing is open." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    self.placesArray = [NSMutableArray arrayWithArray:placesArray];
    for (int i = 0; i<[self.placesArray count]; i++) {
        ((NSMutableArray *)self.placesArray)[i] = [NSMutableDictionary dictionaryWithDictionary:self.placesArray[i]];
        ((NSMutableArray *)self.placesArray)[i][@"offset"] = [NSNumber numberWithDouble:0.0];
        
    }
    NSLog(@"offset at first:%@",self.placesArray[0][@"offset"]);
    self.rowcount = (int)self.placesCount;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.placesCount) {
        return self.placesCount +1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellNum = [indexPath indexAtPosition:1];
    if (cellNum<self.placesCount) {
        StandardTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier: @"StandardCell" forIndexPath:indexPath];
        
        [cell.mainImageScrollView setContentOffset:CGPointZero animated:NO];
        
        
        
        
        
        
        cell.placesArray = self.placesArray;
        cell.cellData = [NSMutableDictionary dictionaryWithDictionary:self.placesArray[cellNum]];
        cell.index = cellNum;
        cell.name.text = cell.cellData[@"name"];
        cell.distance.text = [NSString stringWithFormat:@"%@ m", cell.cellData[@"distance"]];
        double distanceMiles = 0.000621371*[cell.cellData[@"distance"] intValue];
        
        //Distance in Miles:
        cell.distance.text = [NSString stringWithFormat:@"%.1f mi", distanceMiles];
        
        cell.UberTitle.font = [UIFont fontWithName:@"BrandonText-Medium" size:18];
        cell.UberPickUpTime.font = [UIFont fontWithName:@"BrandonText-Light" size:13];
        cell.UberDriveTime.font = [UIFont fontWithName:@"BrandonText-Medium" size:13];
        cell.UberPrice.font = [UIFont fontWithName:@"BrandonText-Light" size:13];
        
        cell.name.font = [UIFont fontWithName:@"BrandonText-Light" size:18];
        cell.distance.font = [UIFont fontWithName:@"BrandonText-Regular" size:14];
        cell.Type.font = [UIFont fontWithName:@"BrandonText-Regular" size:14];
        cell.open.font = [UIFont fontWithName:@"BrandonText-Regular" size:14];
        cell.clipsToBounds = YES;
        
        // Configure the cell...
        
       
     
        
        cell.Type.text = cell.cellData[@"category"];
        cell.mapView.region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 10000, 10000);
        cell.melat = self.currentLocation.coordinate.latitude;
        cell.melon = self.currentLocation.coordinate.longitude;
        cell.lat = ((NSNumber *)cell.cellData[@"latitude"]).doubleValue;
        cell.lon = ((NSNumber *)cell.cellData[@"longitude"]).doubleValue;
        
        
        //Google Maps
        
//        
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:47.377944
//                                                                longitude:8.540198
//                                                                     zoom:12];
//        
//        mapView_ = [GMSMapView mapWithFrame:CGRectMake(cell.googleMapView.frame.origin.x, cell.googleMapView.frame.origin.y, self.view.frame.size.width, 218.0) camera:camera];
//        mapView_.myLocationEnabled =YES;
//        
//       
//        cell.marker = [[GMSMarker alloc] init];
//        cell.marker.position = [[CLLocation alloc] initWithLatitude:cell.lat longitude:cell.lon].coordinate;
//        
//        //        marker.title = type;
//        //        marker.snippet = address;
//        
//        cell.marker.map = mapView_;
//        
//        [cell.googleMapView addSubview:mapView_];
//        
//        NSString *urlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&directionsmode=walking&key=AIzaSyDSQaUuGuinBlpo9UEXBDBDWPL3T_50wg8",(double)cell.melat, (double)cell.melon,(double)cell.lat, (double)cell.lon];
//        
//        
//        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        
//        NSURL *url = [NSURL URLWithString:urlStr];
//        
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        
//        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//        
//        /*
//         * sendAsynchronousRequest:queue:completionHandler: - Loads the data for a URL request and executes a handler block on an operation queue when the request completes or fails.
//         */
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            if (!connectionError) {
//                
//                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:nil];
//                NSLog(@"%s - %d # responseStr = %@", __PRETTY_FUNCTION__, __LINE__, responseStr);
//                NSArray *routes = json[@"routes"];
//                NSDictionary *polylines = routes[0];
//                NSArray *legs = polylines[@"legs"];
//                
//                
//                NSDictionary *overviewPolylines = polylines[@"overview_polyline"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    UIEdgeInsets mapInsets = UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0);
//                    mapView_.padding = mapInsets;
//                    CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake([polylines[@"bounds"][@"northeast"][@"lat"] doubleValue] ,[polylines[@"bounds"][@"northeast"][@"lng"] doubleValue]);
//                    CLLocationCoordinate2D calgary = CLLocationCoordinate2DMake([polylines[@"bounds"][@"southwest"][@"lat"] doubleValue] ,[polylines[@"bounds"][@"southwest"][@"lng"] doubleValue]);
//                    GMSCoordinateBounds *bounds =
//                    [[GMSCoordinateBounds alloc] initWithCoordinate:vancouver coordinate:calgary];
//                    GMSCameraPosition *camera = [mapView_ cameraForBounds:bounds insets:UIEdgeInsetsZero];
//                    mapView_.camera = camera;
//                    mapInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//                    mapView_.padding = mapInsets;
//                    //                [self.routeButton setImage:[UIImage imageNamed:@"startRoute"] forState:UIControlStateNormal];
//                    //                self.routePlaned = true;
//                    
//                    GMSMutablePath *path = [GMSMutablePath pathFromEncodedPath:overviewPolylines[@"points"]];
//                    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//                    polyline.strokeWidth = 3.f;
//                    polyline.geodesic = YES;
//                    polyline.map = mapView_;
//                    [cell.googleMapView addSubview:mapView_];
//                    
//                });
//               
//                
//                
//                
//            }
//            else {
//                
//            }
//            
//        }];

        
        
        
        [[UberKit sharedInstance] setServerToken:@"jLLDmf_uJTlcBl6ne9c1gg-ovizJNhX0Lsa4TK1o"];
        
        [[UberKit sharedInstance] getPriceForTripWithStartLocation:self.currentLocation endLocation:[[CLLocation alloc] initWithLatitude:cell.lat longitude:cell.lon] withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
            if (!error) {
                int low = 100;
                int high = 0;
                NSString *estimate = @"$";
                for (UberPrice *dic in resultsArray) {
                    if (dic.lowEstimate<low) {
                        low = dic.lowEstimate;
                        estimate = dic.estimate;
                    }
                    if (dic.highEstimate>high) {
                        high = dic.highEstimate;
                    }
                }
                if ([resultsArray count]==0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // do work here
                        cell.UberPrice.text = @"Not Avaiable";
                        
                    });
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.UberPrice.text = estimate;
                        
                    });
                    
                }
            }
        }];
        [[UberKit sharedInstance] getTimeForProductArrivalWithLocation:[[CLLocation alloc] initWithLatitude:cell.lat longitude:cell.lon] withCompletionHandler:^(NSArray *times, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 if (times.count > 0) {
                     UberTime *time = [times objectAtIndex:0];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         cell.UberDriveTime.text = [NSString stringWithFormat:@"%d min", (int)time.estimate/60];
                         
                     });
                     
                 }
                 
                 else {
                  
                     dispatch_async(dispatch_get_main_queue(), ^{
                         cell.UberDriveTime.text = [NSString stringWithFormat:@"- min"];
                         
                     });
                 }
                 
                 
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
        [[cell.mainImageScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.mainImageScrollView.contentSize = CGSizeMake(self.view.frame.size.width*((NSArray *)cell.cellData[@"photos"]).count, cell.mainImageScrollView.frame.size.height);
        cell.mainImageScrollView.scrollEnabled = YES;
        cell.mainImageScrollView.pagingEnabled = YES;
        cell.mainImageScrollView.contentOffset = CGPointMake(0, 0);
        int rating = [cell.cellData[@"rating"] intValue]/2+0.5;
        cell.ratingImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%dStars",rating]];
//        if (rating>5 || rating<0) {
//            cell.ratingImg.image = [UIImage imageNamed:@"0Stars"];
//        }
        cell.priceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Dollar",cell.cellData[@"price"]]];
        // Configure the view for the selected state
        [cell.mapView removeAnnotations:cell.mapView.annotations];
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = CLLocationCoordinate2DMake(cell.lat, cell.lon);
        [cell.mapView addAnnotation:pa];
        MKPointAnnotation *me = [[MKPointAnnotation alloc]init];
        me.coordinate = CLLocationCoordinate2DMake(cell.melat, cell.melon);
        
        [cell.mapView showAnnotations:@[pa,me] animated:YES];
        [cell.mapView removeAnnotation:me];
        NSInteger offset = 0;
        [[cell.mainImageScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

        for (NSDictionary *picData in cell.cellData[@"photos"]) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGFloat)offset, 0, self.view.frame.size.width, self.view.frame.size.width)];
            //[imageView setImageWithURL:[NSURL URLWithString:picData[@"url"]]];
            [imageView setImageWithURL:[NSURL URLWithString:picData[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
            
//            UIImageView *userProfile = [[UIImageView alloc] init];
//        
//            [userProfile setImageWithURL:[NSURL URLWithString:picData[@"user"][@"profile_picture"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
//            [userProfile setFrame:CGRectMake(self.view.frame.size.width-60, self.view.frame.size.width-60, 40, 40)];
//            userProfile.layer.cornerRadius = 20;
//            [imageView addSubview:userProfile];
//            
//            UILabel *fullName = [[UILabel alloc] init];
//            fullName.text = @"Peter Müller";
//            fullName.textColor = [UIColor blackColor];
//            fullName.textAlignment = NSTextAlignmentRight;
////            fullName.shadowColor = [UIColor whiteColor];
////            fullName.shadowOffset = CGSizeMake(4, 4);
//            fullName.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
//            fullName.layer.shadowOffset = CGSizeMake(2.0, 2.0);
//            fullName.layer.shadowRadius = 3.0;
//            
//            [fullName setFrame:CGRectMake(0, self.view.frame.size.width-60, self.view.frame.size.width-70, 20)];
//            [imageView addSubview:fullName];
//            
//            UILabel *username = [[UILabel alloc] init];
//            username.text = @"@mullerpeter";
//            username.textColor = [UIColor blackColor];
//            username.textAlignment = NSTextAlignmentRight;
//            //            fullName.shadowColor = [UIColor whiteColor];
//            //            fullName.shadowOffset = CGSizeMake(4, 4);
//            
//            [username setFrame:CGRectMake(0, self.view.frame.size.width-40, self.view.frame.size.width-70, 20)];
//            [imageView addSubview:username];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"Flag Button"] forState:UIControlStateNormal]
            ;
            
            [button setFrame:CGRectMake(10, 10, 30, 30)];
            
            [button addTarget:self action:@selector(flag) forControlEvents:UIControlEventTouchUpInside];
            
            imageView.userInteractionEnabled = true;
            [imageView addSubview:button];
            
            [cell.mainImageScrollView addSubview:imageView];
            offset=offset + (NSInteger)(self.view.frame.size.width);
        }
        cell.startOffset = offset;
        cell.mainImageScrollView.contentOffset = CGPointMake(((NSNumber *)cell.cellData[@"offset"]).doubleValue, 0.f);
        NSLog(@"init offset %@",(cell.cellData[@"offset"]));
        cell.lastId = ((NSArray *)cell.cellData[@"photos"])[((NSArray *)cell.cellData[@"photos"]).count-1][@"id"];
        if (cellNum+3==self.placesCount) {
            //load new
            NSString *address = self.nextUrl;
               [self.activityIndicator startAnimating];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.nextUrl = ((NSDictionary *)responseObject[@"next_url"]);
                
                NSMutableArray *newpart = [NSMutableArray arrayWithArray:(NSArray *)responseObject[@"restaurants"]];
                for (int i = 0; i<[newpart count]; i++) {//123
                    ((NSMutableArray *)newpart)[i] = [NSMutableDictionary dictionaryWithDictionary:newpart[i]];

                    newpart[i][@"offset"] = [NSNumber numberWithDouble:0.0];
                }
                self.placesArray= [self.placesArray arrayByAddingObjectsFromArray: newpart];
                self.placesCount = self.placesArray.count;
                self.rowcount = self.placesCount;
                [self.tableView reloadData];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"tError: %@", error);
                [self.activityIndicator stopAnimating];
                
            }];

            
        }
        
        cell.mapButton.tag = cellNum;
        [cell.mapButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.uberButton.tag = cellNum;
        [cell.uberButton addTarget:self action:@selector(uberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier: @"loadCell" forIndexPath:indexPath];
        return cell;

    }
    
    
    
}



-(void)uberButtonClicked:(UIButton*)sender
{
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"button_press"  // Event action (required)
                                                           label:@"uber"          // Event label
                                                           value:nil] build]];
    NSDictionary *tempdic = self.placesArray[sender.tag];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        // Do something awesome - the app is installed! Launch App.
    #pragma mark hier gibt es ein problem
        NSLog(@"yo");
        NSString *urlstring = [NSString stringWithFormat:@"uber://?client_id=7TuD68rPyn9syrhKaeylAl_t9WeHj8gb&action=setPickup&pickup=mylocation&dropoff[latitude]=%@%@dropoff[longitude]=%@%@dropoff[nickname]=%@%@product_id=a1111c8c-c720-46c3-8534-2fcdd730040d",tempdic[@"latitude"],@"&",tempdic[@"longitude"],@"&",[tempdic[@"name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],@"&"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstring]];
    }
    else {
        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"https://m.uber.com/sign-up?client_id=7TuD68rPyn9syrhKaeylAl_t9WeHj8gb"]];
        // No Uber app! Open Mobile Website.
    }
}
- (void)expandRow:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.expandedRow = indexPath;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)mapButtonClicked:(UIButton*)sender
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"button_press"  // Event action (required)
                                                           label:@"maps"          // Event label
                                                           value:nil] build]];
    
    NSDictionary *tempdic = self.placesArray[sender.tag];
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%@,%@&directionsmode=walking",self.latitude,self.longitude,tempdic[@"latitude"],tempdic[@"longitude"]]]];
    } else {
        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%@,%@&directionsmode=walking",self.latitude,self.longitude,tempdic[@"latitude"],tempdic[@"longitude"]]]];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Detail Disclosure Tapped");
    // Set expanded cell then tell tableView to redraw with animation
    self.expandedRow = indexPath;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (IBAction)topPress:(id)sender {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}
- (IBAction)rightTopPress:(id)sender {
   
    
    if (self.isFood) {
        
        self.placesCount = 0;
        self.placesArray = @[];
        self.rowcount = 0;
         self.expandedRow = nil;
        [self.tableView reloadData];
        [self.activityIndicator startAnimating];
        [self.topRightButton setImage:[UIImage imageNamed:@"Drink_Sel"] forState:UIControlStateNormal];
        [self.topLeftButton setImage:[UIImage imageNamed:@"Food"] forState:UIControlStateNormal];
        self.isFood = false;
        [self reloadDrink];
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (IBAction)leftTopPress:(id)sender {

   
    
    if (!self.isFood) {
    
        self.placesCount = 0;
         self.placesArray = @[];
        self.rowcount = 0;
        self.expandedRow = nil;
        [self.tableView reloadData];
        [self.activityIndicator startAnimating];
        [self.topLeftButton setImage:[UIImage imageNamed:@"Food_Sel"] forState:UIControlStateNormal];
        [self.topRightButton setImage:[UIImage imageNamed:@"Drink2"] forState:UIControlStateNormal];
         self.isFood = true;
        [self reloadFood];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:self.expandedRow]) {
        return self.view.frame.size.width+400;
    }
    
    return self.view.frame.size.width+75;
}
- (void)flag {
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Report" andMessage:@"Flag this image"];
    
    [alertView addButtonWithTitle:@"Cancel"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button1 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Flag"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/flag?id=%i",arc4random_uniform(1000000)];
                              
                              AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                              [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Thank you" andMessage:@"We've recived you report."];
                                  
                                  [alertView addButtonWithTitle:@"OK"
                                                           type:SIAlertViewButtonTypeDefault
                                                        handler:^(SIAlertView *alert) {
                                                            NSLog(@"Button1 Clicked");
                                                        }];
                                
                                  
                                  
                                  
                                  
                                  alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                                  
                                  [alertView show];
                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"tError: %@", error);
                                  
                                  
                              }];
                          }];
   
    
   
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
    
    
    
   
}

- (void)reloadFood {
    
    //TODO - Adjust for Food
    
    NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/discover?lat=%f&long=%f",self.latitude,self.longitude];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self gotPlaces:(NSDictionary *)responseObject[@"restaurants"]];
        self.nextUrl = ((NSDictionary *)responseObject[@"next_url"]);

        NSLog(@"%@",responseObject);
        [self.tableView reloadData];
           [self.activityIndicator stopAnimating];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"tError: %@", error);
           [self.activityIndicator stopAnimating];
        
    }];

}

- (void)reloadDrink {
    
    //TODO - Adjust for Drink
    
    NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/discover?lat=%f&long=%f",self.latitude,self.longitude];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self gotPlaces:(NSDictionary *)responseObject[@"restaurants"]];
        self.nextUrl = ((NSDictionary *)responseObject[@"next_url"]);

        NSLog(@"%@",responseObject);
        [self.tableView reloadData];
           [self.activityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"tError: %@", error);
        [self.activityIndicator stopAnimating];
        
    }];

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
