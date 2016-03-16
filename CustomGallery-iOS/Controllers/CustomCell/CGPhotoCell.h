//
//  CGPhotoCell.h
//  CustomGallery-iOS
//
//  Created by Danil on 15.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGPhotoCell : UICollectionViewCell

- (void)configureCellWithImage:(UIImage *)image;
- (CGSize)targetSize;
@end
