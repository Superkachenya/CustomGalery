//
//  CGInstaPhoto.h
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface CGInstaPhoto : NSObject

@property (strong, nonatomic) NSURL *largePhotoURL;
@property (strong, nonatomic) NSURL *thumbnailURL;

- (void)parsePhoto:(NSDictionary *)photo;


@end
