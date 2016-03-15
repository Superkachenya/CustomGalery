//
//  CGPhotoCell.m
//  CustomGallery-iOS
//
//  Created by Danil on 15.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGPhotoCell.h"

@interface CGPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoThumb;

@end

@implementation CGPhotoCell

- (void)configureCellWithImage:(UIImage *)image {
    self.photoThumb.image = image;
}

@end
