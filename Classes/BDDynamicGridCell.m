//
//  BDDynamicGridCell.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/23/12.
//  Created by Nor Oh on 6/21/12.
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



#import "BDDynamicGridCell.h"
@interface BDDynamicGridCell(){
    UIView * _gridContainerView;
    BOOL _doneInitialLayout;
}
@end

@implementation BDDynamicGridCell

- (id)init
{
    self = [self initWithStyle:0 reuseIdentifier:@"GridCell"];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _gridContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _gridContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
        [self.contentView addSubview:_gridContainerView];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
    }
    return self;
}

- (id)initWithLayoutStyle:(BDDynamicGridCellLayoutStyle)layoutStyle reuseIdentifier:(NSString *)cellId
{
    self = [self initWithStyle:0 reuseIdentifier:cellId];
    if (self) {
        _layoutStyle=layoutStyle;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews{
    [self layoutSubviewsAnimated:NO];
}

- (void)layoutSubviewsAnimated:(BOOL)animated
{
    [super layoutSubviews];
    
    if (_doneInitialLayout && animated == NO) {
        return;
    }
    
    _gridContainerView.frame = CGRectMake(0, 0, 
                                          self.contentView.frame.size.width, 
                                          self.contentView.frame.size.height);
    NSArray * oldFrames = [NSArray array];
    if (animated) {
        for (int i=0; i<_gridContainerView.subviews.count; i++){
            UIView* subview = [_gridContainerView.subviews objectAtIndex:i];
            oldFrames = [oldFrames arrayByAddingObject:[NSValue valueWithCGRect:subview.frame]];
        }
    }
    
    //layout what's in the cell
    CGFloat aRowHeight = self.frame.size.height;
    CGFloat totalWidth = 0;
    for (int i=0; i<_gridContainerView.subviews.count; i++){
        UIView* subview = [_gridContainerView.subviews objectAtIndex:i];
        //assume that for UIImageView, the size we want is the image size
        if ([subview isKindOfClass:[UIImageView class]]){
            UIImageView *iv = (UIImageView*)subview;
            if (iv.image != nil && iv.image.size.width > 0) {
                iv.frame = CGRectMake(0, 0, iv.image.size.width, iv.image.size.height);
            }
        }
        totalWidth = totalWidth + subview.frame.size.width;
    }
    
    CGFloat widthScaling =  ((_gridContainerView.frame.size.width - ((_gridContainerView.subviews.count+1) * self.viewBorderWidth ))/totalWidth);
    CGFloat accumWidth = self.viewBorderWidth;
    //UIView* lastView;
    NSArray *newFrames = [NSArray array];
    for (int i=0; i<_gridContainerView.subviews.count; i++){
        UIView* subview = [_gridContainerView.subviews objectAtIndex:i];
        CGRect newFrame = subview.frame;
        newFrame = CGRectMake(0, 0, newFrame.size.width * widthScaling, aRowHeight - self.viewBorderWidth);
        CGFloat leftMargin = i==0?0:(self.viewBorderWidth);
        newFrame = CGRectOffset(newFrame, accumWidth + leftMargin, 0);
        newFrame = CGRectIntegral(newFrame);
        accumWidth = accumWidth + newFrame.size.width + leftMargin;
        //lastView = subview;
        newFrames = [newFrames arrayByAddingObject:[NSValue valueWithCGRect:newFrame]];
    }
    
    if (!animated) {
        for (int i=0; i<_gridContainerView.subviews.count; i++){
            UIView* subview = [_gridContainerView.subviews objectAtIndex:i];
            NSValue* newFrame = [newFrames objectAtIndex:i];
            subview.frame = [newFrame CGRectValue];
            //[subview setNeedsLayout];
        }
        _doneInitialLayout = YES;
    }else {
        for (int i=0; i<_gridContainerView.subviews.count; i++){
            UIView* subview = [_gridContainerView.subviews objectAtIndex:i];
            NSValue* oldFrame = [oldFrames objectAtIndex:i];
            subview.frame = [oldFrame CGRectValue];
        }
        [UIView animateWithDuration:1.f
                         animations:^{
                             for (int i=0; i<_gridContainerView.subviews.count; i++){
                                 UIView* subview = [_gridContainerView.subviews objectAtIndex:i];
                                 NSValue* newFrame = [newFrames objectAtIndex:i];
                                 subview.frame = [newFrame CGRectValue];
                                 //[subview setNeedsLayout];
                             }
                         }];
    }
}

-(void)setViews:(NSArray *)views
{   
    //remove all subviews.
    if (views == nil || views.count == 0) {
        for (UIView* sb in _gridContainerView.subviews) {
            [sb removeFromSuperview];
        }
        return;
    }
    
    for(UIView * sv in views){
        sv.contentMode = UIViewContentModeScaleAspectFill;
        [_gridContainerView addSubview:sv];
    }

    //[self setNeedsLayout];
}


@synthesize layoutStyle=_layoutStyle;
@synthesize viewBorderWidth;
@synthesize rowInfo;
@synthesize gridContainerView=_gridContainerView;
@end
