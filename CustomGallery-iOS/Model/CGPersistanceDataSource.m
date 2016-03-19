//
//  CGPersistanceDataSource.m
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Photos/Photos.h>
#import "CGPersistanceDataSource.h"

@implementation CGPersistanceDataSource

+ (instancetype)sharedManager {
    static CGPersistanceDataSource *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}
- (void)getAllPhotosFromCameraWithCompletionBlock:(CompletionGallery)block {
    CompletionGallery copyBlock = [block copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = YES;
        PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
        PHImageManager *manager = [PHImageManager defaultManager];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[result count]];
        __block UIImage *ima;
        for (PHAsset *asset in result) {
            [manager requestImageForAsset:asset
                               targetSize:PHImageManagerMaximumSize
                              contentMode:PHImageContentModeDefault
                                  options:requestOptions
                            resultHandler:^void(UIImage *image, NSDictionary *info) {
                                ima = image;
                                [images addObject:ima];
                            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            copyBlock (images);
        });
        
    });
}

@end
