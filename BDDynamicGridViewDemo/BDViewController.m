//
//  BDViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController.h"
#import "BDViewController+Private.h"
#import "BDRowInfo.h"
@interface BDViewController (){
   
}
@end

@implementation BDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.delegate = self;
    
    self.onLongPress = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Long press on %@, at %d", view, viewIndex);
    };

    self.onDoubleTap = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Double tap on %@, at %d", view, viewIndex);
    };
    [super viewDidLoad];
    [self _demoAsyncDataLoading];
    
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Lay it!"
                                                                      style:UIBarButtonItemStylePlain 
                                                                     target:self 
                                                                     action:@selector(animateReload)];
    self.navigationItem.rightBarButtonItem = reloadButton;
}

- (void)animateReload
{
    _items = [NSArray new];
    [self _demoAsyncDataLoading];
}


- (NSUInteger)numberOfViews
{
    return _items.count;
}

- (NSUInteger)maximumViewsPerCell
{
    return 5;
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

- (CGFloat)rowHeightForRowInfo:(BDRowInfo *)rowInfo
{
//    if (rowInfo.viewsPerCell == 1) {
//        return 125  + (arc4random() % 55);
//    }else {
//        return 100;
//    }
    return 55 + (arc4random() % 125);
}

@end
