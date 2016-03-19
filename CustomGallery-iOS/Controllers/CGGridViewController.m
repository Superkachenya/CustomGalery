//
//  ViewController.m
//  CustomGallery-iOS
//
//  Created by Danil on 11.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGGridViewController.h"
#import <Photos/Photos.h>
#import "CGPhotoCell.h"
#import "CGStoryboardConstants.h"
#import "CGSingleImageViewController.h"
#import "CGCollectionViewFlowLayout.h"
#import "CGGallerySource.h"
#import "CGNetworkManager.h"
#import "CGInstaPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

NS_ENUM(NSInteger, CGSegmentedControlTypes) {
    CGSegmentedControlTypeGallery,
    CGSegmentedControlTypeInstagram
};

@interface CGGridViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *instaArray;
@property (strong, nonatomic) NSMutableArray *galleryArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *CGSegmentedControl;
@property (strong, nonatomic) SDWebImageManager *manager;

@end

@implementation CGGridViewController

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadFromNetwork];
    [self downloadFromGallery];
    self.manager = [SDWebImageManager sharedManager];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.collectionView.collectionViewLayout = [CGCollectionViewFlowLayout new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeInstagram) {
        return self.instaArray.count +1;
    } else {
        return self.galleryArray.count;

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGPhotoCell *cell = nil;
        if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeInstagram) {
            if (indexPath.row == self.instaArray.count) {
                cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoLoadingIdentifier
                                                                      forIndexPath:indexPath];
                [cell.activity startAnimating];
            } else {
            CGInstaPhoto *instaPhoto = self.instaArray[indexPath.item];
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier
                                                                  forIndexPath:indexPath];
            [self.manager downloadImageWithURL:instaPhoto.thumbnailURL
                                       options:SDWebImageProgressiveDownload
                                      progress:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                         [cell configureCellWithImage:image];
                                     }];
            }
        } else if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeGallery) {
            UIImage *image = self.galleryArray[indexPath.item];
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier
                                                                  forIndexPath:indexPath];
            [cell configureCellWithImage:image];
        }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.instaArray.count - 1) {
        if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeInstagram) {
            [self downloadFromNetwork];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toPhotoPresentationVC]) {
        CGSingleImageViewController *assetViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeInstagram) {
            assetViewController.photo = self.instaArray[indexPath.item];
        } else if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeGallery) {
            assetViewController.picture = self.galleryArray[indexPath.item];
        }
    }
}

- (void)downloadFromNetwork {
    [[CGNetworkManager sharedManager] downloadPhotosWithCompletionBlock:^(NSError *error, NSMutableArray *photos) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [alert dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                           }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            if (!self.instaArray) {
                self.instaArray = [NSMutableArray new];
            }
            [self.instaArray addObjectsFromArray:photos];
            [self.collectionView reloadData];
        }
    }];
    
}

- (void)downloadFromGallery {
    [[CGGallerySource sharedManager] getAllPhotosFromGalleryWithCompletionBlock:^(NSMutableArray *photos) {
        if (!self.galleryArray) {
            self.galleryArray = [NSMutableArray new];
        }
        self.galleryArray = photos;
        [self.collectionView reloadData];
    }];
}

- (IBAction)segmentedControlDidChangeIndex:(id)sender {
    switch (self.CGSegmentedControl.selectedSegmentIndex) {
        case CGSegmentedControlTypeGallery:
            NSLog (@"GALLERY YO");
            [self.collectionView reloadData];
            break;
            
        case CGSegmentedControlTypeInstagram:
            NSLog(@"INSTA YO");
            [self.collectionView reloadData];
            break;
    }
}
@end