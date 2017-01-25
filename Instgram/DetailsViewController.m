//
//  DetailsViewController.m
//  Instgram
//
//  Created by William Thai on 1/25/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "DetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tumblrImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *imgURL = [NSURL URLWithString: self.imageUrl];
    [self.tumblrImage setImageWithURL:imgURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
