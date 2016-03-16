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

@interface CGViewController () <PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult *assetsFetchResults;
@property (strong, nonatomic) PHAssetCollection *assetCollection;
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
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.collectionView.collectionViewLayout = [CGCollectionViewFlowLayout new];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (!collectionChanges) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.assetsFetchResults = [collectionChanges  fetchResultAfterChanges];
        UICollectionView *collectionView = self.collectionView;
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            [collectionView reloadData];
        } else {
            [collectionView performBatchUpdates:^{
                NSIndexSet *removed = [collectionChanges removedIndexes];
                if (removed.count) {
                    [collectionView deleteItemsAtIndexPaths:@[removed]];
                }
                NSIndexSet *inserts = [collectionChanges insertedIndexes];
                if (inserts.count) {
                    [collectionView insertItemsAtIndexPaths:@[inserts]];
                }
                NSIndexSet *changes = [collectionChanges changedIndexes];
                if (changes.count) {
                    [collectionView reloadItemsAtIndexPaths:@[changes]];
                }
            } completion:nil];
        }
    });
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toPhotoPresentationVC]) {
        CGAssetViewController *assetViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        assetViewController.asset = self.assetsFetchResults[indexPath.item];
    }
}

@end