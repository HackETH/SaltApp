//
//  StandardTableViewCell.m
//  HACKMIT15
//
//  Created by Samuel Mueller on 19.09.15.
//  Copyright (c) 2015 HACKETH. All rights reserved.
//




#import "StandardTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SIAlertView.h"

@implementation StandardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.mainImageScrollView.showsHorizontalScrollIndicator = NO;
    self.mainImageScrollView.delegate = self;
    self.newAllowed = YES;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.placesArray[self.index][@"offset"] = [NSNumber numberWithDouble:(double)scrollView.contentOffset.x];
}

/*
- (void)handleTap{
    NSLog(@"handleTep");
    [self setSelected:YES animated:YES];
}*/

- (IBAction)mapPressed:(id)sender {
    
    //Diese Funktion wurde nur aus Faulheit im Code stehen gelassen.
    /*CLLocationCoordinate2D anno=(CLLocationCoordinate2D)[self.mapView annotations].firstObject.coordinate;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:anno addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:self.name.text];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    [mapItem openInMapsWithLaunchOptions:options];*/
}
- (IBAction)uberPressed:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        // Do something awesome - the app is installed! Launch App.
        NSLog([NSString stringWithFormat:@"uber://?client_id=7TuD68rPyn9syrhKaeylAl_t9WeHj8gb&action=setPickup&pickup=my_location&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[nickname]=%@",(float)self.lat,(float)self.lon,self.name.text]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"uber://?client_id=7TuD68rPyn9syrhKaeylAl_t9WeHj8gb&action=setPickup&pickup=my_location&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[nickname]=%@",(float)self.lat,(float)self.lon,self.name.text]]];
        //
        
    }
    else {
        // No Uber app! Open Mobile Website.
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Uber" message:@"You don't have Uber on your phone!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
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



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"YO");
    if (self.newAllowed) {
        self.newAllowed = NO;
        NSString *address = [NSString stringWithFormat:@"http://salt-updatified.rhcloud.com/restaurants/%@/photos?max-id=%@",self.cellData[@"id"],self.lastId];
        NSLog(@"%@",address);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET: address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (NSDictionary *photoDic in (NSArray *)responseObject) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGFloat)self.startOffset, 0, self.frame.size.width, self.frame.size.width)];
                //[imageView setImageWithURL:[NSURL URLWithString:picData[@"url"]]];
                [imageView setImageWithURL:[NSURL URLWithString:photoDic[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setImage:[UIImage imageNamed:@"Flag Button"] forState:UIControlStateNormal]
                ;
                
                [button setFrame:CGRectMake(10, 10, 30, 30)];
                
                [button addTarget:self action:@selector(flag) forControlEvents:UIControlEventTouchUpInside];
                
                imageView.userInteractionEnabled = true;
                [imageView addSubview:button];
                
                [self.mainImageScrollView addSubview:imageView];
                self.mainImageScrollView.contentSize = CGSizeMake((self.frame.size.width+self.startOffset), self.mainImageScrollView.frame.size.height);
                self.startOffset=self.startOffset + (NSInteger)(self.frame.size.width);
                self.lastId = photoDic[@"id"];
            }
            self.newAllowed = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tError: %@", error);
        }];
    }
   

}

@end
