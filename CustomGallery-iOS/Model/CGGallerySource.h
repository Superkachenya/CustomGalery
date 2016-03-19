//
//  CGPersistanceDataSource.h
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

@import Foundation;

typedef void(^CompletionGallery)(NSMutableArray *photos);

@interface CGGallerySource : NSObject

+ (instancetype)sharedManager;
- (void)getAllPhotosFromGalleryWithCompletionBlock:(CompletionGallery)block;

@end
