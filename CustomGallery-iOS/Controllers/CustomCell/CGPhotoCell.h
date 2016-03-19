//
//  CGPhotoCell.h
//  CustomGallery-iOS
//
//  Created by Danil on 15.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

@import UIKit;
@class CGInstaPhoto;

@interface CGPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (void)configureCellWithImage:(UIImage *)photo;
- (CGSize)targetSize;

@end
