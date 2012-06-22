//
//  BDDynamicGridViewController.m
//  BDDynamicGridViewDemo
//
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

@interface BDDynamicGridViewController  () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
}
@end

@implementation BDDynamicGridViewController

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
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
    self.borderWidth = 5;
    [self.view addSubview:_tableView];
    [_tableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tableView = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger total = (int) (((double)self.delegate.numberOfViews/self.delegate.numberOfColumns ));
    if (total * self.delegate.numberOfColumns < self.delegate.numberOfViews) {
        total = total + 1;
    }
    return total;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.autoresizingMask = 0;
        cell.contentView.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        longPress.numberOfTouchesRequired = 1;
        [cell.contentView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        doubleTap.numberOfTapsRequired = 2;
        [cell.contentView addGestureRecognizer:doubleTap];
    }
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    NSUInteger numberOfColumns = self.delegate.numberOfColumns;
    NSUInteger start = indexPath.row * numberOfColumns;
    NSUInteger end = MIN(start + numberOfColumns, self.delegate.numberOfViews );

    for(int i = start; i < end; i++){
        [cell.contentView addSubview:[self.delegate viewAtIndex:i]];
        cell.contentView.tag = indexPath.row;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //layout what's in the cell
    CGFloat aRowHeight = [self tableView:_tableView heightForRowAtIndexPath:indexPath];
    CGFloat totalWidth = 0;
    for (UIView* subview in cell.contentView.subviews){
        totalWidth = totalWidth + subview.frame.size.width + (self.borderWidth * 2);
    }
    CGFloat widthScaling =  (cell.contentView.frame.size.width/totalWidth);
    CGFloat accumWidth = self.borderWidth;
    
    for (UIView* subview in cell.contentView.subviews){
        subview.frame = CGRectMake(0, 0, subview.frame.size.width * widthScaling, aRowHeight - (self.borderWidth * 2.0));
        subview.frame = CGRectOffset(subview.frame, accumWidth, 0);
        accumWidth = accumWidth + subview.frame.size.width + self.borderWidth;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight>0?self.rowHeight:_tableView.rowHeight;
}

- (void)reloadData
{
    [_tableView reloadData];
}

#pragma mark - events

- (void)didTapView:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        
        NSUInteger row = tap.view.tag;
        
        CGPoint tapPoint = [tap locationInView:tap.view];
        NSArray *viewsSortedByXDesc = [tap.view.subviews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            UIView * v1 = obj1;
            UIView * v2 = obj2;
            return v1.frame.origin.x - v2.frame.origin.x;
        }];
        
        if (viewsSortedByXDesc.count == 1) {   
            if ([tap isKindOfClass:[UILongPressGestureRecognizer class]]) {
                self.onLongPress([viewsSortedByXDesc objectAtIndex:0], (row * self.delegate.numberOfColumns)); 
            }else {
                self.onDoubleTap([viewsSortedByXDesc objectAtIndex:0], (row * self.delegate.numberOfColumns)); 
            }
            
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
        
        if ([tap isKindOfClass:[UILongPressGestureRecognizer class]]) {
            self.onLongPress(tappedView, ((row * self.delegate.numberOfColumns) + index)); 
        }else {
            self.onDoubleTap(tappedView, ((row * self.delegate.numberOfColumns) + index)); 
        }
    }
}

@synthesize borderWidth;
@synthesize delegate;
@synthesize rowHeight;
@synthesize onLongPress;
@synthesize onDoubleTap;
@end
