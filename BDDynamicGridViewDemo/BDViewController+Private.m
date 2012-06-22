//
//  BDViewController+Private.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController+Private.h"

@implementation BDViewController (Private)

-(void)_loadSampleDataWithCompletion:(void (^)(NSArray *))completion
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        NSArray *images = [NSArray array];
        NSBundle *bundle = [NSBundle mainBundle];
        for (int i=0; i< 25; i++) {
            NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%d", i + 1] ofType:@"jpg"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            if (image) {
                images = [images arrayByAddingObject:image];
            }
        }
        completion(images);
    });
    
}
@end
