//
//  PreviewViewController.m
//  HACKMIT15
//
//  Created by Peter Müller on 29/04/16.
//  Copyright © 2016 HACKETH. All rights reserved.
//

#import "PreviewViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

@interface PreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *photo1 = self.photos[0];
    NSDictionary *photo2 = self.photos[1];
    NSDictionary *photo3 = self.photos[2];
    NSDictionary *photo4 = self.photos[3];
    NSDictionary *photo5 = self.photos[4];
    NSDictionary *photo6 = self.photos[5];
    [self.image1 setImageWithURL:[NSURL URLWithString:photo1[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
     [self.image2 setImageWithURL:[NSURL URLWithString:photo2[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
     [self.image3 setImageWithURL:[NSURL URLWithString:photo3[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
     [self.image4 setImageWithURL:[NSURL URLWithString:photo4[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [self.image5 setImageWithURL:[NSURL URLWithString:photo5[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [self.image6 setImageWithURL:[NSURL URLWithString:photo6[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
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
