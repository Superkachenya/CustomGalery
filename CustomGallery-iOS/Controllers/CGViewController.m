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

@interface CGViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CGViewController

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGPhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    return cell;
}
@end