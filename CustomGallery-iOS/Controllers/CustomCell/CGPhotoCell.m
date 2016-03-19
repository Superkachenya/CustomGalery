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

- (void)configureCellWithImage:(UIImage *)photo {
    self.photoThumb.image = photo;
}

@end
