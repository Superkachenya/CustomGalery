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

@interface CGViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult *assetsFetchResults;
@property (strong, nonatomic) PHImageManager *imageManager;

@end

@implementation CGViewController

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    self.imageManager = [PHImageManager defaultManager];
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
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    CGPhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:[cell targetSize]
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  [cell configureCellWithImage:result];
                              }];
    return cell;
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) {
        return nil;
    }
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toPhotoPresentationVC]) {
        CGAssetViewController *assetViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        assetViewController.asset = self.assetsFetchResults[indexPath.item];
    }
}

@end