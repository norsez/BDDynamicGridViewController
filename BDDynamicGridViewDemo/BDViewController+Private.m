//
//  BDViewController+Private.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController+Private.h"
#define kNumberOfPhotos 25
@implementation BDViewController (Private)

-(NSArray*)_imagesFromBundle
{   
    NSArray *images = [NSArray array];
    NSBundle *bundle = [NSBundle mainBundle];
    for (int i=0; i< kNumberOfPhotos; i++) {
        NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%d", i + 1] ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            images = [images arrayByAddingObject:image];
        }
    }
    return images;
}


- (void)_demoAsyncDataLoading
{
    _items = [NSArray array];
    //load the placeholder image
    for (int i=0; i < kNumberOfPhotos; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake(0, 0, self.rowHeight, self.rowHeight);
        imageView.clipsToBounds = YES;
        _items = [_items arrayByAddingObject:imageView];
    }
    [self reloadData];
    NSArray *images = [self _imagesFromBundle];
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [_items objectAtIndex:i];
        UIImage *image = [images objectAtIndex:i];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [UIView animateWithDuration:0.5 
                         animations:^{
                             imageView.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             imageView.image = image;
                             [UIView animateWithDuration:0.5
                                              animations:^{
                                                  imageView.alpha = 1;
                                                  
                                              }];
                         }];
        
        
    }
}

@end
