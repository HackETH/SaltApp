//
//  StandardTableViewCell.h
//  HACKMIT15
//
//  Created by Samuel Mueller on 19.09.15.
//  Copyright (c) 2015 HACKETH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MainImageScrollView.h"
//@import GoogleMaps;


@interface StandardTableViewCell : UITableViewCell <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet MainImageScrollView *mainImageScrollView;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *UberTitle;
@property (weak, nonatomic) IBOutlet UILabel *UberPickUpTime;
@property (weak, nonatomic) IBOutlet UILabel *UberDriveTime;
@property (weak, nonatomic) IBOutlet UILabel *UberPrice;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationDegrees lat;
@property (weak) NSMutableArray *placesArray;
@property NSMutableDictionary *cellData;
//@property GMSMarker *marker;

@property (nonatomic) int index;
@property CLLocationDegrees lon;
@property CLLocationDegrees melat;
@property CLLocationDegrees melon;
@property (weak, nonatomic) IBOutlet UIView *googleMapView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImg;
@property (weak, nonatomic) IBOutlet UIImageView *priceImg;
@property (weak, nonatomic) IBOutlet UILabel *Type;
@property (weak, nonatomic) IBOutlet UILabel *open;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *uberButton;
@property NSString *restaurantId;
@property NSString *lastId;
@property CGFloat startOffset;
@property BOOL newAllowed;

@end
