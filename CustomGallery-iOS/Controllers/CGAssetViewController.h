//
//  CGAssetViewController.h
//  CustomGallery-iOS
//
//  Created by Danil on 16.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class CGInstaPhoto;

@interface CGAssetViewController : UIViewController

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) CGInstaPhoto *photo;

@end
