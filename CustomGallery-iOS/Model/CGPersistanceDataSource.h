//
//  CGPersistanceDataSource.h
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionGallery)(NSMutableArray *photos);
@interface CGPersistanceDataSource : NSObject

+ (instancetype)sharedManager;
- (void)getAllPhotosFromCameraWithCompletionBlock:(CompletionGallery)block;

@end
