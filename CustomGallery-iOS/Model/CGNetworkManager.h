//
//  CGInstagramDataSource.h
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

@import Foundation;

typedef void(^Completion)(NSError *error, NSMutableArray *photos);

@interface CGNetworkManager : NSObject

+ (instancetype)sharedManager;
- (void)downloadPhotosWithCompletionBlock:(Completion)block;

@end
