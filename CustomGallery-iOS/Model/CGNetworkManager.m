//
//  CGInstagramDataSource.m
//  CustomGallery-iOS
//
//  Created by Danil on 17.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "CGNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "CGInstaPhoto.h"

NSString *const baseURL = @"https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=1437246039.1677ed0.34e4c20d2961470a89784c8ac03d0ae4";

@implementation CGNetworkManager

+ (instancetype)sharedManager {
    static CGNetworkManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}


- (void)downloadPhotosWithCompletionBlock:(Completion)block; {
    Completion copyBlock = [block copy];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __block NSDictionary *parameters = nil;
    [manager GET:baseURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [responseObject valueForKeyPath:@"pagination.next_max_tag_id"];
        NSString *nextPageId = [string substringFromIndex:2];
        parameters = @{@"&max_tag_id=" : nextPageId};
        //NSLog(@"%@", pagination);
        NSArray *data = responseObject[@"data"];
        NSMutableArray *result = [NSMutableArray new];
        for (id post in data) {
            NSDictionary *image = (NSDictionary *)post[@"images"];
            CGInstaPhoto *photo = [CGInstaPhoto new];
            [photo parsePhoto:image];
            [result addObject:photo];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            copyBlock (nil, result);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        copyBlock(error, nil);
    }];
}
@end
