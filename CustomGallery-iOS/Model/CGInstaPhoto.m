//
//  CGInstaPhoto.m
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGInstaPhoto.h"

@implementation CGInstaPhoto

- (instancetype)initWithJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        self.largePhotoURL = [NSURL URLWithString:[JSON valueForKeyPath:@"standard_resolution.url"]];
        self.thumbnailURL = [NSURL URLWithString:[JSON valueForKeyPath:@"thumbnail.url"]];
    }
    return self;
}

@end
