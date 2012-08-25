//
//  BDDynamicGridViewDelegate.h
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
@class BDRowInfo;
@protocol BDDynamicGridViewDelegate <NSObject>

/**
 @return the maximum number of views for each row.
 */
- (NSUInteger)maximumViewsPerCell;

/**
 @return The number of views in total.
 */
- (NSUInteger)numberOfViews;


/**
 This method is called to retreive the view for displayed at the specified index.
 @param index the index of the view
 @param rowInfo the information of the row this view appears in.
 @return the UIView to display at specified index.
 */
- (UIView*) viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo*)rowInfo;



@optional

/**
 Instead of letting BDDynamicGridViewController decide layout, you
 can supply the class with your own layout by implementing this method.
 
 If this method is implemented, -maximumViewsPerCell and -numberOfViews have
 no effect.
 
 @return an array of BDRowInfo describing your own layout.
 */
- (NSArray*) customLayout;


/**
 Minimum number of views per row.
 1 is default if not implemented or when returning zero.
 */
- (NSUInteger)minimumViewsPerCell;

/**
 This method is called when long press is recognized.
 */
- (void)longPressDidBeginAtView:(UIView*)view index:(NSUInteger)index;
/**
 This method is called when long press ends and before the onLongPress block is executed.
 */
- (void)longPressDidEndAtView:(UIView*)view index:(NSUInteger)index;


/**
 @name Scrolling events
 
 In order to help optimize view loading, the class provides these methods that
 get called when events happen.
 */

/**
 This method gets called when grid view is scrolled with some velocity.
 Easy scrolling will not trigger this call.
 */
- (void) gridViewWillStartScrolling;

/**
 This method gets called when grid view's scrolling is going to halt.
 */
- (void) gridViewWillEndScrolling;


/**
 This method gets called when grid view's scrolling comes to a halt.
 */
- (void) gridViewDidEndScrolling;


/**
 This method is called to determine the height of the specified row.
 @param rowInfo the row which the grid view needs to know its height.
 @return height of row in CGFloat.
 */
- (CGFloat) rowHeightForRowInfo:(BDRowInfo*)rowInfo;

/**
 This method is calleed when the specified row is about to be displayed.
 @param rowInfo the row about to be displayed.
 */
- (void)willDisplayRow:(BDRowInfo*)rowInfo;

@end
