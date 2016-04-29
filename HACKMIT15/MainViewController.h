//
//  MainViewController.h
//  HACKMIT15
//
//  Created by Samuel Mueller on 19.09.15.
//  Copyright (c) 2015 HACKETH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableView.h"
#import "UberKit.h"





@interface MainViewController : UIViewController <UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UIViewControllerPreviewingDelegate>
@property (weak, nonatomic) IBOutlet UIButton *topLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *topRightButton;
@property (weak, nonatomic) IBOutlet MainTableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong,nonatomic) NSMutableArray *placesArray;


@end

