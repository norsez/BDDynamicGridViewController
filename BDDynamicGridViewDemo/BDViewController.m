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
    [self _demoAsyncDataLoading];
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
    UIImageView * imageView = [_items objectAtIndex:index];
    return imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //Call super when overriding this method, in order to benefit from auto layout.
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

@end
