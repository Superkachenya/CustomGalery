//
//  ViewController.m
//  CustomGallery-iOS
//
//  Created by Danil on 11.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGGridViewController.h"
#import "CGPhotoCell.h"
#import "CGStoryboardConstants.h"
#import "CGSingleImageViewController.h"
#import "CGCollectionViewFlowLayout.h"
#import "CGGallerySource.h"
#import "CGNetworkManager.h"
#import "CGInstaPhoto.h"

NS_ENUM(NSInteger, CGSegmentedControlTypes) {
    CGSegmentedControlTypeGallery,
    CGSegmentedControlTypeInstagram
};

NSUInteger const kLoadedphotos = 21;

@interface CGGridViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *CGSegmentedControl;

@property (assign, nonatomic) NSUInteger offset;
@property (strong, nonatomic) NSMutableArray *instaArray;
@property (strong, nonatomic) NSMutableArray *galleryArray;

@end

@implementation CGGridViewController

#pragma mark - UIViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = kLoadedphotos;
    
    [self downloadFromNetwork];
    [self downloadFromGallery];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.collectionView.collectionViewLayout = [CGCollectionViewFlowLayout new];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeInstagram) {
        return self.offset;
    } else {
        return self.galleryArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGPhotoCell *cell = nil;
    UIImage *image = nil;
    CGInstaPhoto *instaPhoto = nil;
    switch (self.CGSegmentedControl.selectedSegmentIndex) {
        case CGSegmentedControlTypeGallery:
            image = self.galleryArray[indexPath.item];
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier
                                                                  forIndexPath:indexPath];
            [cell configureCellWithImage:image];
            break;
        case CGSegmentedControlTypeInstagram:
            instaPhoto = self.instaArray[indexPath.item];
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier
                                                                  forIndexPath:indexPath];
            [cell configureCellWithPhoto:instaPhoto];
            break;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeInstagram) {
        if (indexPath.row == self.instaArray.count - 1) {
            self.offset += kLoadedphotos;
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
            CGInstaPhoto *instaPhoto = self.instaArray[indexPath.item];
            assetViewController.picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:instaPhoto.largePhotoURL]];
        } else if (self.CGSegmentedControl.selectedSegmentIndex == CGSegmentedControlTypeGallery) {
            assetViewController.picture = self.galleryArray[indexPath.item];
        }
    }
}

- (void)downloadFromNetwork {
    [[CGNetworkManager sharedManager] downloadPhotosWithCompletionBlock:^(NSError *error, NSMutableArray *instaPhotos) {
        if (error) {
            [self initiateAlertWithError:error];
        } else {
            if (!self.instaArray) {
                self.instaArray = [NSMutableArray new];
            }
            [self.instaArray addObjectsFromArray:instaPhotos];
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
    
    [self.collectionView reloadData];
}

- (void)initiateAlertWithError:(NSError *)error {
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
    
}

@end