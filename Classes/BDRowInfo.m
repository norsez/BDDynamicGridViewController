//
//  BDRowInfo.m
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



#import "BDRowInfo.h"

@implementation BDRowInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Row %d has %d views, and %d views before.>", order, viewsPerCell, accumulatedViews];
}

#define kVIEWS_PER_CELL 						@"viewsPerCell"
#define kACCUMULATED_VIEWS 						@"accumulatedViews"
#define kORDER 						@"order"
#define kIS_LAST_CELL 						@"isLastCell"



//=========================================================== 
//  Keyed Archiving
//
//=========================================================== 
- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeInteger:self.viewsPerCell forKey:kVIEWS_PER_CELL];
    [encoder encodeInteger:self.accumulatedViews forKey:kACCUMULATED_VIEWS];
    [encoder encodeInteger:self.order forKey:kORDER];
    [encoder encodeBool:self.isLastCell forKey:kIS_LAST_CELL];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        self.viewsPerCell = [decoder decodeIntegerForKey:kVIEWS_PER_CELL];
        self.accumulatedViews = [decoder decodeIntegerForKey:kACCUMULATED_VIEWS];
        self.order = [decoder decodeIntegerForKey:kORDER];
        self.isLastCell = [decoder decodeBoolForKey:kIS_LAST_CELL];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = nil;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    if (data)
        theCopy = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return theCopy;
}

- (id)copy
{
    return [self copyWithZone:nil];
}

@synthesize order;
@synthesize accumulatedViews;
@synthesize viewsPerCell;
@synthesize isLastCell;
@end