//
//  CGInstaPhoto.m
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGInstaPhoto.h"

@implementation CGInstaPhoto

- (void)parsePhoto:(NSDictionary *)photo {
    self.largePhotoURL = [NSURL URLWithString:[photo valueForKeyPath:@"standard_resolution.url"]];
    self.thumbnailURL = [NSURL URLWithString:[photo valueForKeyPath:@"thumbnail.url"]];
}

@end
