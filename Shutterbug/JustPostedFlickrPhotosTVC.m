//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Admin on 29.10.15.
//  Copyright (c) 2015 Stanford. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
}

- (IBAction)fetchPhotos {
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResult = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                           options:0
                                                                             error:NULL];
        //NSLog(@"Flickr Result = %@", propertyListResult);
        NSArray *photos = [propertyListResult valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
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
