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
   
    self.rowHeight = 100;
    self.delegate = self;
    
    self.onLongPress = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Long press on %@, at %d", view, viewIndex);
    };

    self.onDoubleTap = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Double tap on %@, at %d", view, viewIndex);
    };

    self.gridLayoutStyle = BDDynamicGridLayoutStyleFill;
    
    [super viewDidLoad];
    
    [self _loadSampleDataWithCompletion:^(NSArray *images) {
        _items = images; 
        [self reloadData];
    }];
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    imageView.image = img;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //Call super when overriding this method, in order to benefit from auto layout.
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

@end
