//
//  ViewController.m
//  Instgram
//
//  Created by Kaeson Ho on 1/25/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "PhotosViewController.h"
#import "TumblrCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailsViewController.h"

@interface PhotosViewController ()
@property NSArray<NSDictionary *> *posts;
@property (weak, nonatomic) IBOutlet UITableView *tumblrTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tumblrTableView.dataSource = self;
    // Do any additional setup after loading the view, typically from a nib.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tumblrTableView insertSubview:self.refreshControl atIndex:0];
    [self fetchData];
}

- (void) refreshData {
    [self fetchData];
    [self.refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)movieTableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    NSLog(@"count:%lu",self.posts.count);
    return self.posts.count;
}

//configure cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString * const kCellIdentifier = @"TumblrTableViewCell";
    TumblrCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
   
    
    NSString *urlString = [[post[@"photos"] objectAtIndex: 0][@"alt_sizes"] objectAtIndex:2][@"url"];
    NSLog(@"%@", urlString);
    NSURL *imgURL = [NSURL URLWithString: urlString];
    [cell.tumblerImg setImageWithURL:imgURL];
    cell.blogName.text = post[@"blog_name"];
    return cell;
}

- (void)fetchData {
    NSString *apiKey = @"Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV";
    NSString *urlString =
    [@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=" stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    
                                                     NSLog(@"Response: %@", responseDictionary);
                                                    self.posts = responseDictionary[@"response"][@"posts"];
                                                    // NSLog(@"%@", self.posts);
                                                    [self.tumblrTableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        DetailsViewController *d = (DetailsViewController *)segue.destinationViewController;
        
        NSDictionary *post = [self.posts objectAtIndex:self.tumblrTableView.indexPathForSelectedRow.row];
        NSString *urlString = [[post[@"photos"] objectAtIndex: 0][@"alt_sizes"] objectAtIndex:2][@"url"];
        d.imageUrl = urlString;
        NSLog(@"segue id:%@", segue);
}

@end
