//
//  CGAssetViewController.m
//  CustomGallery-iOS
//
//  Created by Danil on 16.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGSingleImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CGInstaPhoto.h"

@interface CGSingleImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CGSingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.photo) {
        [self.imageView sd_setImageWithURL:self.photo.largePhotoURL];
    } else if (self.picture) {
        self.imageView.image = self.picture;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

 @end
