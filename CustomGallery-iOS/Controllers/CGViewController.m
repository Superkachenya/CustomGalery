//
//  ViewController.m
//  CustomGallery-iOS
//
//  Created by Danil on 11.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGViewController.h"
#import <Photos/Photos.h>
#import "CGPhotoCell.h"
#import "CGStoryboardConstants.h"
#import "CGAssetViewController.h"
#import "CGCollectionViewFlowLayout.h"
#import "CGPersistanceDataSource.h"
#import "CGNetworkManager.h"
#import "CGInstaPhoto.h"

@interface CGViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *instaArray;

@end

@implementation CGViewController

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downloadFromNetwork];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    return self.instaArray.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGPhotoCell *cell = nil;
    if (indexPath.row == self.instaArray.count) {
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoLoadingIdentifier
                                                              forIndexPath:indexPath];
        [cell.activity startAnimating];
    } else {
        CGInstaPhoto *instaPhoto = self.instaArray[indexPath.item];
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier
                                                              forIndexPath:indexPath];
        [cell configureCellWithImage:instaPhoto];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.instaArray.count - 1) {
        [self downloadFromNetwork];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toPhotoPresentationVC]) {
        CGAssetViewController *assetViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        assetViewController.photo = self.instaArray[indexPath.item];
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

@end