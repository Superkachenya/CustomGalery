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

+ (PHFetchResult *)galleryPhotoFetchResult {
    PHFetchResult *result;
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.fetchLimit = 1;
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    result = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    return result;
}


- (void)getMorePhotos {
    
}
@end
