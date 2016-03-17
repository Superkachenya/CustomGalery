//
//  CGAssetViewController.m
//  CustomGallery-iOS
//
//  Created by Danil on 16.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGAssetViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CGInstaPhoto.h"

@interface CGAssetViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CGAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.photo.largePhoto];
    [self.imageView sd_setImageWithURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale == scrollView.minimumZoomScale) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

@end
