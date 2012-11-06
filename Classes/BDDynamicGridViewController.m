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
    _tableView.frame = self.view.bounds;
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

- (void)setBackgroundColor:(UIColor *)color
{
    _tableView.backgroundColor = color;
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


- (NSArray *)rowInfos
{
    NSArray *result = [NSArray array];
    for (BDRowInfo* rowInfo in _rowInfos) {
        result = [result arrayByAddingObject:[rowInfo copy]];
    }
    return _rowInfos;
}

- (NSArray *)visibleRowInfos
{
    NSArray *indexPaths = [_tableView indexPathsForVisibleRows];
    NSArray *result = [NSArray array];
    for (NSIndexPath *idp in indexPaths) {
        BDRowInfo *rowInfo = [_rowInfos objectAtIndex:idp.row];
        result = [result arrayByAddingObject:[rowInfo copy]];
    }
    return result;
}

- (void)reloadRows:(NSArray *)rowInfos
{
    NSArray *indexPaths = [NSArray array];
    for (BDRowInfo *row in rowInfos) {
        indexPaths = [indexPaths arrayByAddingObject: [NSIndexPath indexPathForRow:row.order inSection:0]];
    }
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadData
{
    if (self.delegate == nil) {
        return;
    }
    
    if (![self.delegate respondsToSelector:@selector(customLayout)]) {
        //rearrange views on the table by recalculating row infos
        _rowInfos = [NSArray new];
        NSUInteger accumNumOfViews = 0;
        BDRowInfo * ri;
        NSUInteger kMaxViewsPerCell = self.delegate.maximumViewsPerCell;
        NSAssert(kMaxViewsPerCell>0, @"Maximum number of views per cell must be greater than zero");
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
        NSAssert(accumNumOfViews == self.delegate.numberOfViews, @"wrong accum %u ", ri.accumulatedViews);
    }else{
        _rowInfos = [self.delegate customLayout];
    }
    [_tableView reloadData];
}

- (void)reloadDataWithGridPattern:(NSArray *)gridPattern
{
    if  (gridPattern.count == 0){
        [self reloadData];
        return;
    }else {
        //rearrange views on the table by recalculating row infos
        _rowInfos = [NSArray new];
        NSUInteger accumNumOfViews = 0;
        BDRowInfo * ri;
        
        int patternIndex = 0;
        while (accumNumOfViews < self.delegate.numberOfViews) {
            NSNumber* number  = [gridPattern objectAtIndex:(patternIndex++)%gridPattern.count];
            NSAssert(number.integerValue != 0, @"Grid pattern can't contains a zero size row.");
            NSUInteger numOfViews = number.integerValue;
            numOfViews = (accumNumOfViews+numOfViews <= self.delegate.numberOfViews)?numOfViews:(self.delegate.numberOfViews-accumNumOfViews);
            ri = [BDRowInfo new];
            ri.order = _rowInfos.count;
            ri.accumulatedViews = accumNumOfViews;
            ri.viewsPerCell = numOfViews;
            accumNumOfViews = accumNumOfViews + numOfViews;
            _rowInfos = [_rowInfos arrayByAddingObject:ri];
        }
        ri.isLastCell = YES;
        NSAssert(accumNumOfViews == self.delegate.numberOfViews, @"wrong accum %u ", ri.accumulatedViews);
        [_tableView reloadData];
    }
}


- (void)updateLayoutWithRow:(BDRowInfo *)rowInfo animiated:(BOOL)animated
{
    BDDynamicGridCell *cell = (BDDynamicGridCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowInfo.order inSection:0]];
    [cell layoutSubviewsAnimated:animated];
}

- (void)scrollToRow:(BDRowInfo *)row atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row.order
                                                         inSection:0]
                      atScrollPosition:scrollPosition animated:animated];
}

- (UIView*)viewAtIndex:(NSUInteger)index
{
    UIView *view = nil;
    BDRowInfo *findRow = [[BDRowInfo alloc] init];
    findRow.accumulatedViews = index ;
    
    if (_rowInfos.count == 0) {
        return nil;
    }
    
    //use binary search for the cell that contains the specified index
    NSUInteger indexOfRow = [_rowInfos indexOfObject:findRow
               inSortedRange:(NSRange){0, _rowInfos.count  -1}
                     options:NSBinarySearchingInsertionIndex|NSBinarySearchingLastEqual
             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                 BDRowInfo *r1 = obj1;
                 BDRowInfo *r2 = obj2;
                 return (r1.accumulatedViews+r1.viewsPerCell) - (r2.accumulatedViews + r2.viewsPerCell);
             }];
    BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexOfRow];
    
    BDDynamicGridCell *cell =  (BDDynamicGridCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowInfo.order inSection:0]];
    NSUInteger realIndex = index - rowInfo.accumulatedViews;
    view = [cell.gridContainerView.subviews objectAtIndex:realIndex];
    
    return view;
}

- (NSArray *)visibleViews
{
    NSArray* cells = [_tableView visibleCells];
    NSArray* visibleViews = [[NSArray alloc] init];
    for (BDDynamicGridCell *cell in cells) {
        visibleViews = [visibleViews arrayByAddingObjectsFromArray:cell.gridContainerView.subviews];
    }
    return visibleViews;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDRowInfo *ri = [_rowInfos objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    BDDynamicGridCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifier stringByAppendingFormat:@"_viewCount%d", ri.viewsPerCell]];
    
    if (!cell) {
        cell = [[BDDynamicGridCell alloc] initWithLayoutStyle:BDDynamicGridCellLayoutStyleFill
                                              reuseIdentifier:CellIdentifier];
        
        cell.viewBorderWidth = 1;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        longPress.numberOfTouchesRequired = 1;
        [cell.gridContainerView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delaysTouchesBegan = YES;
        [cell.gridContainerView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.delaysTouchesBegan = YES;
        [cell.gridContainerView addGestureRecognizer:singleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    //clear for updated list of views
    [cell setViews:nil];
    cell.viewBorderWidth = self.borderWidth;

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
    if ([self.delegate respondsToSelector:@selector(rowHeightForRowInfo:)]) {
        BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
        return [self.delegate rowHeightForRowInfo:rowInfo];
    }else{
        return tableView.rowHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(willDisplayRow:)]) {
        BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
        return [self.delegate willDisplayRow:rowInfo];
    }
}

- (UITableView *)tableView
{
    return _tableView;
}

#pragma mark - scrolling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    DLog(@"willdecelerate %d", decelerate);
    if([self.delegate respondsToSelector:@selector(gridViewWillEndScrolling)]){
        [self.delegate gridViewWillEndScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    DLog(@"did end decel");
    if([self.delegate respondsToSelector:@selector(gridViewDidEndScrolling)]){
        [self.delegate gridViewDidEndScrolling];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView 
                     withVelocity:(CGPoint)velocity 
              targetContentOffset:(CGPoint *)targetContentOffset
{
//    DLog(@"will end dragging vel: %@", NSStringFromCGPoint(velocity));
    if (velocity.y > 1.5) {
        if ([self.delegate respondsToSelector:@selector(gridViewWillStartScrolling)]) {
            [self.delegate gridViewWillStartScrolling];
        }
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _tableView.contentInset = contentInset;
}

-(UIEdgeInsets)contentInset
{
    return _tableView.contentInset;
}

#pragma mark - events

- (void)gesture:(UIGestureRecognizer*)gesture view:(UIView**)view viewIndex:(NSInteger*)viewIndex
{
        
    BDDynamicGridCell *cell = (BDDynamicGridCell*) [gesture.view.superview superview];
    
    CGPoint locationInGridContainer = [gesture locationInView:gesture.view];    
    for (int i=0; i < cell.gridContainerView.subviews.count; i++){
        UIView *subview = [cell.gridContainerView.subviews objectAtIndex:i];
        CGRect vincinityRect = CGRectMake(subview.frame.origin.x - self.borderWidth, 
                                         0, 
                                         subview.frame.size.width + (self.borderWidth * 2), 
                                         cell.gridContainerView.frame.size.height);
        
        if(CGRectContainsPoint(vincinityRect, locationInGridContainer)){
            *view = subview;
            *viewIndex = ((cell.rowInfo.accumulatedViews) + i );
            break;
        }
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer*)longPress
{
    
    UIView *view = nil;
    NSInteger viewIndex = -1;
    [self gesture:longPress view:&view viewIndex:&viewIndex];
    
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressDidBeginAtView:index:)]) {
            [self.delegate longPressDidBeginAtView:view index:viewIndex];
        }
    }else if (longPress.state == UIGestureRecognizerStateRecognized) {
        
        if ([self.delegate respondsToSelector:@selector(longPressDidEndAtView:index:)]) {
            [self.delegate longPressDidEndAtView:view index:viewIndex];
        }
        
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


- (void)didSingleTap:(UITapGestureRecognizer*)singleTap
{
    if (singleTap.state == UIGestureRecognizerStateRecognized) {
        UIView *view = nil;
        NSInteger viewIndex = -1;
        //DLog(@"view %@, viewIndex %d", view, viewIndex);
        [self gesture:singleTap view:&view viewIndex:&viewIndex];
        if (self.onSingleTap) {
            self.onSingleTap(view, viewIndex);
        }
    }
}

@synthesize borderWidth;
@synthesize delegate;
@synthesize onLongPress;
@synthesize onDoubleTap;
@synthesize onSingleTap;
@end
