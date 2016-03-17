//
//  CGInstaPhoto.h
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGInstaPhoto : NSObject

@property (strong, nonatomic) NSString *largePhoto;
@property (strong, nonatomic) NSString *thumbnailPhoto;

- (void)parsePhoto:(NSDictionary *)photo;


@end
