//
//  CGPersistanceDataSource.m
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

@import Photos;
#import "CGGallerySource.h"

typedef void(^CGGalleryPermissions)(BOOL status);

@implementation CGGallerySource

+ (instancetype)sharedManager {
    static CGGallerySource *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}

- (void)getAllPhotosFromGalleryWithCompletionBlock:(CompletionGallery)block {
    CompletionGallery copyBlock = [block copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self requestPermissions:^(BOOL status) {
            if (status) {
                PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
                requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
                requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                requestOptions.synchronous = YES;
                PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
                PHImageManager *manager = [PHImageManager defaultManager];
                NSMutableArray *images = [NSMutableArray arrayWithCapacity:[result count]];
                for (PHAsset *asset in result) {
                    [manager requestImageForAsset:asset
                                       targetSize:PHImageManagerMaximumSize
                                      contentMode:PHImageContentModeDefault
                                          options:requestOptions
                                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                                        [images addObject:image];
                                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    copyBlock (images);
                });
            }
        }];
        
        
    });
}

- (void)requestPermissions:(CGGalleryPermissions)block {
    CGGalleryPermissions copyBlock = [block copy];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            copyBlock(YES);
            break;
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus) {
                if (authorizationStatus == PHAuthorizationStatusAuthorized) {
                    copyBlock(YES);
                } else {
                    copyBlock(NO);
                }
            }];
            break;
        }
        default: {
            copyBlock(NO);
            break;
        }
    }
}

@end
