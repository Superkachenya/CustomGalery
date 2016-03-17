//
//  CGInstaPhoto.m
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGInstaPhoto.h"

@interface CGInstaPhoto ()

@end

@implementation CGInstaPhoto

- (void)parsePhoto:(NSDictionary *)photo {
    self.largePhoto = [photo valueForKeyPath:@"standard_resolution.url"];
    self.thumbnailPhoto = [photo valueForKeyPath:@"standard_resolution.url"];
}

@end
