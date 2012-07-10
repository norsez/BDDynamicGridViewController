//
//  BDDynamicGridCell.h
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


#import <UIKit/UIKit.h>
#import "BDRowInfo.h"
/**
 Layout style
 */
enum BDDynamicGridCellLayoutStyle {
    /**
    Each view is made aspect fit.
     */
    BDDynamicGridCellLayoutStyleEven = 0,
    /**
     Each view is made aspect fill and its size varying to fill the cell.
     */
    BDDynamicGridCellLayoutStyleFill = 1
    };
typedef NSUInteger BDDynamicGridCellLayoutStyle;

/**
 This class is responsible for laying out each table row.
 */
@interface BDDynamicGridCell : UITableViewCell{
    
}
/**
 Designated Initializer.
 */
- (id)initWithLayoutStyle:(BDDynamicGridCellLayoutStyle)layoutStyle reuseIdentifier:(NSString*)cellId;


/**
 Sets UIViews the cell and lays them out in the process based on
 the cell's BDDynamicGridCellLayoutStyle. 
 
 To clear all views, set nil or zero NSArray to this method.
 */
- (void) setViews:(NSArray*)views;


- (void) layoutSubviewsAnimated:(BOOL)animated;

/**
 the cell's BDDynamicGridCellLayoutStyle.
 */
@property (nonatomic, assign, readonly) BDDynamicGridCellLayoutStyle layoutStyle;
/**
 Width of each view's border.
 */
@property (nonatomic, assign) CGFloat viewBorderWidth;
/**
 row info associated with this cell.
 */
@property (nonatomic, strong) BDRowInfo* rowInfo;

/**
 The view that grid views are contained in.
 */
@property (nonatomic, strong, readonly) UIView* gridContainerView;



@end
