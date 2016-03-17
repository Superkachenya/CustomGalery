//
//  CGPhotoCell.h
//  CustomGallery-iOS
//
//  Created by Danil on 15.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGInstaPhoto;

@interface CGPhotoCell : UICollectionViewCell

@property (copy, nonatomic) NSString *representedAssetIdentifier;

- (void)configureCellWithImage:(CGInstaPhoto *)photo;
- (CGSize)targetSize;

@end
