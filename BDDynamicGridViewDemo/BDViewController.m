//
//  BDViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController.h"
#import "BDViewController+Private.h"
@interface BDViewController (){
    NSArray * _items;
}
@end

@implementation BDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _loadSampleDataWithCompletion:^(NSArray *images) {
        _items = images; 
        [self reloadData];
    }];
    self.rowHeight = 100;
    self.delegate = self; 
    [super viewDidLoad];
}


- (NSUInteger)numberOfViews
{
    return _items.count;
}

- (NSUInteger)numberOfColumns
{
    return 4;
}

- (UIView *)viewAtIndex:(NSUInteger)index
{
    UIImage * img = [_items objectAtIndex:index];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = img;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    return imageView;
}

@end
