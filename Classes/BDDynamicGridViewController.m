//
//  BDDynamicGridViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/23/12.
//
//  Copyright (c) 2012, Norsez Orankijanan (Bluedot) All Rights Reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, 
//  this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, 
//  this list of conditions and the following disclaimer in the documentation 
//  and/or other materials provided with the distribution.
//
//  3. Neither the name of Bluedot nor the names of its contributors may be used 
//  to endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.

#import "BDDynamicGridViewController.h"
#import "BDDynamicGridCell.h"
#import "BDRowInfo.h"
#define kDefaultBorderWidth 5



@interface BDDynamicGridViewController  () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_rowInfos;
}
@end

@implementation BDDynamicGridViewController
- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {}
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.borderWidth = kDefaultBorderWidth;
    self.view.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_tableView];
    [self reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [_tableView reloadData];
    return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowInfos.count;
}


- (void)reloadData
{
    //rearrange views on the table by recalculating row infos
    _rowInfos = [NSArray new];
    NSUInteger accumNumOfViews = 0;
    BDRowInfo * ri;
    NSUInteger kMaxViewsPerCell = self.delegate.maximumViewsPerCell;
    NSUInteger kMinViewsPerCell = 1;
    
    if ([self.delegate respondsToSelector:@selector(minimumViewsPerCell)]) {
        kMinViewsPerCell = self.delegate.minimumViewsPerCell==0?1:self.delegate.minimumViewsPerCell;
    }
    
    NSAssert(kMinViewsPerCell <= kMaxViewsPerCell, @"Minimum number of views per row cannot be greater than maximum number of views per row.");
    
    while (accumNumOfViews < self.delegate.numberOfViews) {
        NSUInteger numOfViews = (arc4random() % kMaxViewsPerCell) + kMinViewsPerCell;   
        if (numOfViews > kMaxViewsPerCell) {
            numOfViews = kMaxViewsPerCell;
        }
        numOfViews = (accumNumOfViews+numOfViews <= self.delegate.numberOfViews)?numOfViews:(self.delegate.numberOfViews-accumNumOfViews);
        ri = [BDRowInfo new];
        ri.order = _rowInfos.count;
        ri.accumulatedViews = accumNumOfViews;
        ri.viewsPerCell = numOfViews;
        accumNumOfViews = accumNumOfViews + numOfViews;
        _rowInfos = [_rowInfos arrayByAddingObject:ri];
    }
    ri.isLastCell = YES;
    NSAssert(accumNumOfViews == self.delegate.numberOfViews, @"wrong accum %@ ", ri.accumulatedViews);
    [_tableView reloadData];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BDDynamicGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BDDynamicGridCell alloc] initWithLayoutStyle:BDDynamicGridCellLayoutStyleFill
                                              reuseIdentifier:CellIdentifier];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        longPress.numberOfTouchesRequired = 1;
        [cell.contentView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [cell.contentView addGestureRecognizer:doubleTap];
    }
    
    //clear for updated list of views
    [cell setViews:nil];
    cell.viewBorderWidth = self.borderWidth;
    BDRowInfo *ri = [_rowInfos objectAtIndex:indexPath.row];
    cell.rowInfo = ri;
    NSArray * viewsForRow = [NSArray array];
    for (int i=0; i<ri.viewsPerCell; i++) {
        viewsForRow = [viewsForRow arrayByAddingObject:[self.delegate viewAtIndex:i + ri.accumulatedViews rowInfo:ri]];
    }
    NSAssert(viewsForRow.count > 0, @"number of views per row must be greater than 0");
    [cell setViews:viewsForRow];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
    return [self.delegate rowHeightForRowInfo:rowInfo];
}

#pragma mark - events

- (void)gesture:(UIGestureRecognizer*)gesture view:(UIView**)view viewIndex:(NSInteger*)viewIndex
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        BDDynamicGridCell *cell = (BDDynamicGridCell*) [gesture.view superview];
        
        CGPoint tapPoint = [gesture locationInView:gesture.view];
        NSArray *viewsSortedByXDesc = [gesture.view.subviews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            UIView * v1 = obj1;
            UIView * v2 = obj2;
            return v1.frame.origin.x - v2.frame.origin.x;
        }];
        
        if (viewsSortedByXDesc.count == 1) {   
            *view = [viewsSortedByXDesc objectAtIndex:0];
            *viewIndex = (cell.rowInfo.accumulatedViews);
            return;
        }
        
        UIView * tappedView = nil;
        NSUInteger index = 0;
        for (int i=1; i<viewsSortedByXDesc.count; i++) {
            UIView * prevView = [viewsSortedByXDesc objectAtIndex:i-1];
            UIView * curView = [viewsSortedByXDesc objectAtIndex:i];
            if (prevView.frame.origin.x < tapPoint.x &&
                tapPoint.x < curView.frame.origin.x) {
                tappedView = curView;
                index = i;
            }
        }
        if (tappedView==nil) {
            tappedView = [viewsSortedByXDesc objectAtIndex:0];
            index = viewsSortedByXDesc.count ;
        }
        
        index = index - 1;
        
        *view = tappedView;
        *viewIndex = ((cell.rowInfo.accumulatedViews) + index);
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateRecognized) {
        UIView *view = nil;
        NSInteger viewIndex = -1;
        [self gesture:longPress view:&view viewIndex:&viewIndex];
        if (self.onLongPress) {
            self.onLongPress(view, viewIndex);
        }
    }

}

- (void)didDoubleTap:(UITapGestureRecognizer*)doubleTap
{
    if (doubleTap.state == UIGestureRecognizerStateRecognized) {
        UIView *view = nil;
        NSInteger viewIndex = -1;
        [self gesture:doubleTap view:&view viewIndex:&viewIndex];
        if (self.onDoubleTap) {
            self.onDoubleTap(view, viewIndex);
        }
    }

}


@synthesize borderWidth;
@synthesize delegate;
@synthesize onLongPress;
@synthesize onDoubleTap;

@end
