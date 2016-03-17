//
//  CGPhotoCell.m
//  CustomGallery-iOS
//
//  Created by Danil on 15.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGPhotoCell.h"
#import "CGInstaPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CGPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoThumb;

@end

@implementation CGPhotoCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.photoThumb.image = nil;
}

- (void)configureCellWithImage:(CGInstaPhoto *)photo {
    NSURL *url = [NSURL URLWithString:photo.thumbnailPhoto];
    [self.photoThumb sd_setImageWithURL:url];
}

- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.photoThumb.bounds) * scale,
                                   CGRectGetHeight(self.photoThumb.bounds) * scale);
    return targetSize;
}

@end
