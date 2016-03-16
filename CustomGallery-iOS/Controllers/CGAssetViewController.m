//
//  CGAssetViewController.m
//  CustomGallery-iOS
//
//  Created by Danil on 16.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGAssetViewController.h"

@interface CGAssetViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CGAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PHImageManager defaultManager]requestImageForAsset:self.asset
                                              targetSize:[self targetSize]
                                             contentMode:PHImageContentModeAspectFit
                                                 options:nil
                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                               if (result) {
                                                   self.imageView.image = result;
                                               }
                                           }];
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.imageView.bounds) * scale,
                                   CGRectGetHeight(self.imageView.bounds) * scale);
    return targetSize;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
